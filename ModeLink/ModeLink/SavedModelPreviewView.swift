//
//  SavedModelPreviewView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/18.
//

//import SwiftUI
//import QuickLook
//import Firebase
//
//struct SavedModelPreviewView: View {
//    @State var modelURL: URL?
//
//    var body: some View {
//        VStack {
//            if let modelURL {
//                ARQuickLookView(modelFile: modelURL) {
//                    // 可選擇邏輯
//                }
//            } else {
//                Text("正在加载模型...")
//                    .font(.title)
//                    .padding()
//            }
//        }
//        .onAppear {
//            loadModelFromFirebase()  // 加载模型 URL
//        }
//    }
//
//    func loadModelFromFirebase() {
//        let db = Firestore.firestore()
//        db.collection("3DModels").order(by: "timestamp", descending: true).limit(to: 1).getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching model URL: \(error.localizedDescription)")
//                return
//            }
//
//            if let document = snapshot?.documents.first, let modelURLString = document.data()["modelURL"] as? String, let url = URL(string: modelURLString) {
//                self.modelURL = url  // 更新
//            }
//        }
//    }
//}
//
//#Preview {
//    SavedModelPreviewView()
//}



//import SwiftUI
//import QuickLook
//import Firebase
//import FirebaseStorage
//
//struct SavedModelPreviewView: View {
//    @State var modelURL: URL?  // 本地文件的 URL
//    @State private var isDownloading = false  // 顯示是否在下載中
//
//    var body: some View {
//        VStack {
//            if let modelURL {
//              
//                ARQuickLookView(modelFile: modelURL) {
//                    // 當預覽結束時的回調
//                    print("預覽結束")
//                }
//            } else if isDownloading {
//                VStack {
//                    ProgressView("模型下載中...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                    Text("請稍候...")
//                }
//                .padding()
//            } else {
//                Text("無法加載模型")
//                    .font(.title)
//                    .padding()
//            }
//        }
//        .onAppear {
//            loadModelFromFirebase()
//        }
//    }
//
//    // 從 Firebase 加載並下載 3D 模型文件
//    func loadModelFromFirebase() {
//        let db = Firestore.firestore()
//        db.collection("3DModels").order(by: "timestamp", descending: true).limit(to: 1).getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching model URL: \(error.localizedDescription)")
//                return
//            }
//
//            if let document = snapshot?.documents.first, let modelURLString = document.data()["modelURL"] as? String {
//                // 下載文件並保存到本地
//                downloadModel(from: modelURLString) { localFileURL in
//                    if let localFileURL = localFileURL {
//                        // 確保 URL 是 file:// 開頭的本地文件 URL
//                        DispatchQueue.main.async {
//                            self.modelURL = localFileURL
//                            
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//
//    // Firebase Storage 下載並保存到本地的代碼示例
//    func downloadModel(from modelURLString: String, completion: @escaping (URL?) -> Void) {
//        let storageRef = Storage.storage().reference(forURL: modelURLString)
//        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(storageRef.name)
//
//        storageRef.write(toFile: localURL) { url, error in
//            if let error = error {
//                print("Error downloading the model: \(error.localizedDescription)")
//                completion(nil)
//            } else {
//                print("Model downloaded to: \(url?.path ?? "Unknown path")")
//                
//                // 確保文件是本地路徑（file://）
//                if let localPath = url?.path {
//                    let fileURL = URL(fileURLWithPath: localPath)
//                    print("fileURL: \(fileURL)")
//                    completion(fileURL)  // 回傳正確的本地文件 URL
//                } else {
//                    completion(nil)
//                }
//            }
//        }
//    }
//    
//}


