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

struct Post2: Identifiable {
    var id: String
    var userId: String
    var title: String
    var content: String
    var county: String
    var imageURL: String?
    var timestamp: Date
    var likes: Int // 新增：儲存讚數量
    var isLiked: Bool // 新增：用來表示當前用戶是否已經點讚
}

struct ArticleView: View {
    @State private var posts: [Post2] = []

    let columns: [GridItem] = [GridItem(.fixed(375))]
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {  // 使用 LazyVGrid 來顯示貼文
                       // ForEach(posts) { post in
                        ForEach(posts.indices, id: \.self) { index in  //用posts的元素當id
                            let post = posts[index]
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "person.circle.fill") // 用戶頭像
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(post.userId) // 用戶名
                                            .font(.headline)
                                        Text(basicFormattedDate(from: post.timestamp)) // 發佈時間
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    // 禁止符號按鈕，用於封鎖作者文章
                                    Button(action: {
                                        blockAuthor(post.userId) // 封鎖作者的文章
                                    }) {
                                        Image(systemName: "nosign")
                                            .foregroundColor(.red)
                                            .frame(width: 30, height: 30) // 固定按鈕大小
                                            .contentShape(Rectangle()) // 增加可點擊範圍
                                    }
                                    .buttonStyle(BorderlessButtonStyle()) // 防止影響列表的點擊事件
                                }

                                Text(post.title)
                                    .font(.title2)
                                    .bold()
                                Text(post.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                if let imageURL = post.imageURL {
                                    KFImage(URL(string: imageURL))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: 450) // 圖片最大高度
                                        .clipped()
                                        .cornerRadius(10)
                                }
                                // 貼文互動按鈕
                                HStack {
                                    Button(action: {
                                        toggleLike(for: index)
                                    }) {
                                        HStack {
                                            Image(systemName: post.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                //.foregroundColor(post.isLiked ? .red : .gray)
                                            Text("\(post.likes)") // 顯示讚數量
                                        }
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    .padding(.trailing, 16)
    
//                                    Button(action: {
//                                        // 評論動作
//                                    }) {
//                                        HStack {
//                                            Image(systemName: "bubble.right")
//                                            Text("評論")
//                                        }
//                                    }
//                                    .buttonStyle(BorderlessButtonStyle())
                                    Spacer()
                                }
                                .padding(.top, 10)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                    .padding()
                    .background(.gray)
                }.background(.gray)
                // .navigationTitle("文章列表")
                .onAppear {
                    UIScrollView.appearance().showsVerticalScrollIndicator = false // 隱藏滾動條
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
                // 右上角齒輪圖標
                .navigationBarItems(trailing: NavigationLink(destination: PersonalView()) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                })
            }
        }
    }
    // MARK: - 封鎖特定作者的文章
    func blockAuthor(_ userId: String) {
        // 封鎖功能的邏輯處理，比如在本地保存被封鎖的用戶，並過濾他們的文章
        print("封鎖作者: \(userId)")
    }
    
    // MARK: - Toggle Like Function
    func toggleLike(for index: Int) {
        var post = posts[index]
        post.isLiked.toggle()
        post.likes += post.isLiked ? 1 : -1
        
        // 更新 Firebase 中的讚數
        let db = Firestore.firestore()
        let postRef = db.collection("articles").document(post.id)
        
        postRef.updateData([
            "likes": post.likes
        ]) { error in
            if let error = error {
                print("Error updating likes: \(error.localizedDescription)")
            } else {
                print("Likes successfully updated")
                posts[index] = post
            }
        }
    }

    // MARK: - Trans TimeStamp to y/m/d/h-min
    func basicFormattedDate(from date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return "\(year)-\(month)-\(day) \(hour):\(minute)"
    }
    // MARK: - Monitoring the FireStore in Articles
    func startListeningForPosts() {
        let db = Firestore.firestore()
        db.collection("articles")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetching articles: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No articles found")
                    return
                }
                self.posts = documents.compactMap { doc -> Post2? in
                    let data = doc.data()
                    guard let userId = data["user_id"] as? String,
                          let title = data["title"] as? String,
                          let content = data["content"] as? String,
                          let county = data["County"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp,
                          let likes = data["likes"] as? Int  //
                    else {
                        return nil
                    }
                    let imageURL = data["imageURL"] as? String
                    return Post2(id: doc.documentID, userId: userId, title: title, content: content, county: county, imageURL: imageURL, timestamp: timestamp.dateValue(),likes: likes,isLiked: false)
                }
            }
    }
}
#Preview{
    ArticleView()
}
