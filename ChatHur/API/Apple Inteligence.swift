//
//  Apple Inteligence.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 28/06/2025.
//

import Foundation
import FoundationModels
import SwiftUI

class AppleInteligenceAPI {
        //    Generic
    static let shared = AppleInteligenceAPI()
    static let baseSystemPrompt = """
        You are an AI that is used for a chat bot. 
        
        The chats are send by you every message and are represented in JSON. The JSON will look look something like this '
        [
            {
                "text" : "Hi how are you?",
                "isUser" : true,
                "isError" : false
            }
        ]'
        
        The isUser represents if the message is from the user, if this is false the message is from you. If a message has the isError to true the message can be ignored. Always answer to the last message.
        
        You must respond in the same language as the user and you should only send the message so you dont create any JSON only lingustiqs.
        """
    
    init() {
        self.session = LanguageModelSession(
            instructions: AppleInteligenceAPI.baseSystemPrompt
        )
    }
    let model = SystemLanguageModel.default
    let options = GenerationOptions(temperature: 2.0)
    var session:LanguageModelSession
    func sendMessage(message: String?, history:[chatItem]?) async -> ModelResponse{
        if(checkShouldNotSendMessage()){
            // Message should not be send
            return ModelResponse(isSuccess: false, error: "Model is not ready")
        }
        do{
            //If history is not set the items wont be appended to the history
            var responseMessage: String = ""
            if(history == nil){
                if(message != nil){
                    //The message should be appended to the history
                    responseMessage = try await session.respond(
                        to: message!,
                        options: options
                    ).content
                }
            }
            else{
                //If history is set the users message should be appended
                let encoder = JSONEncoder()
                if let jsonData = try? encoder.encode(history),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    responseMessage = try await session.respond(
                        to: jsonString,
                        options: options
                    ).content
                }
            }
            return ModelResponse(isSuccess: true, message: responseMessage)
        }
        catch LanguageModelSession.GenerationError.guardrailViolation(let error){
            print("Guardril violation: \(error)")
            return ModelResponse(isSuccess: false, error: "Guardril violation: \(error)")
        }
        catch LanguageModelSession.GenerationError.unsupportedLanguageOrLocale(let error){
            print("Unsupported language or locale: \(error)")
            return ModelResponse(isSuccess: false, error: "Unsupported language or locale: \(error)")
        }
        catch LanguageModelSession.GenerationError.unsupportedGuide(let error){
            print("Unsupported guide: \(error)")
            return ModelResponse(isSuccess: false, error: "Unsupported guide: \(error)")
        }
        catch LanguageModelSession.GenerationError.exceededContextWindowSize(let error){
            print("Exceeded context window size: \(error)")
            return ModelResponse(isSuccess: false, error: "Exceeded context window size: \(error)")
        }
        catch LanguageModelSession.GenerationError.assetsUnavailable(let error){
            print("Assets unavailable: \(error)")
            return ModelResponse(isSuccess: false, error: "Assets unavailable: \(error)")
        }
        catch LanguageModelSession.GenerationError.decodingFailure(let error){
            print("Decoding failure: \(error)")
            return ModelResponse(isSuccess: false, error: "Decoding failure: \(error)")
        }
        catch(let error) {
            print("Error: \(error)")
            return ModelResponse(isSuccess: false, error: "Error: \(error)")
        }
    }
    
    func checkAvailability() -> ModelAvail{
        switch model.availability {
        case .available:
                // Show your intelligence UI.
            return ModelAvail(isAvailable: true)
        case .unavailable(.deviceNotEligible):
                // Show an alternative UI.
            print("Device not eligible")
            return ModelAvail(isAvailable: false, reason: "Device not eligible")
        case .unavailable(.appleIntelligenceNotEnabled):
                // Ask the person to turn on Apple Intelligence.
            print("Apple Intelligence not enabled")
            return ModelAvail(isAvailable: false, reason: "Apple Intelligence not enabled")
        case .unavailable(.modelNotReady):
                // The model isn't ready because it's downloading or because of other system reasons.
            print("Model not ready")
            return ModelAvail(isAvailable: false, reason: "Model not ready, because it's downloading or because of other system reasons")
        case .unavailable(let other):
                print("Unexpected availability error: \(other)")
            return ModelAvail(isAvailable: false, reason: "Unexpected availability error")
        }
    }
    
    func checkShouldNotSendMessage() -> Bool{
        return
            session.isResponding ||
        model.isAvailable == false
    }
}
