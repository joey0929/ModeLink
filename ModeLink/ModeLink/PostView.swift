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




//struct PostView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var title = ""
//    @State private var wcontry = ""
//    @State private var content = ""
//    
//    var body: some View {
//        
//        
//        ScrollView {
//            
//            
//            
//            VStack {
//                TextField("標題", text: $title)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                TextField("縣市", text: $wcontry)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                
//                TextEditor(text: $content)
//                    .frame(height: 200)
//                    .border(Color.gray, width: 1)
//                    .padding()
//                
//                Button(action: {
//                    // 這裡可以添加貼文的提交邏輯
//                    presentationMode.wrappedValue.dismiss()
//                }) {
//                    Text("提交")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//                .padding()
//                
//                Spacer()
//            }
//            .navigationTitle("新貼文")
//            .padding()
//        }
//        
//        
//        
//    }
//}

struct PostView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var content = ""
    @State private var wcontry = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack {
                TextField("標題", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("縣市", text: $wcontry)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                TextEditor(text: $content)
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                    .padding()
                
                // 顯示選擇的圖片
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                }
                // 按鈕來選擇圖片
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    Text("選擇圖片")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                Button(action: {
                    //uploadPost()
                    uploadPost(title: title, content: content, wcontry: wcontry, image: selectedImage)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("提交")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                Spacer()
            }
        }
        .navigationTitle("新貼文")
        .padding()
    }
    // 上傳貼文到 Firestore 的邏輯
    func uploadPost(title: String, content: String, wcontry: String, image: UIImage?) {
        let db = Firestore.firestore()
        // 如果有選擇圖片，先上傳圖片到 Firebase Storage
        if let image = image {
            uploadImage(image) { imageURL in
                if let imageURL = imageURL {
                    // 將文章數據與圖片 URL 一起上傳到 Firestore
                    let postData: [String: Any] = [
                        "title": title,
                        "content": content,
                        "wcontry": wcontry,
                        "imageURL": imageURL.absoluteString, // 圖片的下載 URL
                        "timestamp": Timestamp(date: Date())
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
                "title": title,
                "content": content,
                "wcontry": wcontry,
                "timestamp": Timestamp(date: Date())
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
    func uploadTestPost() {
        
    }
    
}
#Preview {
    PostView()
}
