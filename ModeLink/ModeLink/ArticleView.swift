//
//  ArticleView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/13.
//

//import SwiftUI
//import Kingfisher
//import Firebase
//import FirebaseStorage
//import FirebaseFirestore
//
//struct Post: Identifiable {
//    var id: String // Firestore 中的 document ID
//    var userId: String
//    var title: String
//    var content: String
//    var county: String
//    var imageURL: String?
//    var timestamp: Date
//}
//
//struct ArticleView: View {
//
//    @State private var posts: [Post] = []
//    //  swiftlint:disable trailing_whitespace
////    var body: some View {
////        NavigationView {
////            ZStack {
////                    // 貼文列表 (底層)
////                    List(posts) { post in
////                        VStack(alignment: .leading) {
////                            Text(post.title)
////                                .font(.headline)
////                            HStack {
////                                Text(post.userId).padding(.trailing)
////                                Text(basicFormattedDate(from: post.timestamp))
////                            }
////                            
////                            Text(post.content)
////                                .font(.subheadline)
////                                .foregroundColor(.gray)
////                            
////                            if let imageURL = post.imageURL {
////                                KFImage(URL(string: imageURL))
////                                    .resizable()
////                                    .scaledToFill() // 確保圖片填滿欄位
////                                    .frame(maxWidth: .infinity, maxHeight: 300) // 限制圖片高度並佔滿寬度
////                                    .clipped() // 防止圖片超出框架
////                                    .cornerRadius(10)
////                            } else {
////                                
////                            }
////                            Spacer()
////                        }
////                        .padding(.vertical, 5)
////                        .frame(height: 400)
////                    }
////                    .navigationTitle("文章列表")
////                    .onAppear {
////                        UIScrollView.appearance().showsVerticalScrollIndicator = false //進到畫面就將滑動條隱藏
////                        startListeningForPosts()
////                    }
////                
////                    // 右下角的 + 按鈕 (頂層)
////                    VStack {
////                        Spacer()
////                        HStack {
////                            Spacer()
////                            NavigationLink(destination: PostView()) {
////                                Image(systemName: "plus")
////                                    .font(.system(size: 30))
////                                    .foregroundColor(.white)
////                                    .padding()
////                                    .background(Color.blue)
////                                    .clipShape(Circle())
////                                    .shadow(radius: 10)
////                            }
////                            .padding()
////                        }
////                    }
////                
////            }
////        }
////    }
//    var body: some View {
//            NavigationView {
//                ZStack {
//                    // 貼文列表 (底層)
//                    List(posts) { post in
//                        VStack(alignment: .leading, spacing: 16) {
//                            // 貼文頂部，包含用戶頭像、用戶名與時間
//                            HStack {
//                                Image(systemName: "person.circle.fill") // 用戶頭像
//                                    .resizable()
//                                    .frame(width: 40, height: 40)
//                                    .foregroundColor(.gray)
//                                
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(post.userId) // 用戶名
//                                        .font(.headline)
//                                    Text(basicFormattedDate(from: post.timestamp)) // 發佈時間
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                                Spacer()
//                                // 禁止符號按鈕，用於封鎖作者文章
//                                Button(action: {
//                                    blockAuthor(post.userId) // 封鎖作者的文章
//                                }) {
//                                    Image(systemName: "nosign") // SF Symbol 禁止符號
//                                        .foregroundColor(.red)
//                                        .frame(width: 30, height: 30) // 固定按鈕大小
//                                        .contentShape(Rectangle()) // 增加可點擊範圍
//                                }
//                                .buttonStyle(BorderlessButtonStyle()) // 防止影響列表的點擊事件
//                                
//                            }
//                            
//                            // 貼文標題與內容
//                            Text(post.title)
//                                .font(.title2)
//                                .bold()
//                            
//                            Text(post.content)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                            
//                            // 貼文圖片
//                            if let imageURL = post.imageURL {
//                                KFImage(URL(string: imageURL))
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(maxWidth: .infinity, maxHeight: 450) // 圖片最大高度 300
//                                    .clipped()
//                                    .cornerRadius(10)
//                            }
//                            
//                            // 貼文互動按鈕
////                            HStack {
////                                Button(action: {
////                                    // 喜歡動作
////                                }) {
////                                    HStack {
////                                        Image(systemName: "heart")
////                                        Text("喜歡")
////                                    }
////                                }
////                                .buttonStyle(BorderlessButtonStyle())
////                                .padding(.trailing, 16)
////                                
////                                Button(action: {
////                                    // 評論動作
////                                }) {
////                                    HStack {
////                                        Image(systemName: "bubble.right")
////                                        Text("評論")
////                                    }
////                                }
////                                .buttonStyle(BorderlessButtonStyle())
////                                Spacer()
////                            }
////                            .padding(.top, 10)
//                        }
//                        .padding(.vertical, 10)
//                    }
//                    .navigationTitle("文章列表")
//                    .onAppear {
//                        UIScrollView.appearance().showsVerticalScrollIndicator = false // 隱藏滾動條
//                        startListeningForPosts()
//                    }
//                    
//                    // 右下角的 + 按鈕 (頂層)
//                    VStack {
//                        Spacer()
//                        HStack {
//                            Spacer()
//                            NavigationLink(destination: PostView()) {
//                                Image(systemName: "plus")
//                                    .font(.system(size: 30))
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .clipShape(Circle())
//                                    .shadow(radius: 10)
//                            }
//                            .padding()
//                        }
//                    }
//                }
//            }
//        }
//    
//    //MARK: - 封鎖特定作者的文章
//    func blockAuthor(_ userId: String) {
//        // 封鎖功能的邏輯處理，比如在本地保存被封鎖的用戶，並過濾他們的文章
//        print("封鎖作者: \(userId)")
//        // 你可以在這裡實現封鎖作者文章的邏輯，比如過濾已封鎖的用戶
//    }
//    //MARK: - Trans TimeStamp to y/m/d/h-min
//    func basicFormattedDate(from date: Date) -> String {
//            let calendar = Calendar.current
//            let year = calendar.component(.year, from: date)
//            let month = calendar.component(.month, from: date)
//            let day = calendar.component(.day, from: date)
//            let hour = calendar.component(.hour, from: date)
//            let minute = calendar.component(.minute, from: date)
//            
//            return "\(year)-\(month)-\(day) \(hour):\(minute)"
//        }
//    //MARK: - Fetch Posts
//    func fetchPosts() {
//        let db = Firestore.firestore()
//        db.collection("articles").getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error fetching articles: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                print("No articles found")
//                return
//            }
//            
//            self.posts = documents.compactMap { doc -> Post? in
//                let data = doc.data()
//                guard let userId = data["user_id"] as? String,
//                      let title = data["title"] as? String,
//                      let content = data["content"] as? String,
//                      let county = data["County"] as? String,
//                      let timestamp = data["timestamp"] as? Timestamp else {
//                    return nil
//                }
//                
//                let imageURL = data["imageURL"] as? String
//                return Post(id: doc.documentID, userId: userId, title: title, content: content, county: county, imageURL: imageURL, timestamp: timestamp.dateValue())
//            }
//        }
//    }
//    //MARK: - Monitoring the FireStore in Articles
//    func startListeningForPosts() {
//        let db = Firestore.firestore()
//        db.collection("articles")
//            .order(by: "timestamp", descending: true)
//            .addSnapshotListener { (snapshot, error) in // 每次數據變化後，posts 列表會自動更新
//            if let error = error {
//                print("Error fetching articles: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                print("No articles found")
//                return
//            }
//            // 將 Firestore 的文檔轉換為 Post 模型，更新列表
//            self.posts = documents.compactMap { doc -> Post? in
//                let data = doc.data()
//                guard let userId = data["user_id"] as? String,
//                      let title = data["title"] as? String,
//                      let content = data["content"] as? String,
//                      let county = data["County"] as? String,
//                      let timestamp = data["timestamp"] as? Timestamp else {
//                    return nil
//                }
//                
//                let imageURL = data["imageURL"] as? String
//                return Post(id: doc.documentID, userId: userId, title: title, content: content, county: county, imageURL: imageURL, timestamp: timestamp.dateValue())
//            }
//        }
//    }
//    
//}
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

    let columns: [GridItem] = [
        GridItem(.fixed(375))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // 使用 LazyVGrid 來顯示貼文
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(posts) { post in
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
//                                HStack {
//                                    Button(action: {
//                                        // 喜歡動作
//                                    }) {
//                                        HStack {
//                                            Image(systemName: "heart")
//                                            Text("喜歡")
//                                        }
//                                    }
//                                    .buttonStyle(BorderlessButtonStyle())
//                                    .padding(.trailing, 16)
//    
//                                    Button(action: {
//                                        // 評論動作
//                                    }) {
//                                        HStack {
//                                            Image(systemName: "bubble.right")
//                                            Text("評論")
//                                        }
//                                    }
//                                    .buttonStyle(BorderlessButtonStyle())
//                                    Spacer()
//                                }
//                                .padding(.top, 10)
                                
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
                //.navigationTitle("文章列表")
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
            }
        }
    }
    
    //MARK: - 封鎖特定作者的文章
    func blockAuthor(_ userId: String) {
        // 封鎖功能的邏輯處理，比如在本地保存被封鎖的用戶，並過濾他們的文章
        print("封鎖作者: \(userId)")
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
    
    //MARK: - Monitoring the FireStore in Articles
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
