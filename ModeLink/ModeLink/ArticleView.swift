//
//  ArticleView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/13.
//

import SwiftUI
import Kingfisher


struct Post: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    var imageURL: String? // 新增一個圖片URL
}

struct ArticleView: View {
    // 一個模擬的貼文列表
    @State private var posts = [
        Post(title: "貼文1", content: "這是第一篇貼文", imageURL: "https://firebasestorage.googleapis.com/v0/b/modelink-298ca.appspot.com/o/images%2FB6DA4335-B641-4366-BAF9-3A62F5230F41.jpg?alt=media&token=cca6a847-2d7f-428a-acfc-a8a45ce33a80"),
        Post(title: "貼文2", content: "這是第二篇貼文", imageURL: nil),
        Post(title: "貼文3", content: "這是第三篇貼文", imageURL: nil)
    ]
    var body: some View {
        NavigationView {
            ZStack {
                // 貼文列表 (底層)
                List(posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.content)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if let imageURL = post.imageURL {
                            KFImage(URL(string: imageURL))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150) // 設置圖片高度
                                .cornerRadius(10)
                                .padding(.top, 10)
                        } else {
                            
                        }
                        Spacer()
                        
                    }
                    .padding(.vertical, 5)
                    .frame(height: 250)
                }
                .navigationTitle("文章列表")
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
}

#Preview{
    ArticleView()
}
