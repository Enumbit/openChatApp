//
//  OpenWebUIOrAuth.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 14/07/2025.
//

import SwiftUI

struct OpenWebUIOrAuth: View {
    @State var isLoggedIn: Bool = false
    var body: some View {
        if OpenWebUiConfigModel.bearerToken.isEmpty && isLoggedIn == false {
            loginView(
                serviceName: "OpenWebUi",
                action: { email, password in
                    let res = try await OpenWebUi.shared
                        .login(email: email, password: password)
                    if (res?.token != nil) {
                        OpenWebUiConfigModel.bearerToken = res!.token
                        isLoggedIn = true
                        return true
                    }
                    return false
                }) { baseUrl in
                    OpenWebUiConfigModel.baseURL = baseUrl
                }
        } else {
            OpenWebUiChatList()
        }
    }
}

#Preview {
    OpenWebUIOrAuth()
}
