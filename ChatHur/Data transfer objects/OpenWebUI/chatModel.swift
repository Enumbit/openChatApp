//
//  chat.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//

    // MARK: - Chat Model
struct Chat: Codable {
    let id: String
    let title: String
    let models: [String]
    let params: EmptyObject
    let history: History
    let messages: [ChatmessageModel]
    let tags: [String]
    let timestamp: Int
    let files: [String]
}
