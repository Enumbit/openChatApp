    //
    //  loginView.swift
    //  ChatHur
    //
    //  Created by Mark Heijnekamp on 14/07/2025.
    //

import SwiftUI

struct loginView: View {
    var serviceName: String = "ChatHur"
    var action: (_ email:String, _ password:String) async throws -> Bool = {
        _,
        _  in
        true
    }
    var baseUrlCallback: ((String) -> Void)?
    
    @State var email = ""
    @State var password = ""
    @State var loginFailed: Bool = false
    @State var isLoggedin: Bool = false
    @State var baseURL: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                Text("Login for \(serviceName)").font(.title)
                
                if loginFailed {
                    Text("Login failed").foregroundColor(.red)
                }
                if (baseUrlCallback != nil) {
                    TextField(text: $baseURL){
                        Text(verbatim: "http://localhost:3000/")
                    }
                }
                
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Button {
                    Task{
                        do{
                            if let baseUrlCallback = baseUrlCallback {
                                if baseURL.isEmpty {
                                    #if DEBUG
                                    baseURL = "http://localhost:3000/"
                                    #else
                                    loginFailed = true;
                                    return
                                    #endif
                                }
                                baseUrlCallback(baseURL)
                            }
                            let result  = try await self.action(email, password)
                            if result {
                                print("Login successfully")
                                isLoggedin = true
                            }
                            else{
                                print("Unable to login")
                                loginFailed = true
                            }
                        }
                        catch {
                            print("error while loggin in: \(error)")
                        }
                    }
                } label: {
                    Text("login")
                }
                
            }
        }
        
    }
}

#Preview {
    loginView()
}
