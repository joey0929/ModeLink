//
//  ModelListView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/18.
//

//import SwiftUI
//import Firebase
//struct ModelListView: View {
//    @State private var models = [Model]()
//    var body: some View {
//        NavigationView {
//            List(models) { model in
//                NavigationLink(destination: SavedModelPreviewView(modelURL: model.url)) {
//                    Text(model.name)
//                }
//            }
//            .navigationTitle("儲存的模型")
//            .onAppear {
//                fetchModelsFromFirestore() // 將資料庫中的modelURL都load 進來
//            }
//        }
//    }
//    func fetchModelsFromFirestore2() {
//        let db = Firestore.firestore()
//        db.collection("3DModels").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching models: \(error.localizedDescription)")
//                return
//            }
//            self.models = snapshot?.documents.compactMap { doc -> Model? in
//                guard let name = doc.data()["name"] as? String,
//                      let urlString = doc.data()["modelURL"] as? String,
//                      let url = URL(string: urlString) else { return nil }
//                return Model(name: name, url: url)
//            } ?? []
//            print(models)
//        }
//    }
//    func fetchModelsFromFirestore() {
//        let db = Firestore.firestore()
//        // 使用實時監聽器來監聽集合的變化
//        db.collection("3DModels")
//            .order(by: "timestamp", descending: true)
//            .addSnapshotListener { snapshot, error in
//            if let error = error {
//                print("Error fetching models: \(error.localizedDescription)")
//                return
//            }
//            // 更新 models
//            self.models = snapshot?.documents.compactMap { doc -> Model? in
//                guard let name = doc.data()["name"] as? String,
//                      let urlString = doc.data()["modelURL"] as? String,
//                      let url = URL(string: urlString) else { return nil }
//                return Model(name: name, url: url)
//            } ?? []
//            print("Models updated: \(models)")
//        }
//    }
//}
//
//struct Model: Identifiable {
//    let id = UUID()
//    let name: String
//    let url: URL
//}
import SwiftUI
import Firebase
import Kingfisher

struct ModelListView: View {
    @State private var models = [Model]()
    let columns = [GridItem(.flexible())] // 設置兩列的網格布局

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) { // 使用 LazyVGrid 來顯示卡片
                    ForEach(models) { model in
                        NavigationLink(destination: SavedModelPreviewView(modelURL: model.url)) { // 使用 NavigationLink 包裹卡片
                            ZStack { // 使用 ZStack 將圖片放在底層
                                if let imageURL = model.imageURL {
                                    KFImage(imageURL)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 150)
                                        .clipped()
                                        .cornerRadius(10)
                                } else {
                                    // 若沒有圖片 URL，顯示一個默認的佔位符
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 150)
                                        .cornerRadius(10)
                                }

                                // 添加一個半透明背景層以確保文字清晰
                                Rectangle()
                                    .fill(Color.black.opacity(0.4))
                                    .cornerRadius(10)

                                // 顯示模型名稱
                                Text(model.name)
                                    .font(.headline)
                                    .foregroundColor(.white) // 設置文字顏色為白色
                                    .padding()
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity) // 確保名稱佔滿整個卡片寬度
                            }
                            .frame(height: 150) // 設置卡片高度
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("模型庫")
            .onAppear {
                fetchModelsFromFirestore() // 加載數據
            }
        }
    }

    func fetchModelsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("3DModels")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching models: \(error.localizedDescription)")
                return
            }
            self.models = snapshot?.documents.compactMap { doc -> Model? in
                guard let name = doc.data()["name"] as? String,
                      let urlString = doc.data()["modelURL"] as? String,
                      let url = URL(string: urlString) else { return nil }
                let imageURLString = doc.data()["imageURL"] as? String
                let imageURL = imageURLString != nil ? URL(string: imageURLString!) : nil
                return Model(name: name, url: url, imageURL: imageURL)
            } ?? []
            print("Models updated: \(models)")
        }
    }
}

struct Model: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
    let imageURL: URL? // 圖片 URL
}


