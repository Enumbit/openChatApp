    //
    //  OpenWebUi.swift
    //  ChatHur
    //
    //  Created by Mark Heijnekamp on 29/06/2025.
    //

import Foundation
internal import Combine

class OpenWebUi: ObservableObject{
    static var shared = OpenWebUi()
    
    @Published var id: String? = "b75c0767-4485-4600-b88a-e0cd1a55715b"
    @Published var messages: [ChatmessageModel] = []
    @Published var models: [String] = ["gemma3:1b"]
    
    func fetchModels() async throws {
        
    }
    func startNewChat() async throws {
        let url = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes.startNewChat
        )
    }
    
    func fetchChat() async throws -> ChatResponse? {
        guard let chatId = self.id else {
            print("No ChatID was provided")
            throw OpenWebUIError.missingChatId
        }
        
        guard let url = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                .getSingularChat(id: chatId))
        else{
            print("Invalid URL")
            throw URLError(.badURL)
        }
        do {
            let chatResponse = try await ConnectorApi.request(
                url: url,
                data: messages,
                responseType: ChatResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken
            )
            
                // Access the response data
            print("Chat ID: \(chatResponse.id)")
            print("Title: \(chatResponse.chat.title)")
            print("Messages count: \(chatResponse.chat.messages.count)")
            
                // Get the latest AI response
            if let lastMessage = chatResponse.chat.messages.last {
                print("AI Response: \(lastMessage.content)")
            }
            return chatResponse
            
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    func sendMessage(content: String, models: [String] = []) async throws {
        var newMessage = ChatmessageModel(
            content: content,
            parentId: messages.last?.id ?? ""
        );
        let emptyAiMessage = ChatmessageModel(
            assistant: true,
            parentId:  newMessage
                .id)
        newMessage.childrenIds.append(emptyAiMessage.id)
        messages.append(newMessage)
        messages.append(emptyAiMessage)
        guard let chatId = self.id else {
            print("No ChatID was provided")
            throw OpenWebUIError.missingChatId
        }
        if models.count == 0 && self.models.count == 0 {
            print("No Models where provided")
            throw OpenWebUIError.missingModelId
        }
        if models.count > 0 {
            self.models = models
        }
        newMessage.models = self.models
        
        guard let chatUrl = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                .updateSingluarChat(id: chatId)
        )
        else{
            print("Invalid URL")
            throw URLError(.badURL)
        }
        do {
            let chatResponse = try await ConnectorApi.request(
                url: chatUrl,
                data: ChatRequest(messages: messages),
                responseType: ChatResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken,
                method: "POST"
            )
            
                // Create your ChatRequest as before
            let chatRequest = ChatRequest(messages: messages)
            
                // Convert it to CompletionsRequest for the API
            let completionsRequest = CompletionsRequest(
                from: chatRequest,
                chatId: chatId,
                stream: false
            )
            
            guard let url = URL(
                string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                    .completionChat
            )else{
                print("invalid url")
                throw URLError(.badURL)
            }
            let completionResponse = try await ConnectorApi.request(
                url: url,
                data: completionsRequest,
                responseType: StandardCompletionResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken,
                method: "POST"
            )
            print("completion Response\(completionResponse)")
            
            let lastAiMessage = messages.lastIndex{ ChatmessageModel in
                ChatmessageModel.role.lowercased() == "assistant"
            }
            
            messages[lastAiMessage!].content = completionResponse.choices.first?.message.content ?? ""
            messages[lastAiMessage!].usage = completionResponse.usage
            messages[lastAiMessage!].done = true
            
            
            guard let url = URL(
                string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                    .completeChat
            )else{
                print("invalid url")
                throw URLError(.badURL)
            }
            let completedResponse = try await ConnectorApi.request(
                url: url,
                data: ChatCompletionRequestData(
                    model: completionResponse.model,
                    messages: messages,
                    modelItem: ModelItem(
                        id: messages[lastAiMessage!].id, name: "gemma3:1b"
                    ), chatId: chatId,
                    id: messages[lastAiMessage!].id
                ),
                responseType: CompletionTaskResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken,
                method: "POST"
            )
            print("completedResponse \(completionResponse)")
            
//            Update the chat with the AI response
            
            
            let newchatResponse = try await ConnectorApi.request(
                url: chatUrl,
                data: ChatRequest(messages: messages),
                responseType: ChatResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken,
                method: "POST"
            )
            
                // Access the response data
            print("Chat ID: \(chatResponse.id)")
            print("Title: \(chatResponse.chat.title)")
            print("Messages count: \(chatResponse.chat.messages.count)")
            
                // Get the latest AI response
            if let lastMessage = chatResponse.chat.messages.last {
                print("AI Response: \(lastMessage.content)")
            }
            
        } catch {
            print("Error: \(error)")
        }
        
        
        
        
    }
}

struct CompletionTokensDetails: Codable {
    let reasoningTokens: Int
    let acceptedPredictionTokens: Int
    let rejectedPredictionTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case reasoningTokens = "reasoning_tokens"
        case acceptedPredictionTokens = "accepted_prediction_tokens"
        case rejectedPredictionTokens = "rejected_prediction_tokens"
    }
}

class OpenWebUiConfigModel{
    static var baseURL: String = "http://localhost:3000/"
    static var bearerToken: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImVlNDk1YjdkLTIwODMtNGRkYS05NTZhLTczZWE4NThlY2MyMiJ9.JTx6nOUmk9AO99JguDPyIU2abWFxoGUF6lbRIU5byaI"
}

struct OpenWebUIRoutes {
    static let startNewChat = "/api/v1/chats/new"
    static let listChats = "api/v1/chats/list"
    static func getSingularChat(id: String) -> String {
        return "api/v1/chats/\(id)"
    }
    static func updateSingluarChat(id: String) -> String {
        return "api/v1/chats/\(id)"
    }
    static let completionChat = "api/chat/completions"
    static let completeChat = "api/chat/completed"
}

enum OpenWebUIError: Error {
    case missingModelId
    case missingChatId
    case invalidUrl
}

    //    // MARK: - Empty Object for params
struct EmptyObject: Codable {
    init(){
        
    }
    init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
    }
    
    func encode(to encoder: Encoder) throws {
        _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    private enum CodingKeys: CodingKey {}
}
