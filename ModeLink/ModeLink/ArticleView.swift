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
                    viewModel.startListeningForPosts() // 刷新操作重新載入貼文
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.theme, Color.white]), // 設定漸層顏色
                        startPoint: .top, // 漸層起點
                        endPoint: .bottom // 漸層終點
                    )
                )
                .onAppear {
                    viewModel.startListeningForPosts()
                }
                .fullScreenCover(isPresented: $viewModel.isImagePreviewPresented) {
                    ImagePreviewView(imageURL: viewModel.selectedImageURL, isPresented: $viewModel.isImagePreviewPresented)
                }
                .sheet(isPresented: $viewModel.showMenuSheet) {
                    HStack(spacing: 30) { // 調整按鈕間的間距
                        Button(action: {
                            viewModel.showMenuSheet = false // 關閉選單
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                viewModel.showAlert = true
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
                            if let postID = viewModel.selectedPostID {
                                viewModel.blockAuthor(postID) // 使用選中的貼文 ID 進行封鎖
                            }
                            //blockAuthor(selectedPostID ?? "")
                            viewModel.showMenuSheet = false // 關閉選單
                        }) {
                            VStack {
                                Image(systemName: "nosign")
                                Text("封鎖")
                            }
                            .foregroundColor(.black) // 設置顏色為黑色
                        }
                        .padding()
                        
                        Button(action: {
                            viewModel.showMenuSheet = false // 取消操作，關閉選單
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
                .alert(isPresented: $viewModel.showAlert) {
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
                .navigationBarTitleDisplayMode(.inline) // 可選，調整標題顯示方式
                .toolbarBackground(Color(.theme), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                
                // 載入指示器覆蓋層
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
