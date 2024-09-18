//
//  ModelListView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/18.
//

import SwiftUI
import QuickLook
import Firebase


struct ModelListView: View {
    @State private var models = [Model]()

    var body: some View {
        NavigationView {
            List(models) { model in
                NavigationLink(destination: SavedModelPreviewView(modelURL: model.url)) {
                    Text(model.name)
                }
            }
            .navigationTitle("儲存的模型")
            .onAppear {
                fetchModelsFromFirestore()
            }
        }
    }

    func fetchModelsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("3DModels").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching models: \(error.localizedDescription)")
                return
            }

            self.models = snapshot?.documents.compactMap { doc -> Model? in
                guard let name = doc.data()["name"] as? String,
                      let urlString = doc.data()["modelURL"] as? String,
                      let url = URL(string: urlString) else { return nil }
                return Model(name: name, url: url)
            } ?? []
            print(models)
        }
    }  
}

struct Model: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
}

#Preview {
    ModelListView()
}
