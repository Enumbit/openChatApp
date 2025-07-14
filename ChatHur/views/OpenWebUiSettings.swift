//
//  OpenWebUiSettings.swift
//  ChatHur
//
//  Created by Mark Heijnekamp on 14/07/2025.
//

import SwiftUI

struct OpenWebUiSettings: View {
    @State private var localSelectedModel: String = ""
    @State private var models: [Model] = []
    
    var body: some View {
        VStack {
            Picker(selection: $localSelectedModel) {
                ForEach(models) { model in
                    Text(model.name).tag(model.id)
                }
            } label: {
                Text("Model")
            }
            .onChange(of: localSelectedModel) { oldValue, newValue in
                updateSharedModels(with: newValue)
            }
        }
        .navigationTitle("Openwebui settings")
        .task {
            do {
                let modelResponse = try await OpenWebUi.shared.fetchModels()
                if let data = modelResponse?.data {
                    models = data
                    if let firstModel = models.first {
                        localSelectedModel = firstModel.id
                        updateSharedModels(with: firstModel.id)
                    }
                }
            } catch {
                print("Error fetching models: \(error)")
            }
        }
    }
    
    private func updateSharedModels(with selectedId: String) {
        var updatedModels = OpenWebUi.shared.models.filter { $0 != selectedId }
        updatedModels.insert(selectedId, at: 0)
        OpenWebUi.shared.models = updatedModels
    }
}

#Preview {
    OpenWebUiSettings()
}
