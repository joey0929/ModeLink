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
import FirebaseAuth

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
    var userName: String
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
    @State private var showAlert = false
    
    @State private var isImagePreviewPresented = false
    @State private var selectedImageURL: String? = nil

    @State private var showMenuSheet = false // 控制選單的顯示
    @State private var selectedPostID: String? = nil // 用於儲存當前選中的貼文 ID
    
    let columns: [GridItem] = [GridItem(.fixed(375))]
    var body: some View {
        NavigationStack {
            ZStack {
//                Color(.orange).ignoresSafeArea()
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
                                        Text(post.userName) // 用戶名
                                            .font(.headline)
                                        Text(basicFormattedDate(from: post.timestamp)) // 發佈時間
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    
                                    Text(post.county).font(.headline)
                                        
                                    // 在這裡使用 ContextMenu
//                                    Button(action: {
//                                        //print("123")
//                                    }, label: {
//                                        Image(systemName: "ellipsis").foregroundColor(.black).frame(width: 30,height: 30)
//                                    })
//                                    .contextMenu {
//                                        Button(action: {
//                                            showAlert = true // 顯示檢舉的提示
//                                        }) {
//                                            Label("檢舉", systemImage: "flag.fill")
//                                        }
//                                        
//                                        Button(action: {
//                                            blockAuthor(post.userId) // 封鎖作者的文章
//                                        }) {
//                                            Label("封鎖", systemImage: "nosign")
//                                        }
//                                    }
                                    // 按鈕來控制顯示自訂選單
                                    Button(action: {
                                        selectedPostID = post.userId // 設定選中的貼文 ID
                                        showMenuSheet = true // 顯示選單
                                    }, label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.black)
                                            .frame(width: 30, height: 30)
                                    })
                                    
                                }

                                Text(post.title)
                                    .font(.title2)
                                    .bold()
                                    .allowsHitTesting(false)
