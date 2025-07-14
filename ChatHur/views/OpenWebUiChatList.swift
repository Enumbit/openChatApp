//
//  OpenWebUiChatList.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 14/07/2025.
//

import SwiftUI

struct OpenWebUiChatList: View {
    @State var chats: [chatListItem] = []
    
    var body: some View {
        List(chats, id: \.id) { chat in
            NavigationLink {
                OpenWebUiChat(chatId: chat.id)
            } label: {
                Text(chat.title)
            }
        }
        .navigationTitle("Chats")
        .task {
            await loadChats()
        }
    }
    
    @MainActor
    private func loadChats() async {
        do {
            let fetchedChats = try await OpenWebUi.shared.fetchChats()
            self.chats = fetchedChats
            print("Chats loaded: \(fetchedChats.count) items")
        } catch {
            print("Error while loading chats: \(error)")
        }
    }
}

#Preview {
    NavigationView {
        OpenWebUiChatList()
    }
}
