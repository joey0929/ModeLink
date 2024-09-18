//
//  ARview.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/12.
//

import SwiftUI
import RealityKit
import Firebase
import FirebaseStorage


struct ARview: View {
    
    @State private var session: ObjectCaptureSession?  // 控制圖像捕捉
    @State private var imageFolderPath: URL?           //保存捕捉過程中的圖像
    @State private var modelFolderPath: URL?           // 保存生成的3D模型
    @State private var photogrammetrySession: PhotogrammetrySession?  //處理圖像和生成3D模型
    @State private var isProgressing = false  //控制捕捉時的預覽圖
    @State private var quickLookIsPresented = false
    @State private var scanPassCount = 0  // 控制掃描次數
    @State private var showContinueScanAlert = false  // 是否繼續掃描提示
    
    var modelPath: URL? {
        return modelFolderPath?.appending(path: "model.usdz")
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            if let session {
                ObjectCaptureView(session: session)   // AR 相機介面
                
                VStack(spacing: 16) {
                    if session.state == .ready || session.state == .detecting {
                        CreateButton(session: session) // 偵測和捕捉按鈕
                    }
                    
                    HStack {
                        Text(session.state.label)
                            .bold()
                            .foregroundStyle(.yellow)
                            .padding(.bottom)
                    }
                }
            }
            
            if isProgressing {
//                Color.black.opacity(0.2)
//                    .overlay {
//                        VStack {
//                            ProgressView()
//                            Text("生成模型中請耐心等候～～～根據掃描次數會有不同等待時間")
//                        }
//                    }
                Color.black.opacity(0.2) // 背景變得更亮
                    .edgesIgnoringSafeArea(.all)  // 確保背景覆蓋整個屏幕
                    .overlay {
                        VStack(spacing: 20) {  // 增加內部元素間距
                            // 自定義的圓角卡片
                            VStack(spacing: 16) {
                                ProgressView()  // 進度條
                                    .scaleEffect(1.5)  // 讓進度條更大些
                                    .padding(.top, 20)
                                
                                Text("生成模型中，請耐心等候...")
                                    .font(.headline)
                                    .foregroundColor(.primary)  // 讓文字更清晰
                                Text("並請不要切換頁面！！！！！")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("根據掃描次數，等待時間會有所不同")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)  // 輔助文本
                            
                            }
                            .frame(width: 300)  // 控制卡片寬度
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)  // 使用白色背景
                                    .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)  // 添加陰影
                            )
                        }
                    }
            }
            
        }
        .task {
            guard let directory = createNewScanDirectory() else { return }
            session = ObjectCaptureSession()
            
            modelFolderPath = directory.appending(path: "Models/")
            imageFolderPath = directory.appending(path: "Images/")
            guard let imageFolderPath else { return }
            session?.start(imagesDirectory: imageFolderPath)
        }
        .onChange(of: session?.userCompletedScanPass) { _, newValue in
            if let newValue, newValue {
                scanPassCount += 1  // 每次完成掃描後增加計數
                
                // 如果已達到三次掃描，提示生成模型
                if scanPassCount >= 3 {
                    showContinueScanAlert = true  // 顯示警告，並給用戶選擇是否完成
                } else {
                    // 提示是否繼續掃描
                    showContinueScanAlert = true
                }
            }
        }
        .onChange(of: session?.state) { _, newValue in
            if newValue == .completed {  // 如果已經到complete的狀態後 ， 就可以進行3D視圖的重建
                session = nil
                
                Task {
                    await startReconstruction()
                }
            }
        }
        .sheet(isPresented: $quickLookIsPresented) {
            if let modelPath {
                ARQuickLookView(modelFile: modelPath) {    //use trailing closure
                    quickLookIsPresented = false
                    restartObjectCapture()  // Quick Look 預覽結束後重新開始捕捉
                }
                
                // or 這種寫法
//                ARQuickLookView(modelFile: modelPath, endCaptureCallback: {
//                    quickLookIsPresented = false
//                    restartObjectCapture()
//                })
                
                
            }
        }
        //MARK: - Alert Setting
        .alert(isPresented: $showContinueScanAlert) {
            Alert(
                title: Text("繼續掃描"),
                message: Text("是否要進行第 \(scanPassCount + 1) 次掃描？建議進行三次掃描以獲得更好看模型～～！"),
                primaryButton: .default(Text("continue"), action: {
                    session?.beginNewScanPass() // 繼續下一次不翻向的掃描，不直接結束掃描狀態
                }),
                secondaryButton: .cancel(Text("Finish"), action: {
                    session?.finish()  // 用戶選擇結束，這時才完成捕捉會話
                    Task {
                        await startReconstruction()  // 開始生成 3D 模型
                    }
                })
            )
        }
        
    }
}

