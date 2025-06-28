//
//  ContentView.swift
//  AI Chat
//
//  Created by Mark Heijnekamp on 11/06/2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    let session = LanguageModelSession(instructions: """
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
        """)
    private var model = SystemLanguageModel.default
    
    @State var text = ""
    @State var chatLog: [chatItem] = []
    @State var isLoading: Bool = false
    
    let options = GenerationOptions(temperature: 2.0)
    let encoder = JSONEncoder()
    func callAI() async{
        do {
            model.supportedLanguages.forEach { print($0) }
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(chatLog),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                
                let response = try await session.respond(
                    to: jsonString,
                    options: options
                )
                self.$chatLog.wrappedValue.append(chatItem(
                    text: response.content,
                    isUser: false
                ))
            }
            
        }
        catch(let error) {
            print("Error: \(error)")
            self.$chatLog.wrappedValue.append(chatItem(
                text: error.localizedDescription,
                isUser: false,
                isError: true
            ))
            
        }
        isLoading = false
        
    }
    
    var body: some View {
        switch model.availability {
        case .available:
                // Show your intelligence UI.
            Text("Apple intelligence is Available").font(.title3)
            VStack{
                ScrollView{
                    ForEach(chatLog, id: \.self){item in
                        VStack(alignment: item.isUser ? .trailing: .leading){
                            Text(item.text)
                                .foregroundColor(item.isUser ? .primary : .blue)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .frame(
                            maxWidth: .infinity,
                            alignment: .init(
                                horizontal: item.isUser ? .trailing : .leading,
                                vertical: .center
                            )
                        )
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .init(horizontal: .center, vertical: .bottom))
                Spacer()
                HStack{
                    TextField(
                        "What is your question?",
                        text: $text,
                        axis: .vertical
                    )
                    .padding()
                    .border(.black)
                    .padding(.horizontal)
                    Button {
                        if !isLoading{
                            isLoading = true;
                            Task{
                                self.chatLog.append(chatItem(
                                    text: self.text,
                                    isUser: true
                                ))
                                text = ""
                                await callAI()
                            }
                        }
                    } label: {
                        Text("Send")
                    }
                }
                .padding(.horizontal)
            }
            
        case .unavailable(.deviceNotEligible):
            Text("Your device is not eligible for apple Intelligence.")
                .font(.title)
                // Show an alternative UI.
        case .unavailable(.appleIntelligenceNotEnabled):
            Text("Apple Intelligence not enabled").font(.title)
                // Ask the person to turn on Apple Intelligence.
        case .unavailable(.modelNotReady):
            Text("The model isn't ready yet. might be a few minutes")
                .font(.title)
                // The model isn't ready because it's downloading or because of other system reasons.
        case .unavailable(let other):
            Text("Unavailable due to \(other.hashValue.description)")
                .font(.title)
                // The model is unavailable for an unknown reason.
        }
    }
}

#Preview {
    ContentView()
}
