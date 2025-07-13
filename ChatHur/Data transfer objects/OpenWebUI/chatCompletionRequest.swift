//
//  chatCompletionRequest.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//


import Foundation

    // MARK: - Chat Completion Response
struct ChatCompletionRequestData: Codable {
    let model: String
    let messages: [ChatmessageModel]  // Using existing ChatmessageModel
    let modelItem: ModelItem
    let chatId: String
    let sessionId: String? = ""
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case model, messages, id
        case modelItem = "model_item"
        case chatId = "chat_id"
        case sessionId = "session_id"
    }
}

    // MARK: - Helper Extensions
extension ChatCompletionRequestData {
        // Get the last assistant message (the actual response)
    var lastAssistantMessage: ChatmessageModel? {
        messages.last { $0.role == "assistant" && !$0.content.isEmpty }
    }
    
        // Get only the new response message
    var responseMessage: ChatmessageModel? {
        lastAssistantMessage
    }
    
        // Extract the complete chat state after completion
    func updateChatState(existingMessages: [ChatmessageModel]) -> [ChatmessageModel] {
            // Find the last assistant message that was a placeholder (empty content)
        if let lastPlaceholderIndex = existingMessages.lastIndex(where: {
            $0.role == "assistant" && $0.content.isEmpty
        }) {
                // Replace the placeholder with the actual response
            var updatedMessages = existingMessages
            if let responseMsg = lastAssistantMessage {
                updatedMessages[lastPlaceholderIndex] = responseMsg
            }
            return updatedMessages
        }
        
            // If no placeholder found, append the new response
        if let responseMsg = lastAssistantMessage {
            return existingMessages + [responseMsg]
        }
        
        return existingMessages
    }
    
        // Get usage stats from the response
    var usageStats: Usage? {
        lastAssistantMessage?.usage
    }
    
        // Check if the response is complete
    var isComplete: Bool {
        lastAssistantMessage?.done ?? false
    }
}
