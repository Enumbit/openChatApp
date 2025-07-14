//
//  CompletionRequest.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//

import Foundation

    // MARK: - Completions Request
struct CompletionsRequest: Codable {
    let stream: Bool
    let model: String
    let messages: [CompletionMessage]
    let params: EmptyObject
    let toolServers: [String]
    let features: Features
    let variables: Variables
    let modelItem: ModelItem
    let chatId: String
    let id: String
    let backgroundTasks: BackgroundTasks
    
    enum CodingKeys: String, CodingKey {
        case stream, model, messages, params, features, variables
        case toolServers = "tool_servers"
        case modelItem = "model_item"
        case chatId = "chat_id"
        case id
        case backgroundTasks = "background_tasks"
    }
    
        // Simplified initializer for basic usage
    init(chatId: String, messages: [CompletionMessage], model: String, stream: Bool = true) {
        self.stream = stream
        self.model = model
        self.messages = messages
        self.params = EmptyObject()
        self.toolServers = []
        self.features = Features()
        self.variables = Variables()
        self.modelItem = ModelItem(id: model, name: model)
        self.chatId = chatId
        self.id = UUID().uuidString
        self.backgroundTasks = BackgroundTasks()
    }
    
        // Initialize from ChatRequest - converts the complex structure to simple completions format
    init(from chatRequest: ChatRequest, chatId: String, stream: Bool = true) {
        self.stream = stream
        self.model = chatRequest.chat.models.first ?? ""
        
            // Convert ChatmessageModel array to CompletionMessage array
            // Filter out empty assistant messages and sort by timestamp
        self.messages = chatRequest.chat.messages
            .filter { !($0.role == "assistant" && $0.content.isEmpty) }
            .sorted { $0.timestamp < $1.timestamp }
            .map { CompletionMessage(from: $0) }
        
        self.params = chatRequest.chat.params
        self.toolServers = []
        self.features = Features()
        self.variables = Variables()
        self.modelItem = ModelItem(id: self.model, name: self.model)
        self.chatId = chatId
        self.id = UUID().uuidString
        self.backgroundTasks = BackgroundTasks()
    }
}

    // MARK: - Completion Message (simpler than ChatmessageModel)
struct CompletionMessage: Codable {
    let role: String
    let content: String
    
    init(role: String, content: String) {
        self.role = role
        self.content = content
    }
    
        // Convert from ChatmessageModel
    init(from chatMessage: ChatmessageModel) {
        self.role = chatMessage.role
        self.content = chatMessage.content
    }
}

    // MARK: - Features
struct Features: Codable {
    let imageGeneration: Bool
    let codeInterpreter: Bool
    let webSearch: Bool
    let memory: Bool
    
    enum CodingKeys: String, CodingKey {
        case imageGeneration = "image_generation"
        case codeInterpreter = "code_interpreter"
        case webSearch = "web_search"
        case memory
    }
    
    init(imageGeneration: Bool = false,
         codeInterpreter: Bool = false,
         webSearch: Bool = false,
         memory: Bool = false) {
        self.imageGeneration = imageGeneration
        self.codeInterpreter = codeInterpreter
        self.webSearch = webSearch
        self.memory = memory
    }
}

    // MARK: - Variables
struct Variables: Codable {
    let userName: String
    let userLocation: String
    let currentDatetime: String
    let currentDate: String
    let currentTime: String
    let currentWeekday: String
    let currentTimezone: String
    let userLanguage: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "{{USER_NAME}}"
        case userLocation = "{{USER_LOCATION}}"
        case currentDatetime = "{{CURRENT_DATETIME}}"
        case currentDate = "{{CURRENT_DATE}}"
        case currentTime = "{{CURRENT_TIME}}"
        case currentWeekday = "{{CURRENT_WEEKDAY}}"
        case currentTimezone = "{{CURRENT_TIMEZONE}}"
        case userLanguage = "{{USER_LANGUAGE}}"
    }
    
    init() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        self.userName = "User"
        self.userLocation = "Unknown"
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.currentDatetime = formatter.string(from: now)
        
        formatter.dateFormat = "yyyy-MM-dd"
        self.currentDate = formatter.string(from: now)
        
        formatter.dateFormat = "HH:mm:ss"
        self.currentTime = formatter.string(from: now)
        
        formatter.dateFormat = "EEEE"
        self.currentWeekday = formatter.string(from: now)
        
        self.currentTimezone = TimeZone.current.identifier
        self.userLanguage = Locale.current.identifier
    }
}

    // MARK: - Model Item
struct ModelItem: Codable {
    let id: String
    let name: String
    let object: String
    let created: Int
    let ownedBy: String
    let connectionType: String
    let tags: [String]
    let actions: [String]
    let filters: [String]
        // Ollama specific fields are optional
    let ollama: OllamaInfo?
    
    enum CodingKeys: String, CodingKey {
        case id, name, object, created, tags, actions, filters, ollama
        case ownedBy = "owned_by"
        case connectionType = "connection_type"
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.object = "model"
        self.created = Int(Date().timeIntervalSince1970)
        self.ownedBy = "ollama"
        self.connectionType = "local"
        self.tags = []
        self.actions = []
        self.filters = []
        self.ollama = nil
    }
}

    // MARK: - Ollama Info
struct OllamaInfo: Codable {
    let name: String
    let model: String
    let modifiedAt: String
    let size: Int
    let digest: String
    let details: OllamaDetails
    let connectionType: String
    let urls: [Int]
    let expiresAt: String?
    
    enum CodingKeys: String, CodingKey {
        case name, model, size, digest, details, urls
        case modifiedAt = "modified_at"
        case connectionType = "connection_type"
        case expiresAt = "expires_at"
    }
}

    // MARK: - Ollama Details
struct OllamaDetails: Codable {
    let parentModel: String
    let format: String
    let family: String
    let families: [String]
    let parameterSize: String
    let quantizationLevel: String
    
    enum CodingKeys: String, CodingKey {
        case format, family, families
        case parentModel = "parent_model"
        case parameterSize = "parameter_size"
        case quantizationLevel = "quantization_level"
    }
}

    // MARK: - Background Tasks
struct BackgroundTasks: Codable {
    let followUpGeneration: Bool
    
    enum CodingKeys: String, CodingKey {
        case followUpGeneration = "follow_up_generation"
    }
    
    init(followUpGeneration: Bool = true) {
        self.followUpGeneration = followUpGeneration
    }
}

    // MARK: - Extension to convert ChatmessageModel array to CompletionMessage array
extension Array where Element == ChatmessageModel {
    var toCompletionMessages: [CompletionMessage] {
        return self.map { CompletionMessage(from: $0) }
    }
}
