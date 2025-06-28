//
//  chat.swift
//  AI Chat
//
//  Created by Mark Heijnekamp on 12/06/2025.
//

class chatItem: Hashable,Codable {
        // Equatable conformance
    static func == (lhs: chatItem, rhs: chatItem) -> Bool {
        return lhs.text == rhs.text && lhs.isUser == rhs.isUser
    }
    
        // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(isUser)
    }

    var text: String
    var isUser: Bool
    var isError: Bool = false
    
    init(text: String, isUser: Bool, isError: Bool = false) {
        self.text = text
        self.isUser = isUser
        self.isError = isError
    }
}
