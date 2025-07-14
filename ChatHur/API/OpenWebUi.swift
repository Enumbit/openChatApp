    //
    //  OpenWebUi.swift
    //  ChatHur
    //
    //  Created by Mark Heijnekamp on 29/06/2025.
    //

import Foundation
internal import Combine
import SwiftUI

class OpenWebUi: ObservableObject{
    @ObservedObject static var shared = OpenWebUi()
    
    @Published var chatId: String? = ""
    @Published var messages: [ChatmessageModel] = []
    @Published var models: [String] = ["gemma3:1b"]
    
    func fetchModels() async throws -> ModelFetchResponse?{
        guard let url = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                .models
        ) else{
            print("Invalid URL")
            throw URLError(.badURL)
        }
        do {
            let models = try await ConnectorApi.request(
                url: url,
                data: messages,
                responseType: ModelFetchResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken
            )
            
            return models
            
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
    
    func fetchChats() async throws -> [chatListItem] {
        guard let url = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                .listChats
            ) else{
            print("Invalid URL")
            throw URLError(.badURL)
        }

        do {
            let chats = try await ConnectorApi.request(
                url: url,
                data: messages,
                responseType: [chatListItem].self,
                bearerToken: OpenWebUiConfigModel.bearerToken
            )
            
            return chats
            
        } catch {
            print("Error: \(error)")
        }
        return []
        
    }
    
    func startNewChat() async throws {
        let url = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes.startNewChat
        )
    }
    
    func fetchChat() async throws -> ChatResponse? {
        guard let chatId = self.chatId else {
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
    
    func updateChat(chatId: String, messages: [ChatmessageModel]) async throws -> ChatResponse? {
        guard let chatUrl = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                .updateSingluarChat(id: chatId)
        )
        else{
            print("Invalid URL")
            throw URLError(.badURL)
        }
        do{
            let chatResponse = try await ConnectorApi.request(
                url: chatUrl,
                data: ChatRequest(messages: messages, models: OpenWebUi.shared.models),
                responseType: ChatResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken,
                method: "POST"
            )
            return chatResponse
        } catch {
            print("Error while updating the chat: \(error)")
        }
        return nil
    }
    
    func getCompletion(chatId: String,messages: [ChatmessageModel]) async throws -> StandardCompletionResponse? {
        let chatRequest = ChatRequest(
            messages: messages,
            models: OpenWebUi.shared.models)
        
        let completionsRequest = CompletionsRequest(
            from: chatRequest,
            chatId: chatId,
            stream: false //Streaming will be enabled in a later version.
        )
        
        guard let url = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                .completionChat
        )else{
            print("invalid url")
            throw URLError(.badURL)
        }
        do{
            let completionResponse = try await ConnectorApi.request(
                url: url,
                data: completionsRequest,
                responseType: StandardCompletionResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken,
                method: "POST"
            )
            return completionResponse
        } catch {
            print("Error while fetching completions: \(error)")
        }
        return nil
    }
    
    func sendMessage(content: String, models: [String] = []) async throws {
        
            //Check if chatId is set
        guard let chatId = self.chatId else {
            print("No ChatID was provided")
            throw OpenWebUIError.missingChatId
        }
            //        Check if model is set
        if models.count == 0 && self.models.count == 0 {
            print("No Models where provided")
            throw OpenWebUIError.missingModelId
        }
            //Sync the models
        if models.count > 0 {
            self.models = models
        }
        
            //Set the new message
        var newMessage = ChatmessageModel(
            content: content,
            parentId: messages.last?.id ?? ""
        );
        newMessage.models = self.models
            //Prepare an assistant message
        let emptyAiMessage = ChatmessageModel(
            assistant: true,
            parentId:  newMessage.id
        )
            //Append the messages
        newMessage.childrenIds.append(emptyAiMessage.id)
        messages.append(newMessage)
        messages.append(emptyAiMessage)
        
        _ = try await updateChat(chatId: chatId, messages: messages)
        
        let completionResponse = try await getCompletion(
            chatId: chatId,
            messages: messages
        )
        
        _ = messages.lastIndex{ ChatmessageModel in
            ChatmessageModel.role.lowercased() == "assistant"
        }
        if let completionResponse = completionResponse {
            if let lastAiMessage = messages.lastIndex(where: { ChatmessageModel in
                ChatmessageModel.role.lowercased() == "assistant"
            }) {
                
                messages[lastAiMessage].content = completionResponse.choices.first?.message.content ?? ""
                messages[lastAiMessage].usage = completionResponse.usage
                messages[lastAiMessage].done = true
                
                guard let url = URL(
                    string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                        .completeChat
                )else{
                    print("invalid url")
                    throw URLError(.badURL)
                }
                _ = try await ConnectorApi.request(
                    url: url,
                    data: ChatCompletionRequestData(
                        model: completionResponse.model,
                        messages: messages,
                        modelItem: ModelItem(
                            id: messages[lastAiMessage].id,
                            name: self.models.first ?? ""
                        ),
 chatId: chatId,
                        id: messages[lastAiMessage].id
                    ),
                    responseType: CompletionTaskResponse.self,
                    bearerToken: OpenWebUiConfigModel.bearerToken,
                    method: "POST"
                )
                
                _ = try await updateChat(chatId: chatId, messages: messages)
            }
        }
    }
    
    func login(email: String, password: String) async throws -> loginResponse? {
        guard let url = URL(
            string: OpenWebUiConfigModel.baseURL+OpenWebUIRoutes
                .login
        )else{
            print("invalid url")
            throw URLError(.badURL)
        }
        
        
        do{
            let loginResponse = try await ConnectorApi.request(
                url: url,
                data: loginRequest(email: email, password: password),
                responseType: loginResponse.self,
                bearerToken: OpenWebUiConfigModel.bearerToken,
                method: "POST"
            )
            return loginResponse
        } catch {
            print("Error while fetching completions: \(error)")
        }
        return nil
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
    static var bearerToken: String = ""
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
    
    static let login = "api/v1/auths/signin"
    static let models = "api/models"
}

enum OpenWebUIError: Error {
    case missingModelId
    case missingChatId
    case invalidUrl
}
