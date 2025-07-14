//
//  aiSelector.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 05/07/2025.
//

import SwiftUI

struct aiSelector: View {
    var body: some View {
        NavigationView {
            List{
                NavigationLink {
                        OpenWebUIOrAuth()
                } label: {
                    Text("Openwebui Chat")
                }
                
                
                
            }
        }
    }
}

#Preview {
    aiSelector()
}
