//
//  OpenWebUiSettings.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 14/07/2025.
//

import SwiftUI

// update OpenWebUi.shared.models

struct OpenWebUiSettings: View {
    var selectedModel: Binding<String> {
        Binding(
            get: { OpenWebUi.shared.models.first ?? "" },
            set: { newValue in
                    // Move the selected model to the front of the array
                var updatedModels = OpenWebUi.shared.models.filter { $0 != newValue }
                updatedModels.insert(newValue, at: 0)
                OpenWebUi.shared.models = updatedModels
            }
        )
    }
    @State var models: [Model] = []
    var body: some View {
        VStack{
            Picker(selection: selectedModel) {
                ForEach(models) { model in
                    Text(model.name).tag(model.id)
                    }
            } label: {
                Text("Model")
            }

        }.navigationTitle("Openwebui settings")
            .task {
                do{
                    let modelResponse = try await OpenWebUi.shared.fetchModels()
                    if let data = modelResponse?.data {
                        models = data
                    }
                }
                catch {
                    print("Error fetching models: \(error)")
                }
            }
    }
}

#Preview {
    OpenWebUiSettings()
}
