//
//  PostView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/15.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import FirebaseAuth
import IQKeyboardManagerSwift
import Combine

struct PostView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var userName: String = "" // 用於儲存用戶名稱
    @State private var title = ""
    @State private var content = ""
    @State private var county = "" // 所在縣市
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil // 用於存儲選擇的圖片
    @State private var isImagePickerPresented = false
    
    @ObservedObject private var keyboardResponder = KeyboardResponder() // 使用 KeyboardResponder
    // 設定縣市
    let counties = ["台北市", "新北市", "桃園市", "台中市", "台南市", "高雄市", "基隆市", "新竹市", "嘉義市", "新竹縣", "苗栗縣", "彰化縣", "南投縣", "雲林縣", "嘉義縣", "屏東縣", "宜蘭縣", "花蓮縣", "台東縣", "澎湖縣", "金門縣", "連江縣"]

    var canSubmit: Bool {
        // 當所有欄位都有填寫時返回 true，否則返回 false
        return !title.isEmpty && !content.isEmpty && !county.isEmpty
        //return !title.isEmpty && !content.isEmpty && !county.isEmpty && selectedImage != nil
    }
    var body: some View {
        //  swiftlint:disable trailing_whitespace
        ZStack {
            ScrollView(showsIndicators: false) {
                
                VStack {
                    // 用於顯示選擇的圖片或按鈕
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipped()
                                .padding([.horizontal], 15)
                                .padding(.top, 15)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 300)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.system(size: 50))
                                            .foregroundColor(.gray)
                                        Text("點擊選擇圖片")
                                            .foregroundColor(.gray)
                                    }
                                )
                                .padding([.horizontal], 15)
                                .padding(.top, 15)
                        }
                    }.onChange(of: selectedItem) { newItem in
                        if let newItem = newItem {
                            Task {
                                // 當選擇項變更時，將圖片加載為 UIImage
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   // 圖片加載為 Data 格式 再轉乘 UIImage
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }
                    }
                    TextField("標題", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal,15)
                        .padding(.top, 10)
                    // 縣市選單
                    HStack {
                        Text("選擇縣市:")
                            .foregroundColor(Color(.systemGray))
                        Spacer()
                        Picker("請選擇縣市", selection: $county) {
                            ForEach(counties, id: \.self) { county in
                                Text(county)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // 使用下拉選單樣式
                        .frame(width: 100)
                        //.padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 0.5)
                        )
                    }
                    .padding(.horizontal,15)
                    .padding(.bottom, 10)
                    VStack(alignment:.leading) {
                        Text("請輸入內文:")
                            .foregroundColor(Color(.systemGray))
                        TextEditor(text: $content)
                            .frame(height: 150)
                            .background(Color.white) // 設置背景色，確保與 TextField 保持一致
                            .cornerRadius(8) // 設置圓角
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 0.5) // 設置外框的顏色和寬度
                            )
                            .padding(.top, 5)
                    }.padding(.horizontal, 15) // 確保整個 VStack 具有左右縮排
                    // 使用 PhotosPicker 來選擇圖片
                    HStack {
                        Spacer()
                        Button(action: {
                            uploadPost(title: title, content: content, county: county, image: selectedImage)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("發文")
                                .font(.headline)
                                .foregroundColor(canSubmit ? Color.white : Color.gray)
                                .padding([.horizontal,.vertical],10)
                                .background(canSubmit ? Color.blue : Color(.systemGray5)) // 根據狀態變色
                                .cornerRadius(10)
                        }
                        .disabled(!canSubmit)
                        .padding(.trailing,14)
                    }
                    .padding(.leading)
                    .padding(.bottom, 10)
                    //Spacer(minLength: 80)
                }
                .onAppear() {
                    fetchUserName()
                }
                .padding(.bottom, keyboardResponder.currentHeight) // 調整底部間距
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.8), radius: 5, x: 0, y: 5)
            .frame(height: 620)
            .padding(.horizontal)
            .toolbar {
                // 自訂返回按鈕
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white) // 設定返回按鈕的顏色
                        }
                    }
                }
                
                // 自訂標題
                ToolbarItem(placement: .principal) {
                    Text("New Post")
                        .font(.custom("LexendDeca-SemiBold", size: 20))
                        .foregroundColor(.white.opacity(1)) // 設定標題的顏色
                }
            }
        
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbarBackground(Color(.theme), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    // 獲取用戶名稱的方法
    func fetchUserName() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                userName = data?["displayName"] as? String ?? "匿名用戶"
            } else {
                print("User not found in Firestore")
            }
        }
    }

    // 上傳貼文到 Firestore 的邏輯
    func uploadPost(title: String, content: String, county: String, image: UIImage?) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        // 如果有選擇圖片，先上傳圖片到 Firebase Storage
        if let image = image {
            uploadImage(image) { imageURL in
                if let imageURL = imageURL {
                    // 將文章與圖片 URL 一起上傳到 Firestore
                    let postData: [String: Any] = [
                        "user_id": userId,  // 登入後真正id 可用
                        "user_name": userName,
                        "title": title,
                        "content": content,
                        "County": county,
                        "imageURL": imageURL.absoluteString, // 圖片的下載 URL
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "likedBy": [] // 新增的字段，用於存儲按讚使用者的 UID 列表
                        
                    ]
                    db.collection("articles").addDocument(data: postData) { error in
                        if let error = error {
                            print("Error uploading post: \(error.localizedDescription)")
                        } else {
                            print("Post successfully uploaded with image!")
                        }
                    }
                } else {
                    print("Failed to upload image")
                }
            }
        } else {
            // 如果沒有圖片，僅上傳文章數據
            let postData: [String: Any] = [
                "user_id": userId,
                "user_name": userName,
                "title": title,
                "content": content,
                "County": county,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "likedBy": []
            ]
            db.collection("articles").addDocument(data: postData) { error in
                if let error = error {
                    print("Error uploading post: \(error.localizedDescription)")
                } else {
                    print("Post successfully uploaded without image!")
                }
            }
        }
    }

    // 上傳圖片到 Firebase Storage 並獲取下載 URL
    func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                // 獲取圖片的下載 URL
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        completion(url) // 成功獲取圖片 URL
                    }
                }
            }
        } else {
            completion(nil) // 如果圖片轉換失敗
        }
    }    
}
#Preview {
    PostView()
}

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var _center: NotificationCenter
    
    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            withAnimation {
                currentHeight = keyboardFrame.height
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        withAnimation {
            currentHeight = 0
        }
    }
}
