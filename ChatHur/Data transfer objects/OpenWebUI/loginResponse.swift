//
//  loginResponse.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 14/07/2025.
//


struct loginResponse: Codable {
    var id: String
    var email: String
    var name: String
    var profileImageUrl: String
    var token: String
    var tokenType: String
    var expiresAt: String?
    var permissions: Permissions
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case profileImageUrl = "profile_image_url"
        case token
        case tokenType = "token_type"
        case expiresAt = "expires_at"
        case permissions
    }
}

struct Permissions: Codable {
    var workspace: workspacePermissions
    var sharing: sharingPermissions
    var chat: chatPermissions
    var features: featuresPermissions
}


struct workspacePermissions: Codable {
    var  models: Bool
    var knowledge: Bool
    var prompts: Bool
    var tools: Bool
}


struct sharingPermissions: Codable {
    var public_models: Bool
    var public_knowledge: Bool
    var public_prompts: Bool
    var public_tools: Bool
}

struct chatPermissions: Codable {
    var controls: Bool
    var system_prompt: Bool
    var file_upload: Bool
    var `delete`: Bool
    var edit: Bool
    var share: Bool
    var export: Bool
    var stt: Bool
    var tts: Bool
}

struct featuresPermissions: Codable {
    var direct_tool_servers: Bool
    var web_search: Bool
    var image_generation: Bool
    var code_interpreter: Bool
    var notes: Bool
}
