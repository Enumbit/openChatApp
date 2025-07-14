    //
    //  chatLog.swift
    //  ChatHur
    //
    //  Created by Mark Heijnekamp on 05/07/2025.
    //

import SwiftUI

struct chatLogView: View {
    @Binding var chatLog: [ChatItem]
    
    init(chatLog: Binding<[ChatItem]>) {
        self._chatLog = chatLog
    }
    
    init(ChatmessageModel: Binding<[ChatmessageModel]>) {
        self._chatLog = Binding(
            get: { ChatmessageModel.wrappedValue.map(\.chatItem) },
            set: { _ in }
        )
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ForEach(chatLog) { item in
                        VStack(alignment: item.isUser ? .trailing: .leading) {
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
                        .id(item.id)
                    }
                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .padding()
            
            .onChange(of: chatLog.count) { oldValue, newValue in
                print("Chatlog changed from \(oldValue) to \(newValue)")
                
                    // Scroll on initial load or when new messages are added
                if oldValue == 0 && newValue > 0 {
                        // Initial load - give more time for rendering
                    DispatchQueue.main.async {
                            proxy.scrollTo("bottom", anchor: .bottom)
                    }
                } else if newValue > oldValue {
                        // New message added
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var chatHistory: [ChatItem] = []
    
    chatHistory.append(
        ChatItem(text: "Hello World", isUser: false)
    )
    
    return chatLogView(chatLog: $chatHistory)
}
