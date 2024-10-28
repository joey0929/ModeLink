//
//  SavedModelPreviewView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/18.
//
import SwiftUI
import QuickLook
import FirebaseStorage
struct SavedModelPreviewView: View {
    let modelURL: URL  // 傳遞進來的模型 URL
    @Environment(\.presentationMode) var presentationMode  // 獲取 SwiftUI 的頁面控制環境
    @State private var localFileURL: URL?  // 下載後的本地文件 URL
    @State private var isDownloading = true  // 顯示是否在下載中
    @State private var downloadError: String?
    var body: some View {
           VStack {
               if isDownloading {
                   // 顯示模型下載中的進度指示器
                   ProgressView("模型下載中...")
                       .progressViewStyle(CircularProgressViewStyle())
                   Text("請稍候...")
               } else if let downloadError {
                   Text("下載錯誤: \(downloadError)")
                       .foregroundColor(.red)
                       .padding()
               } else if let localFileURL = localFileURL {
                   // 當模型下載完成後，顯示 ARView
                   ARModelViewContainer(modelURL: localFileURL, endCaptureCallback: {
                       self.presentationMode.wrappedValue.dismiss()
                   })
                       .edgesIgnoringSafeArea(.all)
               } else {
                   Text("無法加載模型")
                       .font(.title)
                       .padding()
               }
           }
           .onAppear {
               downloadModel(from: modelURL)
           }
       }
    // 從Firebase下載模型並保存到本地
    func downloadModel(from modelURL: URL) {
        let storageRef = Storage.storage().reference(forURL: modelURL.absoluteString)
        // 使用 Documents 目錄作為本地存儲目標
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsDirectory.appendingPathComponent(storageRef.name)
        storageRef.write(toFile: localURL) { url, error in
            if let error = error {
                print("Error downloading the model: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.downloadError = "下載失敗"
                    self.isDownloading = false
                }
            } else {
                print("Model downloaded to: \(localURL.path)")
                DispatchQueue.main.async {
                    self.localFileURL = localURL  // 將下載後的本地文件 URL 儲存
                    self.isDownloading = false
                }
            }
        }
    }
}
// 修改 ARModelViewContainer 來使用 QuickLook 替換 ARView
struct ARModelViewContainer: UIViewControllerRepresentable {
    let modelURL: URL  // 3D 模型文件的本地 URL
    let endCaptureCallback: () -> Void  // 頁面關閉後的回調
    // 創建 QuickLook 的 UIViewController
    func makeUIViewController(context: Context) -> QLPreviewControllerWrapper {
        let controller = QLPreviewControllerWrapper()
        controller.previewController.dataSource = context.coordinator
        controller.previewController.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: QLPreviewControllerWrapper, context: Context) {}
    // Coordinator 負責處理 QuickLook 的數據源和行為
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    class Coordinator: NSObject, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
        let parent: ARModelViewContainer
        init(parent: ARModelViewContainer) {
            self.parent = parent
        }
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelURL as QLPreviewItem
        }
        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            parent.endCaptureCallback()
        }
    }
    // 包裝 QLPreviewController 來用於 SwiftUI
    class QLPreviewControllerWrapper: UIViewController {
        let previewController = QLPreviewController()
        var quickLookIsPresented = false
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            // 在頁面第一次出現時展示 QuickLook
            if !quickLookIsPresented {
                present(previewController, animated: false)
                quickLookIsPresented = true
            }
        }
    }
}
