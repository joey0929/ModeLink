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
    var id: String
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
    var likes: Int // 儲存讚數量
    var isLiked: Bool // 用來表示當前用戶是否已經點讚
}
struct ArticleView: View {
    @StateObject private var viewModel = ArticleViewModel()
    let columns: [GridItem] = [GridItem(.fixed(370))]
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.posts) { post in
                            ArticleCardView(post: post, viewModel: viewModel)
                        }
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.theme, Color.white]), startPoint: .top, endPoint: .bottom))
                }
                .refreshable {
                    viewModel.startListeningForPosts()
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.theme, Color.white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .onAppear {
                    viewModel.startListeningForPosts()
                }
                .fullScreenCover(isPresented: $viewModel.isImagePreviewPresented) {
                    ImagePreviewView(imageURL: viewModel.selectedImageURL, isPresented: $viewModel.isImagePreviewPresented)
                }
                .sheet(isPresented: $viewModel.showMenuSheet) {
                    HStack(spacing: 30) {
                        Button(action: {
                            viewModel.showMenuSheet = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                viewModel.showAlert = true
                            }
                        }) {
                            VStack {
                                Image(systemName: "flag.fill")
                                Text("檢舉")
                            }
                            .foregroundColor(.black)
                        }
                        .padding()
                        
                        Button(action: {
                            if let postID = viewModel.selectedPostID {
                                viewModel.blockAuthor(postID)
                            }
                            viewModel.showMenuSheet = false
                        }) {
                            VStack {
                                Image(systemName: "nosign")
                                Text("封鎖")
                            }
                            .foregroundColor(.black)
                        }
                        .padding()
                        
                        Button(action: {
                            viewModel.showMenuSheet = false // 取消操作，關閉選單
                        }) {
                            VStack {
                                Image(systemName: "xmark")
                                Text("取消")
                            }
                            .foregroundColor(.black)
                        }
                        .padding()
                    }
                    .padding()
                    .presentationDetents([.fraction(0.1)])
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("檢舉成功"), message: Text("已成功檢舉該內容。"), dismissButton: .default(Text("確定")))
                }
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
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(.theme), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                if viewModel.isLoadingPreview {
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
}

#Preview{
    ArticleView()
}
