//
//  ModelListView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/18.
//

import SwiftUI
import Firebase
import Kingfisher

struct ModelListView: View {
    @State private var models = [Model]()
    @State private var selectedCategory: String = "全部" // 預設為全部
    @State private var showCategoryPicker = false // 控制顯示選單
    let columns = [GridItem(.flexible())] //
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 10) { // 使用 LazyVGrid 來顯示卡片
                    ForEach(filteredModels) { model in
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
                                Rectangle()
                                    .fill(Color.black.opacity(0.2))
                                    .cornerRadius(10)
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text(model.name)
                                            .font(.custom("LexendDeca-ExtraBold", size: 20))
                                            .foregroundColor(.white)
                                            .padding()
                                            .lineLimit(1)
                                    }
                                }
                            }
                            .frame(height: 150)
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
                    gradient: Gradient(colors: [Color.theme, Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("模型庫")
                            .font(.custom("LexendDeca-SemiBold", size: 30))
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                        Button(action: {
                            showCategoryPicker = true
                        }) {
                            Image(systemName: "list.bullet")
                                //.font(.title)
                                .font(.custom("LexendDeca-SemiBold", size: 18))
                                .foregroundColor(.white)
                            
                        }
                    }
                }
            }
            .toolbarBackground(Color(.theme), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                fetchModelsFromFirestore() // 加載數據
            }
            .actionSheet(isPresented: $showCategoryPicker) {
                ActionSheet(title: Text("選擇分類"), buttons: [
                    .default(Text("全部")) { selectedCategory = "全部" },
                    .default(Text("模型")) { selectedCategory = "模型" },
                    .default(Text("公仔")) { selectedCategory = "公仔" },
                    .default(Text("其他")) { selectedCategory = "其他" },
                    .cancel()
                ])
            }
        }
    }
    // 根據選擇的分類過濾模型
    var filteredModels: [Model] {
        if selectedCategory == "全部" {
            return models
        } else {
            return models.filter { $0.category == selectedCategory }
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
                      let url = URL(string: urlString),
                let category = doc.data()["category"] as? String else { return nil }
                let imageURLString = doc.data()["imageURL"] as? String
                let imageURL = imageURLString != nil ? URL(string: imageURLString!) : nil
                return Model(name: name, url: url, imageURL: imageURL, category: category)
            } ?? []
            print("Models updated: \(models)")
        }
    }
}
struct Model: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
    let imageURL: URL?
    let category: String
}
struct ModelListView_Previews: PreviewProvider {
    static var previews: some View {
        ModelListView()
    }
}
