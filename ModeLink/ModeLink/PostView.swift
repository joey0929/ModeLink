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

struct PostView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var userName: String = "" // 用於儲存用戶名稱
    @State private var title = ""
    @State private var content = ""
    @State private var county = "" // 所在縣市
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil // 用於存儲選擇的圖片
    @State private var isImagePickerPresented = false
    var canSubmit: Bool {
        // 當所有欄位都有填寫時返回 true，否則返回 false
        return !title.isEmpty && !content.isEmpty && !county.isEmpty
    }

    var body: some View {
        //  swiftlint:disable trailing_whitespace
        ScrollView(showsIndicators: false) {
            
            VStack {
                
                //Text("你好\(userName)")
                
                TextField("標題", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("縣市", text: $county)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                VStack(alignment:.leading) {
                    Text("請輸入內文:").padding(.leading,15)
                    TextEditor(text: $content)
                        .frame(height: 200)
                        .border(Color.gray, width: 1)
                        .padding()
                }
                // 顯示選擇的圖片
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                }
//                // 按鈕來選擇圖片
//                Button(action: {
//                    isImagePickerPresented.toggle()
//                }) {
//                    Text("選擇圖片")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//                .padding()
//                .sheet(isPresented: $isImagePickerPresented) {
//                    ImagePicker(selectedImage: $selectedImage)
//                }
                // 使用 PhotosPicker 來選擇圖片
                HStack {
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Text("選擇圖片")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(10)
                    }
                    .onChange(of: selectedItem) { newItem in
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
                    
                    Button(action: {
                        //uploadPost()
                        uploadPost(title: title, content: content, county: county, image: selectedImage)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("提交")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(canSubmit ? Color.blue : Color.gray) // 根據狀態變色
                            .cornerRadius(10)
                    }
                    .disabled(!canSubmit)
                    .padding()

                }
                Spacer()
            }
            .onAppear() {
                fetchUserName()
            }
        }
        .navigationTitle("新貼文")
        .padding()
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
                userName = data?["displayName"] as? String ?? "Unknown"
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
                    // 將文章數據與圖片 URL 一起上傳到 Firestore
                    let postData: [String: Any] = [
                        "user_id": userId,  // 登入後真正id 可用
                        "user_name": userName,
                        "title": title,
                        "content": content,
                        "County": county,
                        "imageURL": imageURL.absoluteString, // 圖片的下載 URL
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0
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
                "name": userName,
                "title": title,
                "content": content,
                "County": county,
                "timestamp": Timestamp(date: Date()),
                "likes": 0
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
