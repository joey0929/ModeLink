//
//  QuickLookDownloadView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/18.
//

import SwiftUI
import FirebaseStorage

struct QuickLookDownloadView: View {
    @State private var localModelURL: URL? = nil  // 本地模型 URL
    let firebaseModelPath: String                 // 傳入 Firebase 模型路徑
    let endCaptureCallback: () -> Void            // QuickLook 結束後的回調
    
    var body: some View {
        VStack {
            if let url = localModelURL {
                // 使用已經下載的本地文件進行 AR QuickLook 預覽
                ARQuickLookView(modelFile: url, endCaptureCallback: endCaptureCallback)
            } else {
                // 模型下載中
                Text("模型正在下載中...")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear {
            downloadModelFromFirebase()
        }
    }
    
    // 從 Firebase Storage 下載 3D 模型
    func downloadModelFromFirebase() {
        let storageRef = Storage.storage().reference(withPath: firebaseModelPath)
        
        // 創建一個臨時的本地文件路徑來保存下載的模型
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(storageRef.name)
        
        // 從 Firebase Storage 寫入本地文件
        storageRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("下載模型時出錯: \(error.localizedDescription)")
            } else if let url = url {
                print("模型下載到: \(url.path)")
                DispatchQueue.main.async {
                    // 設置本地文件 URL 以顯示模型
                    self.localModelURL = url
                }
            }
        }
    }
}


//#Preview {
//    QuickLookDownloadView()
//}
