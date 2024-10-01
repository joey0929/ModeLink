//
//  IntroView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/13.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import Kingfisher
//import FirebaseRemoteConfig

struct IntroView: View {
    @State private var tools: [Tool] = [] // 保存從 Firestore 抓取的工具資料
    @State private var skills: [Skill] = [] // 保存從 Firestore 抓取的工具資料
    
    @State private var selectedSegment = 0 // 控制 segment 的選擇
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    let columns2 = [GridItem(.flexible())]
//    var body: some View {
//        NavigationView {
//            ScrollView(showsIndicators: false) {
////                HStack {
////                    Text("模型工具").font(.title2).padding(.leading,30)
////                    Spacer()
////                }
//                    LazyVGrid(columns: columns, spacing: 20) {
//                    Section(header: Text("模型工具").font(.title2)) {
//                        ForEach(tools) { tool in
//                            NavigationLink(destination: IntroToolView(tool: tool)) {
//                                ToolCard(tool: tool)
//                                    .padding(.horizontal, 5) // 調整卡片的內部間距
//                            }
//                        }
//                    }
////                    Section(header: Text("模型技巧").font(.title2)) {
////                        ForEach(skills) { skill in
////                            NavigationLink(destination: IntroSkillView(skill: skill)) {
////                                SkillCard(skill: skill)
////                            }
////                        }
////                    }
//                }
//                .padding()
//                LazyVGrid(columns: columns2, spacing: 20) {
//                    Section(header: Text("模型技巧").font(.title2)) {
//                        ForEach(skills) { skill in
//                            NavigationLink(destination: IntroSkillView(skill: skill)) {
//                                SkillCard(skill: skill)
//                            }
//                        }
//                    }
//                }
//                
//                
//                
//                
//            }
//        }.onAppear {
//            fetchToolData() // 當視圖出現時抓取tool資料
//            fetchSkillData() // 當視圖出現時抓取skill資料
//        }
//    }
    var body: some View {
            NavigationView {
                VStack {
                    
                   // HStack {
                       // Spacer()
                        Picker("", selection: $selectedSegment) {
                            Text("模型工具")
                                .font(.system(size: 60)).tag(0)
                            Text("模型技巧").font(.system(size: 60)).tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle()) // 使用 Segmented 樣式
                        .scaleEffect(1.1) // 放大整個 Picker 的比例
                       // .frame(width: 330, height: 60) // 調整 Picker 的高度
                        .padding()
                        .background(Color(.systemGray6)) // 設置背景顏色
                        .cornerRadius(10) // 添加圓角
                        //.shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5) // 添加陰影
                        .padding([.horizontal], 15)
                        //.padding(.top, 10)
                       // Spacer()
                   // }
                    ScrollView(showsIndicators: false) {
                        if selectedSegment == 0 {
                            // 第一個 LazyVGrid
                            LazyVGrid(columns: columns, spacing: 20) { // 調整 spacing
                                Section(header: Text("").font(.title2)) {
                                    ForEach(tools) { tool in
                                        NavigationLink(destination: IntroToolView(tool: tool)) {
                                            ToolCard(tool: tool)
                                                .padding(.horizontal, 10) // 調整卡片的內部間距
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 10) // 整個網格的外部間距
                            //.padding(.vertical, 1)
                        } else {
                            // 第二個 LazyVGrid
                            LazyVGrid(columns: columns2, spacing: 20) {
                                Section(header: Text("").font(.title2)) {
                                    ForEach(skills) { skill in
                                        NavigationLink(destination: IntroSkillView(skill: skill)) {
                                            SkillCard(skill: skill)
                                                .padding(.horizontal, 10) // 調整卡片的內部間距
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 10) // 整個網格的外部間距
                        }
                    }
                }.background(Color(.systemGray6))
                .onAppear {
                    fetchToolData() // 當視圖出現時抓取工具資料
                    fetchSkillData() // 當視圖出現時抓取技能資料
                }
            }
        }
    // 抓取 Firestore 中的工具資料
    func fetchToolData() {
        let db = Firestore.firestore()
        db.collection("toolDatas")
            .order(by:"position")
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("抓取資料時發生錯誤：\(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                self.tools = snapshot.documents.compactMap { doc -> Tool? in
                    let data = doc.data()
                    guard
                        let name = data["name"] as? String,
                        let price = data["price"] as? String,
                        let recommend = data["recommend"] as? String,
                        let description = data["description"] as? String,
                        let position = data["position"] as? Int,
                        let imageUrl = data["image_url"] as? String else {
                        return nil
                    }
                    return Tool(id: doc.documentID, name: name, price: price, recommend: recommend, description: description, imageUrl: imageUrl, position: position)
                }
            }
        }
    }
    func fetchSkillData() {
        let db = Firestore.firestore()
        db.collection("skillDatas")
            .order(by:"position")
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("抓取資料時發生錯誤：\(error.localizedDescription)")
                return
            }
            if let snapshot = snapshot {
                self.skills = snapshot.documents.compactMap { doc -> Skill? in
                    let data = doc.data()
                    guard
                        let name = data["name"] as? String,
                        let description = data["description"] as? String,
                        let position = data["position"] as? Int,
                        let imageUrl = data["image_url"] as? String,
                        let ytUrl = data["yt_url"] as? String
                    else {
                        return nil
                    }
                    return Skill(name: name, description: description, imageUrl: imageUrl, position: position, ytUrl: ytUrl)
                }
            }
        }
    }
}

#Preview {
    IntroView()
}

struct Tool: Identifiable {
    let id: String
    let name: String
    let price: String
    let recommend: String
    let description: String
    let imageUrl: String
    let position: Int
}

struct Skill: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageUrl: String
    let position: Int
    let ytUrl: String
}

struct ToolCard: View {
    let tool: Tool
    var body: some View {
        ZStack {
            // 使用 Kingfisher 來下載並顯示圖片
            KFImage(URL(string: tool.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 130)
                .cornerRadius(8)
                .padding()
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .frame(height: 150)
                .cornerRadius(10)
            Text(tool.name)
                .foregroundColor(.white)
                .font(.headline)
                .foregroundColor(.primary) // 保持文字顏色一致
        }
        .frame(width: 165, height: 150)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct SkillCard: View {
    let skill: Skill
    var body: some View {
        
        ZStack {
            KFImage(URL(string: skill.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350, height: 150)
                .cornerRadius(8)
                .padding()
            
//            Image(systemName: "hammer")
//                .frame(width: 80, height: 80)
            Rectangle()
                .fill(Color.black.opacity(0.4))
                .frame(height: 150)
                .cornerRadius(10)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(skill.name)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.trailing, 10)
                        .font(.headline)
                        .foregroundColor(.primary) //變成預設的顏色
                }
            }
        }
        .frame(width: 350, height: 150)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
