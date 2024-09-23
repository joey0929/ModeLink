//
//  ModelListView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/18.
//

import SwiftUI
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
                fetchModelsFromFirestore() // 將資料庫中的modelURL都load 進來
            }
        }
    }
    func fetchModelsFromFirestore2() {
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
    func fetchModelsFromFirestore() {
        let db = Firestore.firestore()
        // 使用實時監聽器來監聽集合的變化
        db.collection("3DModels")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching models: \(error.localizedDescription)")
                return
            }
            // 更新 models
            self.models = snapshot?.documents.compactMap { doc -> Model? in
                guard let name = doc.data()["name"] as? String,
                      let urlString = doc.data()["modelURL"] as? String,
                      let url = URL(string: urlString) else { return nil }
                return Model(name: name, url: url)
            } ?? []
            print("Models updated: \(models)")
        }
    }
}

struct Model: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
}
