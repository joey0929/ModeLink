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
    let columns = [GridItem(.adaptive(minimum: 150))]
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    Section(header: Text("模型工具簡介").font(.title2)) {
                        ForEach(tools) { tool in
                            NavigationLink(destination: IntroToolView(tool: tool)) {
                                ToolCard(tool: tool)
                            }
                        }
                    }
                    Section(header: Text("模型技巧").font(.title2)) {
                        ForEach(skills) { skill in
                            NavigationLink(destination: IntroSkillView(skill: skill)) {
                                SkillCard(skill: skill)
                            }
                        }
                    }
                }
                .padding()
            }
        }.onAppear {
            fetchToolData() // 當視圖出現時抓取tool資料
            fetchSkillData() // 當視圖出現時抓取skill資料
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
        VStack {
            // 使用 Kingfisher 來下載並顯示圖片
            KFImage(URL(string: tool.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .padding()
            
            Text(tool.name)
                .font(.headline)
                .foregroundColor(.primary) // 保持文字顏色一致
        }
        .frame(width: 150, height: 150)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct SkillCard: View {
    let skill: Skill
    var body: some View {
        
        VStack {
//            KFImage(URL(string: skill.imageUrl))
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 80, height: 80)
//                .cornerRadius(8)
//                .padding()
            
            Image(systemName: "hammer")
                .frame(width: 80, height: 80)
            
            
            Text(skill.name)
                .font(.headline)
                .foregroundColor(.primary) //變成預設的顏色
            
        }
        .frame(width: 150, height: 150)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