//import SwiftUI
//import RealityKit
//import ARKit
//import Firebase
//import FirebaseStorage
//
//struct SavedModelPreviewView: View {
//    @State var modelURL: URL?  // 本地文件的 URL
//    @State private var isDownloading = false  // 顯示是否在下載中
//
//    var body: some View {
//        VStack {
//            if let modelURL {
//                ARModelViewContainer(modelURL: modelURL)
//                    .edgesIgnoringSafeArea(.all)
//            } else if isDownloading {
//                VStack {
//                    ProgressView("模型下載中...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                    Text("請稍候...")
//                }
//                .padding()
//            } else {
//                Text("無法加載模型")
//                    .font(.title)
//                    .padding()
//            }
//        }
//        .onAppear {
//            loadModelFromFirebase()
//        }
//    }
//
//    // 從 Firebase 加載並下載 3D 模型文件
//    func loadModelFromFirebase() {
//        let db = Firestore.firestore()
//        db.collection("3DModels").order(by: "timestamp", descending: true).limit(to: 1).getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching model URL: \(error.localizedDescription)")
//                return
//            }
//
//            if let document = snapshot?.documents.first, let modelURLString = document.data()["modelURL"] as? String {
//                // 下載文件並保存到本地
//                downloadModel(from: modelURLString) { localFileURL in
//                    if let localFileURL = localFileURL {
//                        // 確保 URL 是 file:// 開頭的本地文件 URL
//                        DispatchQueue.main.async {
//                            self.modelURL = localFileURL
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    // Firebase Storage 下載並保存到本地的代碼示例
//    func downloadModel(from modelURLString: String, completion: @escaping (URL?) -> Void) {
//        let storageRef = Storage.storage().reference(forURL: modelURLString)
//        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(storageRef.name)
//
//        storageRef.write(toFile: localURL) { url, error in
//            if let error = error {
//                print("Error downloading the model: \(error.localizedDescription)")
//                completion(nil)
//            } else {
//                print("Model downloaded to: \(url?.path ?? "Unknown path")")
//                
//                // 確保文件是本地路徑（file://）
//                if let localPath = url?.path {
//                    let fileURL = URL(fileURLWithPath: localPath)
//                    print("fileURL: \(fileURL)")
//                    completion(fileURL)  // 回傳正確的本地文件 URL
//                } else {
//                    completion(nil)
//                }
//            }
//        }
//    }
//}
//
//struct ARModelViewContainer: UIViewRepresentable {
//    let modelURL: URL
//
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        // 配置 ARSession
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal]  // 支持平面檢測
//        arView.session.run(config)
//
//        // 加載模型
//        loadModel(into: arView)
//
//        return arView
//    }
//
//    func updateUIView(_ uiView: ARView, context: Context) {}
//
//    private func loadModel(into arView: ARView) {
//        do {
//            let modelEntity = try ModelEntity.loadModel(contentsOf: modelURL)  // 加載本地 URL 中的模型
//            let anchorEntity = AnchorEntity(plane: .horizontal)  // 創建水平平面的錨點
//            anchorEntity.addChild(modelEntity)  // 將模型添加到錨點
//            arView.scene.addAnchor(anchorEntity)  // 將錨點添加到 ARView 的場景中
//        } catch {
//            print("Failed to load model: \(error.localizedDescription)")
//        }
//    }
//}
















