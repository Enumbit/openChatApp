    //
    //  OpenWebUiChat.swift
    //  ChatHur
    //
    //  Created by Mark Heijnekamp on 05/07/2025.
    //

import SwiftUI

struct OpenWebUiChat: View {
    var chatId: String
    @State var selectedModel = ""
    @StateObject var OpenWebUiModel = OpenWebUi.shared
    @State var chatName = "Your chat!"
    var body: some View {
        VStack{
                chatLogView(ChatmessageModel: $OpenWebUiModel.messages)
                Spacer()
                chatInputField { text in
                    try await
                    OpenWebUi.shared.sendMessage(content: text)
                }
            
            
        }
        .navigationTitle(chatName)
        .task {
            Task {
                OpenWebUi.shared.chatId = chatId
                let response = try await OpenWebUi.shared
                    .fetchChat()
                if let response = response {
                    self.OpenWebUiModel.messages = response.chat.messages
                    self.chatName = response.title
                }
            }
        }
        .navigationSubtitle("OpenwebUI chat!")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    OpenWebUiSettings()
                } label: {
                    Image(systemName: "gear")
                }
                
            }
        }
        
    }
}

#Preview {
    OpenWebUiChat(chatId: "b75c0767-4485-4600-b88a-e0cd1a55715b")
}
