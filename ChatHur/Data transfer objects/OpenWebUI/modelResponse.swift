//
//  modelResponse.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 14/07/2025.
//

import Foundation

    // MARK: - Main Response
struct ModelFetchResponse: Codable {
    let data: [Model]
}

    // MARK: - Model
struct Model: Codable, Identifiable {
    let id: String
    let name: String
    let object: String
    let created: Int
    let ownedBy: String
    let ollama: OllamaInfo?
    let connectionType: String?
    let tags: [String]
    let actions: [String] // Assuming actions are strings, adjust if needed
    let filters: [String] // Assuming filters are strings, adjust if needed
    let info: ModelInfo?
    let arena: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, object, created, tags, actions, filters, ollama, info, arena
        case ownedBy = "owned_by"
        case connectionType = "connection_type"
    }
}

struct ModelInfo: Codable {
    let meta: ModelMeta
}

    // MARK: - Model Meta
struct ModelMeta: Codable {
    let profileImageUrl: String
    let description: String
    let modelIds: [String]?
    
    enum CodingKeys: String, CodingKey {
        case description
        case profileImageUrl = "profile_image_url"
        case modelIds = "model_ids"
    }
}
