//
//  UploadDataView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/20.
//
import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct UploadDataView: View {
    
    @State var imageURL2: URL? = nil
    
    var body: some View {
        VStack {
            if let url = imageURL2 {
                Text("圖片已取得")
                Button("上傳資料到 Firestore") {
                    //uploadDataToFirestore(imageURL: url)
                }
            } else {
                Text("正在載入圖片...")
            }
            Spacer()
            Button("Upload to skill") {
                uploadDataToFirestore2()
            }
            Spacer()
        }
        .onAppear {
           // loadImageFromFirebase()
        }
    }
    
    // 從 Firebase Storage 取得圖片的下載 URL
    func loadImageFromFirebase() {
        let storageRef = Storage.storage().reference(withPath: "infoImages/IMG_0345.jpg")
        
        // 獲取下載 URL
        storageRef.downloadURL { url, error in
            if let error = error {
                print("獲取圖片 URL 時出錯：\(error.localizedDescription)")
                return
            }
            if let url = url {
                self.imageURL2 = url  // 成功獲取 URL，設置為狀態變量
            }
        }
        
    }
    
    // 將資料和圖片 URL 一同上傳到 Firestore
    func uploadDataToFirestore(imageURL: URL) {
        let db = Firestore.firestore()
        
        // 上傳的資料
        let toolData: [String: Any] = [
            "name": "筆刀",
            "price": "400 ~ 1500",
            "recommend": "田宮、MADWORKS",
            "description": "處理湯口",
            "image_url": imageURL.absoluteString,
            // 將 URL 轉換為字串並存入Firestore
            "position": 3
        ]
        
        // 將資料存入 Firestore 的 "toolDatas" collection
        db.collection("toolDatas").addDocument(data: toolData) { error in
            if let error = error {
                print("上傳資料時發生錯誤：\(error.localizedDescription)")
            } else {
                print("資料成功上傳到 Firestore！")
            }
        }
    }
    
    func uploadDataToFirestore2() {
        let db = Firestore.firestore()
        
        // 上傳的資料
        let skillData: [String: Any] = [
            "name": "上保護漆",
            "description": "在貼完水貼與上完墨線後，可以用噴灌為模型上一層保護漆，可以有效防止水貼或漆料經時間久了而脫落與可以有效消除塑膠的，呈現出的模型會更為自然",
            "image_url": "",
            "position": 5
        ]
        
        // 將資料存入 Firestore 的 "toolDatas" collection
        db.collection("skillDatas").addDocument(data: skillData) { error in
            if let error = error {
                print("上傳資料時發生錯誤：\(error.localizedDescription)")
            } else {
                print("資料成功上傳到 Firestore！")
            }
        }
    }
    
    
    
}

#Preview {
    UploadDataView()
}
