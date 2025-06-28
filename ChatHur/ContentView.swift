//
//  ContentView.swift
//  AI Chat
//
//  Created by Mark Heijnekamp on 11/06/2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State var text = ""
    @State var chatLog: [chatItem] = []
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
                                isLoading = true
                                let response = await AppleIntelligenceModel
                                    .sendMessage(
                                        message:nil,
                                        history: self.chatLog
                                    )
                                if response.isSuccess {
                                    self.$chatLog.wrappedValue.append(chatItem(
                                        text: response.message!,
                                        isUser: false
                                    ))
                                }
                                else{
                                    self.chatLog.append(chatItem(
                                        text: response.error!,
                                        isUser: false,
                                        isError: true
                                    ))
                                }
                                isLoading = false
                                
                            }
                        }
                    } label: {
                        Text("Send")
                    }
                }
                .padding(.horizontal)
            }
        }
        else{
            Text("Apple Intelligence Model is not available.")
            Text("\(availabilty.reason!)")
        }
    }
}

#Preview {
    ContentView()
}
