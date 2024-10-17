//
//  ImagePreViewView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/10/17.
//

import SwiftUI
import Kingfisher

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
