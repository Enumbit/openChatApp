//
//  chatInputField.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 05/07/2025.
//

import SwiftUI

struct chatInputField: View {
    @State var text = ""
    @State var isLoading: Bool = false
    var action: (_ text:String) async throws -> Void = { _ in }
    var body: some View {
        HStack{
            TextField(
                "What is your question?",
                text: $text,
                axis: .vertical
            )
            .padding()
            .border(.black)
            .padding(.horizontal)
            if isLoading{
                Image(systemName: "circle.dotted")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .symbolEffect(.rotate)
            }
            else{
                Button {
                    Task {
                        do {
                            self.isLoading = true
                            let userMessage = text
                            
                            await MainActor.run {
                                text = ""
                            }
                            try await action(userMessage)
                            self.isLoading = false
                        } catch {
                            print("Error: \(error)")
                                // Handle error appropriately
                        }
                    }
                } label: {
                    Text("Send")
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    chatInputField()
}
