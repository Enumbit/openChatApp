//
//  chatInputField.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 05/07/2025.
//

import SwiftUI

struct chatInputField: View {
    @State var text = ""
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
            Button {
                Task {
                    do {
                        try await action(text)
                            // Clearing the field
                        await MainActor.run {
                            text = ""
                        }
                    } catch {
                        print("Error: \(error)")
                            // Handle error appropriately
                    }
                }
            } label: {
                Text("Send")
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    chatInputField()
}
