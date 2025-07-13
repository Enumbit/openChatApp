//
//  appleIntelligence.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 05/07/2025.
//

import SwiftUI

struct appleIntelligenceChat: View {
    @State var chatLog: [ChatItem] = []
    @State var isLoading: Bool = false
    
    let AppleIntelligenceModel :AppleInteligenceAPI = .shared
    let availabilty: ModelAvail
    init(){
        availabilty = AppleIntelligenceModel.checkAvailability()
    }
    var body: some View {
        if availabilty.isAvailable == true {
                // Show your intelligence UI.
            Text("Apple intelligence is Available").font(.title3)
            VStack{
                chatLogView(chatLog: $chatLog)

                Spacer()
                chatInputField { text in
                    if !isLoading{
                        isLoading = true;
                        Task{
                            self.chatLog.append(ChatItem(
                                text: text,
                                isUser: true
                            ))
                            isLoading = true
                            let response = await AppleIntelligenceModel
                                .sendMessage(
                                    message:nil,
                                    history: self.chatLog
                                )
                            if response.isSuccess {
                                self.$chatLog.wrappedValue.append(ChatItem(
                                    text: response.message!,
                                    isUser: false
                                ))
                            }
                            else{
                                    //                                    Should add streaming!!!
                                self.chatLog.append(ChatItem(
                                    text: response.error!,
                                    isUser: false,
                                    isError: true
                                ))
                            }
                            isLoading = false
                            
                        }
                    }
                }
            }
        }
        else{
            Text("Apple Intelligence Model is not available.")
            Text("\(availabilty.reason!)")
        }
    }
}

#Preview {
    appleIntelligenceChat()
}