extension ARview {
    //MARK: - Restart Function Setting
    @MainActor func restartObjectCapture() {   //重新啟用掃描的
        guard let directory = createNewScanDirectory() else { return }
        session = ObjectCaptureSession()

        modelFolderPath = directory.appending(path: "Models/")
        imageFolderPath = directory.appending(path: "Images/")
        guard let imageFolderPath else { return }
        session?.start(imagesDirectory: imageFolderPath)
    }
    
    func createNewScanDirectory() -> URL? {
        guard let capturesFolder = getRootScansFolder() else { return nil }
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let newCaptureDirectory = capturesFolder.appendingPathComponent(timestamp, isDirectory: true)
        do {
            try FileManager.default.createDirectory(atPath: newCaptureDirectory.path,
                                                    withIntermediateDirectories: true)
        } catch {
            print("Failed to create capture path")
        }
        return newCaptureDirectory
    }
    
    private func getRootScansFolder() -> URL? {
        guard let documentFolder = try? FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false) else { return nil }
        return documentFolder.appendingPathComponent("Scans/", isDirectory: true)
    }
    
    // MARK: - Construct 3D View Setting
    private func startReconstruction() async {
        guard let imageFolderPath, let modelPath else { return }
        isProgressing = true
        do {
            photogrammetrySession = try PhotogrammetrySession(input: imageFolderPath) //creation of a 3D model from a set of images
            try photogrammetrySession?.process(requests: [.modelFile(url: modelPath)]) //生成 USDZ 模型並存放在 modelPath
            for try await output in photogrammetrySession!.outputs {
                switch output {
                case .processingComplete:
                    isProgressing = false
                    quickLookIsPresented = true
                    uploadModelToFirebase() // 在模型處理完成後上傳到 Firebase
                default:
                    break
                }
            }
        } catch {
            print("error", error)
        }
    }
      
    
    // MARK: - 上傳到 Firebase Storage 並存儲 URL 到 Firestore
    func uploadModelToFirebase() {
        guard let modelPath = modelFolderPath?.appending(path: "model.usdz") else { return }
        
        // 使用 UUID 生成 Storage 路徑和模型名稱
        let uniqueID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("3DModels/\(uniqueID).usdz")
        
        if let modelData = try? Data(contentsOf: modelPath) {
            let uploadTask = storageRef.putData(modelData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading model: \(error.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else if let downloadURL = url {
                        print("Model uploaded successfully: \(downloadURL.absoluteString)")
                        
                        saveDownloadURLToFirestore(downloadURL,name: uniqueID)
                    }
                }
            }
        }
    }
    // 將下載 URL 儲存到 Firestore
    func saveDownloadURLToFirestore(_ downloadURL: URL,name: String) {
        let db = Firestore.firestore()
        let modelData: [String: Any] = [
            "modelURL": downloadURL.absoluteString,
            "name": name,  // 使用與 Storage 同樣的 UUID 作為名稱
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("3DModels").addDocument(data: modelData) { error in
            if let error = error {
                print("Error saving model URL to Firestore: \(error.localizedDescription)")
            } else {
                print("Model URL saved to Firestore!")
            }
        }
    }
}