//// MARK: - It can work but have bugs
//import SwiftUI
//import QuickLook
//import Firebase
//import FirebaseStorage
//import UniformTypeIdentifiers
//
//struct SavedModelPreviewView: View {
//    @State var modelURL: URL?
//    @State private var isDownloading = false
//    @State private var errorMessage: String?
//    @State private var showQLPreview = false
//
//    var body: some View {
//        VStack {
//            if let modelURL = modelURL {
//                Button("預覽 3D 模型") {
//                    showQLPreview = true
//                }
//                .sheet(isPresented: $showQLPreview) {
//                    QuickLookPreview(url: modelURL)
//                }
//            } else if isDownloading {
//                ProgressView("模型下載中...")
//                    .progressViewStyle(CircularProgressViewStyle())
//                Text("請稍候...")
//            } else if let error = errorMessage {
//                Text(error)
//                    .foregroundColor(.red)
//            } else {
//                Text("準備加載模型...")
//            }
//        }
//        .padding()
//        .onAppear {
//            loadModelFromFirebase()
//        }
//    }
//
//    func loadModelFromFirebase() {
//        isDownloading = true
//        errorMessage = nil
//        
//        let db = Firestore.firestore()
//        db.collection("3DModels").order(by: "timestamp", descending: true).limit(to: 1).getDocuments { snapshot, error in
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "錯誤：\(error.localizedDescription)"
//                    self.isDownloading = false
//                }
//                return
//            }
//
//            guard let document = snapshot?.documents.first,
//                  let modelURLString = document.data()["modelURL"] as? String else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "無法找到模型 URL"
//                    self.isDownloading = false
//                }
//                return
//            }
//
//            self.downloadModel(from: modelURLString) { localFileURL in
//                DispatchQueue.main.async {
//                    if let localFileURL = localFileURL {
//                        self.modelURL = localFileURL
//                        self.isDownloading = false
//                    } else {
//                        self.errorMessage = "下載模型失敗"
//                        self.isDownloading = false
//                    }
//                }
//            }
//        }
//    }
//
//    func downloadModel(from modelURLString: String, completion: @escaping (URL?) -> Void) {
//        guard let modelURL = URL(string: modelURLString) else {
//            print("Invalid URL string: \(modelURLString)")
//            completion(nil)
//            return
//        }
//
//        let storageRef = Storage.storage().reference(forURL: modelURL.absoluteString)
//        
//        // 使用臨時目錄來存儲下載的文件
//        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".usdz")
//
//        storageRef.write(toFile: localURL) { url, error in
//            if let error = error {
//                print("Error downloading the model: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//
//            guard let localURL = url else {
//                print("Failed to get local URL after download")
//                completion(nil)
//                return
//            }
//
//            print("Model downloaded to: \(localURL.path)")
//
//            // 設置正確的文件類型
//            do {
//                try (localURL as NSURL).setResourceValue(UTType.usdz.identifier, forKey: .typeIdentifierKey)
//            } catch {
//                print("Error setting file type: \(error)")
//            }
//
//            completion(localURL)
//        }
//    }
//}
//
//struct QuickLookPreview: UIViewControllerRepresentable {
//    let url: URL
//
//    func makeUIViewController(context: Context) -> QLPreviewController {
//        let controller = QLPreviewController()
//        controller.dataSource = context.coordinator
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, QLPreviewControllerDataSource {
//        let parent: QuickLookPreview
//
//        init(_ parent: QuickLookPreview) {
//            self.parent = parent
//        }
//
//        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//            return 1
//        }
//
//        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//            return parent.url as QLPreviewItem
//        }
//    }
//}


import SwiftUI
import RealityKit
import Firebase
import FirebaseStorage
import ARKit

struct SavedModelPreviewView: View {
    @State var modelURL: URL?  // 本地文件的 URL
    @State private var isDownloading = false  // 顯示是否在下載中
    @State private var downloadError: String?

    var body: some View {
        VStack {
            if let modelURL {
                ARModelViewContainer(modelURL: modelURL)
                    .edgesIgnoringSafeArea(.all)
            } else if isDownloading {
                VStack {
                    ProgressView("模型下載中...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("請稍候...")
                }
                .padding()
            } else if let downloadError {
                Text("下載錯誤: \(downloadError)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("無法加載模型")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear {
            loadModelFromFirebase()
        }
    }

    // 從 Firebase 加載並下載 3D 模型文件
    func loadModelFromFirebase() {
        isDownloading = true
        let db = Firestore.firestore()
        db.collection("3DModels").order(by: "timestamp", descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching model URL: \(error.localizedDescription)")
                self.downloadError = "無法獲取模型 URL"
                self.isDownloading = false
                return
            }

            if let document = snapshot?.documents.first, let modelURLString = document.data()["modelURL"] as? String {
                // 下載文件並保存到本地
                downloadModel(from: modelURLString) { localFileURL in
                    if let localFileURL = localFileURL {
                        DispatchQueue.main.async {
                            self.modelURL = localFileURL
                            self.isDownloading = false
                        }
                    } else {
                        self.downloadError = "下載失敗"
                        self.isDownloading = false
                    }
                }
            } else {
                self.downloadError = "無法找到模型"
                self.isDownloading = false
            }
        }
    }

    // Firebase Storage 下載並保存到 Documents 目錄的代碼示例
    func downloadModel(from modelURLString: String, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: modelURLString)
        
        // 使用 Documents 目錄作為本地存儲目標
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsDirectory.appendingPathComponent(storageRef.name)

        storageRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("Error downloading the model: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("Model downloaded to: \(localURL.path)")
                completion(localURL)  // 返回本地文件 URL
            }
        }
    }
}

struct ARModelViewContainer: UIViewRepresentable {
    let modelURL: URL

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // 配置 ARSession
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)

        // 加載模型
        loadModel(into: arView)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    private func loadModel(into arView: ARView) {
        do {
            let modelEntity = try ModelEntity.loadModel(contentsOf: modelURL)
            let anchorEntity = AnchorEntity(plane: .horizontal)
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)
        } catch {
            print("Failed to load model: \(error.localizedDescription)")
        }
    }
}
