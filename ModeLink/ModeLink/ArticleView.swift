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
    @State private var isLoadingPreview: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    let columns: [GridItem] = [GridItem(.fixed(370))]
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

                                Text(post.content)
                                    .font(.headline)
                                    .foregroundColor(.black.opacity(0.8))
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .allowsHitTesting(false)
                                if let imageURL = post.imageURL {
                                    KFImage(URL(string: imageURL))
                                        .resizable()
                                        //.scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: 280) // 圖片最大高度
                                        .clipped()
                                        .cornerRadius(10)
                                        .contentShape(Rectangle())
//                                        .onTapGesture {
//                                            selectedImageURL = imageURL
//                                            isImagePreviewPresented = true
//                                        }
                                        .onTapGesture {
                                            handleImageTap(imageURL: imageURL)
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
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.theme, Color.white]), // 設定漸層顏色
                            startPoint: .top, // 漸層起點
                            endPoint: .bottom // 漸層終點
                        )
                    )
                }
                .refreshable {
                    startListeningForPosts() // 刷新操作重新載入貼文
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.theme, Color.white]), // 設定漸層顏色
                        startPoint: .top, // 漸層起點
                        endPoint: .bottom // 漸層終點
                    )
                )
                //.background(Color(.white))
                .onAppear {
                    UIScrollView.appearance().showsVerticalScrollIndicator = false // 隱藏滾動條
                    startListeningForPosts()
                }
                .fullScreenCover(isPresented: $isImagePreviewPresented) {
                    ImagePreviewView(imageURL: selectedImageURL, isPresented: $isImagePreviewPresented)
                }
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
                            .foregroundColor(.black) // 設置取消按鈕
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
                                    //.font(.title)
                                    .font(.custom("LexendDeca-Medium", size: 30))
                                    .foregroundColor(.white.opacity(0.9))
                                    .bold()
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: PersonalView()) {
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
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
                .toolbarBackground(Color(.theme), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                
                // 載入指示器覆蓋層
                if isLoadingPreview {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        ProgressView("載入中...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    // 處理圖片點擊事件
    func handleImageTap(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        isLoadingPreview = true
        
        KingfisherManager.shared.retrieveImage(with: url) { result in
            DispatchQueue.main.async {
                isLoadingPreview = false
                switch result {
                case .success(_):
                    selectedImageURL = imageURL
                    isImagePreviewPresented = true
                case .failure(let error):
                    // 處理錯誤，例如顯示警告訊息
                    print("Failed to load image: \(error)")
                    errorMessage = "無法載入圖片，請稍後再試。"
                    showErrorAlert = true
                }
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
    @StateObject private var imageLoader = ImageLoader()
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if imageLoader.isLoading {
                ProgressView("載入中...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(10)
            } else if imageLoader.loadFailed {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                    Text("無法載入圖片")
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            } else if let uiImage = imageLoader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding()
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                if value.translation.height > 0 {
                                    state = value.translation
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > 100 {
                                    withAnimation {
                                        isPresented = false
                                    }
                                }
                            }
                    )
            } else {
                // 當 imageURL 為 nil 或無效時顯示錯誤訊息
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                    Text("無效的圖片連結")
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            //.cornerRadius(10)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }.padding()
                }
                Spacer()
            }
        }
        .onAppear {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                imageLoader.loadImage(from: url)
            } else {
                imageLoader.loadFailed = true
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var loadFailed: Bool = false
    
    func loadImage(from url: URL) {
        isLoading = true
        loadFailed = false
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let value):
                    self?.image = value.image
                case .failure(_):
                    self?.loadFailed = true
                }
            }
        }
    }
}
