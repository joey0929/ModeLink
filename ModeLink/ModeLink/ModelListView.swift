//
//  ModelListView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/18.
//

import SwiftUI
import QuickLook
import Firebase


//struct ModelListView: View {
//    @State private var models = [Model]()
//
//    var body: some View {
//        NavigationView {
//            List(models) { model in
//                NavigationLink(destination: SavedModelPreviewView(modelURL: model.url)) {
//                    Text(model.name)
//                }
//            }
//            .navigationTitle("儲存的模型")
//            .onAppear {
//                fetchModelsFromFirestore()
//            }
//        }
//    }
//
//    func fetchModelsFromFirestore() {
//        let db = Firestore.firestore()
//        db.collection("3DModels").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching models: \(error.localizedDescription)")
//                return
//            }
//
//            self.models = snapshot?.documents.compactMap { doc -> Model? in
//                guard let name = doc.data()["name"] as? String,
//                      let urlString = doc.data()["modelURL"] as? String,
//                      let url = URL(string: urlString) else { return nil }
//                return Model(name: name, url: url)
//            } ?? []
//            print(models)
//        }
//    }  
//}
//
//struct Model: Identifiable {
//    let id = UUID()
//    let name: String
//    let url: URL
//}
//struct ModelListView: View {
//    @State private var models = [Model]()  // 模型列表
//    @State private var selectedModel: Model?  // 當前選擇的模型
//
//    var body: some View {
//        NavigationView {
//            List(models) { model in
//                
////                Button(action: {
////                    selectModel(model)  // 點擊模型後更新選擇
////                }) {
////                    Text(model.name)
////                }
//
//                NavigationLink(destination: SavedModelPreviewView(modelURL: model.url)) {
//                        Text(model.name)
//                                }
//            }
//            .navigationTitle("儲存的模型")
//            .onAppear {
//                fetchModelsFromFirestore()  // 當頁面加載時，從 Firestore 獲取模型列表
//            }
//        }
//        .alert(item: $selectedModel) { model in
//            Alert(
//                title: Text("選擇的模型"),
//                message: Text("你選擇了 \(model.name) 模型。"),
//                dismissButton: .default(Text("確定"))
//            )
//        }
//    }
//
//    func selectModel(_ model: Model) {
//        self.selectedModel = model  // 更新當前選擇的模型
//        print("選擇的模型: \(model.name)")
//    }
//
//    // 從 Firestore 獲取模型數據
//    func fetchModelsFromFirestore() {
//        let db = Firestore.firestore()
//        db.collection("3DModels").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching models: \(error.localizedDescription)")
//                return
//            }
//
//            self.models = snapshot?.documents.compactMap { doc -> Model? in
//                guard let name = doc.data()["name"] as? String,
//                      let urlString = doc.data()["modelURL"] as? String,
//                      let url = URL(string: urlString) else { return nil }
//                return Model(name: name, url: url)
//            } ?? []
//            print(models)
//        }
//    }
//}
//
//struct Model: Identifiable {
//    let id = UUID()
//    let name: String
//    let url: URL
//}
//
//
//
//
//#Preview {
//    ModelListView()
//}

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
