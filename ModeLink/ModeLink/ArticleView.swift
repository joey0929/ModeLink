//
//  ArticleView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/13.
//

import SwiftUI


struct Post: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

struct ArticleView: View {
    
    // 一個模擬的貼文列表
    @State private var posts = [
        Post(title: "貼文1", content: "這是第一篇貼文"),
        Post(title: "貼文2", content: "這是第二篇貼文"),
        Post(title: "貼文3", content: "這是第三篇貼文")
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


#Preview {
    ArticleView()
}
