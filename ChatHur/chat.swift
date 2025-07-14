//
//  chat.swift
//  AI Chat
//
//  Created by Mark Heijnekamp on 12/06/2025.
//

import Foundation

class ChatItem:Identifiable, Hashable,Codable {
        // Equatable conformance
    static func == (lhs: ChatItem, rhs: ChatItem) -> Bool {
        return lhs.text == rhs.text && lhs.isUser == rhs.isUser
    }
    
        // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(isUser)
    }
    var id = UUID()
    var text: String
    var isUser: Bool
    var isError: Bool = false
    
    init(text: String, isUser: Bool, isError: Bool = false) {
        self.text = text
        self.isUser = isUser
        self.isError = isError
    }
}
