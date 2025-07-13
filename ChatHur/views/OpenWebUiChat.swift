//
//  OpenWebUiChat.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 05/07/2025.
//

import SwiftUI

struct OpenWebUiChat: View {
    @State var selectedModel = ""
    @StateObject var OpenWebUiModel = OpenWebUi.shared
    @State var isLoading = false
    var body: some View {
        VStack{
            chatLogView(ChatmessageModel: $OpenWebUiModel.messages)
            Spacer()
            chatInputField { text in
                try await OpenWebUi.shared.sendMessage(content: text)
            }
            
        }
        .navigationTitle("OpenwebUI chat!")
        .onAppear() {
            Task {
                self.isLoading = true
                let response = try await OpenWebUi.shared
                    .fetchChat()
                if let response = response {
                    self.OpenWebUiModel.messages = response.chat.messages
                }
                self.isLoading = false
            }
        }
    }
}

#Preview {
    OpenWebUiChat()
}
