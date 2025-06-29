//
//  ApiBasics.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 29/06/2025.
//

protocol ApiBasics {
    static var baseSystemPrompt: String { get }
    
    func sendMessage(message: String?, history:[chatItem]?) async -> ModelResponse
    
    func checkAvailability() -> ModelAvail
    
    func checkShouldNotSendMessage() -> Bool
}
