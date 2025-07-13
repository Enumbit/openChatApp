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
            set: { _ in } // Read-only binding since we're transforming the data
        )
    }
    
    var body: some View {
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
    }
}

#Preview {
    @Previewable @State var chatHistory: [ChatItem] = []
    
    chatHistory.append(
        ChatItem(text: "Hello World", isUser: false)
    )
    
    return chatLogView(chatLog: $chatHistory)
}
