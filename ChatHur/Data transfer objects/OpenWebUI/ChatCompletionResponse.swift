//
//  ChatCompletionResponse.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//

import Foundation

    // MARK: - Standard OpenAI-style Completion Response
struct StandardCompletionResponse: Codable {
    let id: String
    let created: Int
    let model: String
    let choices: [Choice]
    let object: String
    let usage: Usage  // Using your existing Usage struct
}

    // MARK: - Choice
struct Choice: Codable {
    let index: Int
    let logprobs: String?  // Can be null
    let finishReason: String
    let message: CompletionMessage
    
    enum CodingKeys: String, CodingKey {
        case index, logprobs, message
        case finishReason = "finish_reason"
    }
}

    // MARK: - OpenWebUI Full Chat Response (with all messages)
struct ChatCompletionResponse: Codable {
    let model: String
    let messages: [ChatmessageModel]  // Using existing ChatmessageModel
    let modelItem: ModelItem
    let chatId: String
    let sessionId: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case model, messages, id
        case modelItem = "model_item"
        case chatId = "chat_id"
        case sessionId = "session_id"
    }
}

    // MARK: - Helper Extensions for StandardCompletionResponse
extension StandardCompletionResponse {
        // Get the assistant's message content
    var assistantContent: String? {
        choices.first?.message.content
    }
    
        // Convert to ChatmessageModel
    func toChatMessageModel(parentId: String? = nil) -> ChatmessageModel? {
        guard let firstChoice = choices.first else { return nil }
        
        var message = ChatmessageModel(
            id: UUID().uuidString,
            parentId: parentId,
            childrenIds: [],
            role: firstChoice.message.role,
            content: firstChoice.message.content,
            timestamp: created,
            models: [model]
        )
        
        message.usage = usage
        message.done = firstChoice.finishReason == "stop"
        message.model = model
        message.modelName = model
        
        return message
    }
    
        // Check if the response is complete
    var isComplete: Bool {
        choices.first?.finishReason == "stop"
    }
}

    // MARK: - Helper Extensions for ChatCompletionResponse
extension ChatCompletionResponse {
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
