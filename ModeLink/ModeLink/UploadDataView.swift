//
//  UploadDataView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/20.
//
import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import MapKit
// 定義 LocationItem 來表示每個地點的資料
struct LocationItem2: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
}
struct UploadDataView: View {
    @State var imageURL2: URL? = nil
    var locations: [LocationItem] = [
        LocationItem(id: "玩具e哥(板橋新埔店)", coordinate: CLLocationCoordinate2D(latitude: 25.023378, longitude: 121.468812)),
        LocationItem(id: "玩具e哥（家福重新店）", coordinate: CLLocationCoordinate2D(latitude: 25.043240, longitude: 121.467328))
    ]
    var body: some View {
        VStack {
            if let url = imageURL2 {
                Text("圖片已取得")
                Button("上傳資料到 Firestore") {
                    //uploadDataToFirestore(imageURL: url)
                    print(imageURL2)
                }
            } else {
                Text("正在載入圖片...")
            }
            Spacer()
            Button("Upload to skill") {
                //uploadDataToFirestore2()
            }
            Spacer()
            Button("Upload to locations") {
                //uploadLocationsToFirebase()
            }
            Spacer()
            Button("Upload to tools2") {
                //uploadLocationsToFirebase()
                uploadDataToFirestore3()
            }
            Spacer()
        }
        .onAppear {
           // loadImageFromFirebase()
        }
    }
    // 上傳 locations 到 Firestore
    func uploadLocationsToFirebase() {
        let db = Firestore.firestore()
        for location in locations {
            let data: [String: Any] = [
                "id": location.id,
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude
            ]
            // 上傳每個位置資料到 Firestore 的 "locations" collection
            db.collection("locations").addDocument(data: data) { error in
                if let error = error {
                    print("Error uploading location: \(error.localizedDescription)")
                } else {
                    print("Location uploaded successfully!")
                }
            }
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
            "image_url": imageURL.absoluteString, // 將 URL 轉換為字串並存入Firestore
            "position": 3
        ]
        // 將資料存入 Firestore 的 "toolDatas" collection
        db.collection("toolDatas2").addDocument(data: toolData) { error in
            if let error = error {
                print("上傳資料時發生錯誤：\(error.localizedDescription)")
            } else {
                print("資料成功上傳到 Firestore！")
            }
        }
    }
    // 將資料和圖片 URL 一同上傳到 Firestore
    func uploadDataToFirestore3() {
        let db = Firestore.firestore()
        // 上傳的資料
        let toolData: [String: Any] = [
            "name": "保護漆",
            "price": "120~300",
            "recommend": "郡氏",
            "description": "增加表面特徵",
            "image_url": "", // 將 URL 轉換為字串並存入Firestore
            "position": 1
        ]
        // 將資料存入 Firestore 的 "toolDatas" collection
        db.collection("toolDatas2").addDocument(data: toolData) { error in
            if let error = error {
                print("上傳資料時發生錯誤：\(error.localizedDescription)")
            } else {
                print("資料成功上傳到 Firestore！")
            }
        }
    }
    func uploadDataToFirestore2() {
        let db = Firestore.firestore()
        let skillData: [String: Any] = [  // 上傳的資料
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
