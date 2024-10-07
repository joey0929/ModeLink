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
//    @State private var models = [
//           Model(name: "模型一", url: URL(string: "https://example.com/model1.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//           Model(name: "模型二", url: URL(string: "https://example.com/model2.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//           Model(name: "模型三", url: URL(string: "https://example.com/model3.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//           Model(name: "模型四", url: URL(string: "https://example.com/model4.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//           Model(name: "模型五", url: URL(string: "https://example.com/model5.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//           Model(name: "模型六", url: URL(string: "https://example.com/model6.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//           Model(name: "模型七", url: URL(string: "https://example.com/model7.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//           Model(name: "模型八", url: URL(string: "https://example.com/model8.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150"))
//       ]
    
     
    let columns = [GridItem(.flexible())] //

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
                                    .fill(Color.black.opacity(0.2))
                                    .cornerRadius(10)
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(model.name)
                                            .font(.custom("LexendDeca-ExtraBold", size: 20))
                                            .foregroundColor(.white) // 設置文字顏色為白色
                                            .padding()
                                            .lineLimit(1)
                                           // .frame(maxWidth: .infinity) // 確保名稱佔滿整個卡片寬度
                                    }
                                }
                                // 顯示模型名稱
//                                Text(model.name)
//                                    .font(.headline)
//                                    .foregroundColor(.white) // 設置文字顏色為白色
//                                    .padding()
//                                    .lineLimit(1)
//                                    .frame(maxWidth: .infinity) // 確保名稱佔滿整個卡片寬度
                            }
                            .frame(height: 150) // 設置卡片高度
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.vertical, 2)
                        }
                    }
                }
                .padding()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.theme, Color.white]), // 設定漸層顏色
                    startPoint: .top, // 漸層起點
                    endPoint: .bottom // 漸層終點
                )
            )
//            .navigationTitle("模型庫")
            .toolbar {
                ToolbarItem(placement: .principal) { // 自訂標題
                    HStack {
                        Text("模型庫")
                            .font(.custom("LexendDeca-SemiBold", size: 30)) // 自訂字體
                            .foregroundColor(.white) // 自訂顏色
                            .bold()
                        Spacer()
//                        Button(action: {
//                            // 這裡是篩選按鈕的動作
//                            print("Filter button tapped")
//                        }) {
//                            Image(systemName: "line.horizontal.3.decrease.circle")
//                                .font(.title)
//                                .foregroundColor(.blue)
//                        }
                    }
                }
            }
            .toolbarBackground(Color(.theme), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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

//#Preview {
//    let models2 = [
//    Model(name: "模型一", url: URL(string: "https://example.com/model1.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//    Model(name: "模型二", url: URL(string: "https://example.com/model2.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//    Model(name: "模型三", url: URL(string: "https://example.com/model3.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//    Model(name: "模型四", url: URL(string: "https://example.com/model4.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//    Model(name: "模型五", url: URL(string: "https://example.com/model5.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//    Model(name: "模型六", url: URL(string: "https://example.com/model6.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//    Model(name: "模型七", url: URL(string: "https://example.com/model7.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150")),
//    Model(name: "模型八", url: URL(string: "https://example.com/model8.usdz")!, imageURL: URL(string: "https://via.placeholder.com/150"))
//]
//    ModelListView(models: models2)
//}

struct ModelListView_Previews: PreviewProvider {
    static var previews: some View {
        ModelListView()
    }
}
