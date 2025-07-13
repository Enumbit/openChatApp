//
//  ChatMessageModel.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 13/07/2025.
//

import Foundation

struct ChatmessageModel: Decodable, Encodable {
        //    {
        //        "id": "5c42c170-1313-4563-a140-7e4d4ef43711",
        //        "parentId": null,
        //        "childrenIds": [],
        //        "role": "user",
        //        "content": "hihi",
        //        "timestamp": 1752349438,
        //        "models": [
        //            "gemma3:1b"
        //        ]
        //    }
    init(
        id: String,
        parentId: String? = nil,
        childrenIds: [String],
        role: String,
        content: String,
        timestamp: Int,
        models: [String]
    ) {
        self.id = id
        self.parentId = parentId
        self.childrenIds = childrenIds
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.models = models
    }
    
    init(content: String, parentId: String){
        self.content = content
        self.parentId = parentId
    }
    
    init(assistant:Bool, parentId: String){
        self.content = ""
        self.role = "assistant"
        self.parentId = parentId
    }
    
    var id: String = UUID().uuidString
    var parentId: String?
    var childrenIds: [String] = []
    var role: String = "user"
    var content: String
    var timestamp: Int = Int(Date().timeIntervalSince1970)
    var models: [String] = []
    
    
        // Optional fields for assistant responses
    var model: String?
    var modelName: String?
    var modelIdx: Int?
    var usage: Usage?
    var done: Bool?
    var followUps: [String]?
    var lastSentence: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentId
        case childrenIds
        case role
        case content
        case timestamp
        case models
        case model
        case modelName
        case modelIdx
        case usage
        case done
        case followUps
        case lastSentence
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        childrenIds = try container.decodeIfPresent([String].self, forKey: .childrenIds) ?? []
        role = try container.decodeIfPresent(String.self, forKey: .role) ?? "user"
        content = try container.decode(String.self, forKey: .content)
        timestamp = try container.decodeIfPresent(Int.self, forKey: .timestamp) ?? Int(Date().timeIntervalSince1970)
        models = try container.decodeIfPresent([String].self, forKey: .models) ?? []
        
            // Optional fields
        model = try container.decodeIfPresent(String.self, forKey: .model)
        modelName = try container.decodeIfPresent(String.self, forKey: .modelName)
        modelIdx = try container.decodeIfPresent(Int.self, forKey: .modelIdx)
        usage = try container.decodeIfPresent(Usage.self, forKey: .usage)
        done = try container.decodeIfPresent(Bool.self, forKey: .done)
        followUps = try container.decodeIfPresent([String].self, forKey: .followUps)
        lastSentence = try container.decodeIfPresent(String.self, forKey: .lastSentence)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(parentId, forKey: .parentId)
        try container.encode(childrenIds, forKey: .childrenIds)
        try container.encode(role, forKey: .role)
        try container.encode(content, forKey: .content)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(models, forKey: .models)
        
            // Optional fields
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(modelName, forKey: .modelName)
        try container.encodeIfPresent(modelIdx, forKey: .modelIdx)
        try container.encodeIfPresent(usage, forKey: .usage)
        try container.encodeIfPresent(done, forKey: .done)
        try container.encodeIfPresent(followUps, forKey: .followUps)
        try container.encodeIfPresent(lastSentence, forKey: .lastSentence)
    }
}

extension ChatmessageModel {
    var chatItem: ChatItem {
        return ChatItem(
            text: self.content,
            isUser: self.role == "user"
        )
    }
}

