//
//  OpenWebUiChatList.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 14/07/2025.
//

import SwiftUI

struct OpenWebUiChatList: View {
    @State var chats: [chatListItem] = []
    @State private var selectedChatId: String?
    
    var body: some View {
        List(chats, id: \.id) { chat in
            NavigationLink {
                OpenWebUiChat(chatId: chat.id)
            } label: {
                Text(chat.title)
            }
        }
        .refreshable {
            Task{
                await loadChats()
            }
        }
        .navigationTitle("Chats")
        .task {
            await loadChats()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        do {
                            await MainActor.run {
                                selectedChatId = nil
                            }
                            let newChat = try await OpenWebUi.shared.startNewChat()
                            if let newChat = newChat {
                                await MainActor.run {
                                    selectedChatId = newChat.id
                                }
                            }
                        } catch {
                            print("Error starting new chat: \(error)")
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
        .navigationDestination(item: $selectedChatId) { chatId in
            OpenWebUiChat(chatId: chatId)
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
