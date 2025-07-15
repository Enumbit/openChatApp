//
//  chatResponse.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//

    // MARK: - Main Response Model
struct ChatResponse: Codable {
    let id: String?
    let userId: String?
    let title: String
    let chat: Chat
    let updatedAt: Int?
    let createdAt: Int?
    let shareId: String?
    let archived: Bool?
    let pinned: Bool?
    let meta: Meta?
    let folderId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case chat
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case shareId = "share_id"
        case archived
        case pinned
        case meta
        case folderId = "folder_id"
    }
}
