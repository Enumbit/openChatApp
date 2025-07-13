//
//  History.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//

    // MARK: - History Model
struct History: Codable {
    let messages: [String: ChatmessageModel]
    let currentId: String
}