//                                Text(post.content)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                                    .lineLimit(2)
                                
                                Text(post.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .allowsHitTesting(false)
                                
                                
                                
                                if let imageURL = post.imageURL {
                                    KFImage(URL(string: imageURL))
                                        .resizable()
                                        //.scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: 300) // 圖片最大高度
                                        .clipped()
                                        .cornerRadius(10)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            selectedImageURL = imageURL
                                            isImagePreviewPresented = true
                                        }
                                }
                                // 貼文互動按鈕
                                HStack {
                                    Button(action: {
                                        toggleLike(for: index)
                                    }) {
                                        HStack {
                                            Image(systemName: post.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup").padding(.leading,5)
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
                                    // 檢舉按鈕
                                    Spacer()
//                                       Button(action: {
//                                           showAlert = true // 顯示檢舉的提示
//                                       }) {
//                                           Image(systemName: "flag.fill") // 使用小旗子圖示
//                                               .foregroundColor(.orange)
//                                               .frame(width: 30, height: 30)
//                                               .contentShape(Rectangle())
//                                       }
//                                       .buttonStyle(BorderlessButtonStyle())
//                                       .padding(.trailing, 16)
//                                       .alert(isPresented: $showAlert) {
//                                           Alert(title: Text("檢舉成功"), message: Text("已成功檢舉該內容。"), dismissButton: .default(Text("確定")))
//                                       }
////                                    Spacer()
//                                    Button(action: {
//                                        blockAuthor(post.userId) // 封鎖作者的文章
//                                    }) {
//                                        Image(systemName: "nosign")
//                                            .foregroundColor(.red)
//                                            .frame(width: 30, height: 30) // 固定按鈕大小
//                                            .contentShape(Rectangle()) // 增加可點擊範圍
//                                            //.border(Color.blue) // 添加邊框以檢查點擊區域
//                                    }
//                                    .buttonStyle(BorderlessButtonStyle()) // 防止影響列表的點擊事件
//                                    .padding(.trailing,50)
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
                    .background(Color(.systemGray6))
                }
                .background(Color(.systemGray6))
                .onAppear {
                    UIScrollView.appearance().showsVerticalScrollIndicator = false // 隱藏滾動條
                    startListeningForPosts()
                }
                .fullScreenCover(isPresented: $isImagePreviewPresented) {
                    ImagePreviewView(imageURL: selectedImageURL, isPresented: $isImagePreviewPresented)
                }
//                .sheet(isPresented: $showMenuSheet) {
//                    HStack {
//                        Button(action: {
//                            
//                            showMenuSheet = false // 關閉選單
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                showAlert = true
//                            }
//                        }) {
//                            Label("檢舉", systemImage: "flag.fill")
//                        }
//                        .padding()
//                        
//                        Button(action: {
//                            // 假設 blockAuthor 是你的封鎖方法
//                            blockAuthor(posts[0].userId)
//                            showMenuSheet = false // 關閉選單
//                        }) {
//                            Label("封鎖", systemImage: "nosign")
//                        }
//                        .padding()
//                        
//                        Button(action: {
//                            showMenuSheet = false // 取消操作，關閉選單
//                        }) {
//                            Text("取消")
//                                .foregroundColor(.blue)
//                        }
//                        .padding()
//                    }
//                   // .padding()
//                    .presentationDetents([.fraction(0.1)]) // 控制選單高度
//                }
                .sheet(isPresented: $showMenuSheet) {
                    HStack(spacing: 30) { // 調整按鈕間的間距
                        Button(action: {
                            showMenuSheet = false // 關閉選單
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showAlert = true
                            }
                        }) {
                            VStack {
                                Image(systemName: "flag.fill")
                                Text("檢舉")
                            }
                            .foregroundColor(.black) // 設置顏色為黑色
                        }
                        .padding()
                        
                        Button(action: {
                            // 假設 blockAuthor 是你的封鎖方法
                            if let postID = selectedPostID {
                                blockAuthor(postID) // 使用選中的貼文 ID 進行封鎖
                            }
                            //blockAuthor(selectedPostID ?? "")
                            showMenuSheet = false // 關閉選單
                        }) {
                            VStack {
                                Image(systemName: "nosign")
                                Text("封鎖")
                            }
                            .foregroundColor(.black) // 設置顏色為黑色
                        }
                        .padding()
                        
                        Button(action: {
                            showMenuSheet = false // 取消操作，關閉選單
                        }) {
                            VStack {
                                Image(systemName: "xmark")
                                Text("取消")
                            }
                            .foregroundColor(.black) // 設置取消按鈕的顏色為藍色
                        }
                        .padding()
                    }
                    .padding() // 增加外層內邊距
                    .presentationDetents([.fraction(0.1)]) // 控制選單高度
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("檢舉成功"), message: Text("已成功檢舉該內容。"), dismissButton: .default(Text("確定")))
                }
                
                
                
                
                // 右下角的 + 按鈕 (頂層)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: PostView()) {
                            Image(systemName: "plus.square.on.square")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .padding()
                    }
                }
                
                
                .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("ModeLink")
                                    .font(.title)
                                    .bold()
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: PersonalView()) {
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                // 右上角齒輪圖標
//                .navigationBarItems(trailing: NavigationLink(destination: PersonalView()) {
//                    Image(systemName: "gearshape")
//                        .font(.system(size: 20))
//                        .foregroundColor(.black)
//                })
//                .navigationTitle("動態牆")
                //.navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitleDisplayMode(.inline) // 可選，調整標題顯示方式
                .toolbarBackground(Color(.white), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)

            }
        }
    }
    // MARK: - 封鎖特定作者的文章
    func blockAuthor(_ userId: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("無法取得當前使用者 ID")
            return
        }
        // 禁止封鎖自己
        if userId == currentUserID {
            print("無法封鎖自己")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserID)
        userRef.updateData([
            "blockedUsers": FieldValue.arrayUnion([userId]) // 加入新的作者 ID 到封鎖列表
        ]) { error in
            if let error = error {
                print("封鎖作者時發生錯誤: \(error.localizedDescription)")
            } else {
                print("作者已封鎖")
                // 過濾被封鎖作者的文章
                self.posts.removeAll { $0.userId == userId }
            }
        }
    }
    // MARK: - Toggle Like Function
    func toggleLike(for index: Int) {
        var post = posts[index]
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        // 判斷是否已按讚
        if post.isLiked {
            // 已按讚，取消讚
            post.isLiked = false
            post.likes -= 1
            // 從 likedBy 列表中移除當前使用者的 UID
            let db = Firestore.firestore()
            let postRef = db.collection("articles").document(post.id)
            postRef.updateData([
                "likes": post.likes,
                "likedBy": FieldValue.arrayRemove([currentUserUID])
            ]) { error in
                if let error = error {
                    print("Error updating likes: \(error.localizedDescription)")
                } else {
                    print("Likes successfully updated")
                    posts[index] = post
                }
            }
        } else {
            // 未按讚，新增讚
            post.isLiked = true
            post.likes += 1
            // 將當前使用者的 UID 加入 likedBy 列表
            let db = Firestore.firestore()
            let postRef = db.collection("articles").document(post.id)
            postRef.updateData([
                "likes": post.likes,
                "likedBy": FieldValue.arrayUnion([currentUserUID])
            ]) { error in
                if let error = error {
                    print("Error updating likes: \(error.localizedDescription)")
                } else {
                    print("Likes successfully updated")
                    posts[index] = post
                }
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
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        // 1. 取得當前使用者的 blockedUsers 列表
        db.collection("users").document(currentUserUID).addSnapshotListener { userSnapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let userData = userSnapshot?.data(),
                  let blockedUsers = userData["blockedUsers"] as? [String] else {
                print("No blocked users found")
                return
            }
            
            // 2. 監聽文章數據
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
                    
                    // 3. 過濾被封鎖作者的文章
                    self.posts = documents.compactMap { doc -> Post2? in
                        let data = doc.data()
                        guard let userId = data["user_id"] as? String,
                              let userName = data["user_name"] as? String,
                              let title = data["title"] as? String,
                              let content = data["content"] as? String,
                              let county = data["County"] as? String,
                              let timestamp = data["timestamp"] as? Timestamp,
                              let likes = data["likes"] as? Int else {
                            return nil
                        }
                        
                        // 過濾封鎖的使用者
                        if blockedUsers.contains(userId) {
                            return nil
                        }
                        
                        let imageURL = data["imageURL"] as? String
                        let likedBy = data["likedBy"] as? [String] ?? []
                        
                        // 判斷當前使用者是否已按讚
                        let isLiked = likedBy.contains(currentUserUID)
                        // swiftlint:disable line_length
                        return Post2(id: doc.documentID, userId: userId, userName: userName, title: title, content: content, county: county, imageURL: imageURL, timestamp: timestamp.dateValue(), likes: likes, isLiked: isLiked)
                        // swiftlint:enable line_length
                    }
                }
        }
    }

}
#Preview{
    ArticleView()
}





struct ImagePreviewView: View {
    let imageURL: String?
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let imageURL = imageURL {
                KFImage(URL(string: imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }

            VStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Text("關閉")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}
