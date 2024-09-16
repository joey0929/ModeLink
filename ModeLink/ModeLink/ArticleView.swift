//
//  ArticleView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/13.
//

import SwiftUI
import Kingfisher
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct Post: Identifiable {
    var id: String // Firestore 中的 document ID
    var userId: String
    var title: String
    var content: String
    var county: String
    var imageURL: String?
    var timestamp: Date
}

struct ArticleView: View {

    @State private var posts: [Post] = []
    //  swiftlint:disable trailing_whitespace
    var body: some View {
        NavigationView {
            ZStack {
                    // 貼文列表 (底層)
                    List(posts) { post in
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                            HStack {
                                Text(post.userId).padding(.trailing)
                                Text(basicFormattedDate(from: post.timestamp))
                            }
                            
                            Text(post.content)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if let imageURL = post.imageURL {
                                KFImage(URL(string: imageURL))
                                    .resizable()
                                    .scaledToFill() // 確保圖片填滿欄位
                                    .frame(maxWidth: .infinity, maxHeight: 300) // 限制圖片高度並佔滿寬度
                                    .clipped() // 防止圖片超出框架
                                    .cornerRadius(10)
                            } else {
                                
                            }
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .frame(height: 400)
                    }
               // }
                    .navigationTitle("文章列表")
                    .onAppear {
                        UIScrollView.appearance().showsVerticalScrollIndicator = false //進到畫面就將滑動條隱藏
                        startListeningForPosts()
                    }
                
                    // 右下角的 + 按鈕 (頂層)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(destination: PostView()) {
                                Image(systemName: "plus")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            }
                            .padding()
                        }
                    }
                
            }
        }
    }
    //MARK: - Trans TimeStamp to y/m/d/h-min
    func basicFormattedDate(from date: Date) -> String {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            
            return "\(year)-\(month)-\(day) \(hour):\(minute)"
        }
    //MARK: - Fetch Posts
    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("articles").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching articles: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No articles found")
                return
            }
            
            self.posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                guard let userId = data["user_id"] as? String,
                      let title = data["title"] as? String,
                      let content = data["content"] as? String,
                      let county = data["County"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp else {
                    return nil
                }
                
                let imageURL = data["imageURL"] as? String
                return Post(id: doc.documentID, userId: userId, title: title, content: content, county: county, imageURL: imageURL, timestamp: timestamp.dateValue())
            }
        }
    }
    //MARK: - Monitoring the FireStore in Articles
    func startListeningForPosts() {
        let db = Firestore.firestore()
        db.collection("articles")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (snapshot, error) in // 每次數據變化後，posts 列表會自動更新
            if let error = error {
                print("Error fetching articles: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No articles found")
                return
            }
            // 將 Firestore 的文檔轉換為 Post 模型，更新列表
            self.posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                guard let userId = data["user_id"] as? String,
                      let title = data["title"] as? String,
                      let content = data["content"] as? String,
                      let county = data["County"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp else {
                    return nil
                }
                
                let imageURL = data["imageURL"] as? String
                return Post(id: doc.documentID, userId: userId, title: title, content: content, county: county, imageURL: imageURL, timestamp: timestamp.dateValue())
            }
        }
    }
    
}

#Preview{
    ArticleView()
}
