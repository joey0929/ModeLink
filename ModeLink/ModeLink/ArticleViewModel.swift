//
//  ArticleViewModel.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/10/17.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ArticleViewModel: ObservableObject {
    @Published var posts: [Post2] = []
    @Published var showAlert = false
    @Published var isImagePreviewPresented = false
    @Published var selectedImageURL: String? = nil
    @Published var showMenuSheet = false
    @Published var selectedPostID: String? = nil
    @Published var isLoadingPreview: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let db = Firestore.firestore()
    
    // 開始監聽貼文
    func startListeningForPosts() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
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
            self.db.collection("articles")
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
                        
                        if blockedUsers.contains(userId) {
                            return nil
                        }
                        
                        let imageURL = data["imageURL"] as? String
                        let likedBy = data["likedBy"] as? [String] ?? []
                        
                        let isLiked = likedBy.contains(currentUserUID)
                        // swiftlint:disable line_length
                        return Post2(id: doc.documentID, userId: userId, userName: userName, title: title, content: content, county: county, imageURL: imageURL, timestamp: timestamp.dateValue(), likes: likes, isLiked: isLiked)
                        // swiftlint:enable line_length
                    }
                }
        }
    }
    
    // 處理按讚的邏輯
    func toggleLike(for post: Post2) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let postRef = db.collection("articles").document(post.id)
        var updatedPost = post
        
        if post.isLiked {
            updatedPost.isLiked = false
            updatedPost.likes -= 1
            postRef.updateData([
                "likes": updatedPost.likes,
                "likedBy": FieldValue.arrayRemove([currentUserUID])
            ])
        } else {
            updatedPost.isLiked = true
            updatedPost.likes += 1
            postRef.updateData([
                "likes": updatedPost.likes,
                "likedBy": FieldValue.arrayUnion([currentUserUID])
            ])
        }
        
        if let index = self.posts.firstIndex(where: { $0.id == post.id }) {
            self.posts[index] = updatedPost
        }
    }
    
    // 處理封鎖作者的邏輯
    func blockAuthor(_ userId: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("無法取得當前使用者 ID")
            return
        }
        
        if userId == currentUserID {
            print("無法封鎖自己")
            return
        }
        
        let userRef = db.collection("users").document(currentUserID)
        userRef.updateData([
            "blockedUsers": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("封鎖作者時發生錯誤: \(error.localizedDescription)")
            } else {
                print("作者已封鎖")
                self.posts.removeAll { $0.userId == userId }
            }
        }
    }
}

