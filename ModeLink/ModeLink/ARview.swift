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
import PhotosUI
import ARKit

struct ARview: View {
    @State private var session: ObjectCaptureSession?  // 控制圖像捕捉
    @State private var imageFolderPath : URL?           //保存捕捉過程中的圖像
    @State private var modelFolderPath : URL?           // 保存生成的3D模型
    @State private var photogrammetrySession : PhotogrammetrySession?  //處理圖像和生成3D模型
    @State private var isProgressing = false  //控制捕捉時的預覽圖
    @State private var quickLookIsPresented = false
    @State private var scanPassCount = 0  // 控制掃描次數
    @State private var showContinueScanAlert = false  // 是否繼續掃描提示
    @State private var showNameInputSheet = false  // 控制是否顯示名稱輸入的 sheet
    @State private var inputModelName = ""  // 儲存用戶輸入的模型名稱
    
    @State private var selectedCategory = "模型"  // 新增種類屬性
    let categories = ["模型", "公仔", "其他"]  // 三個選項
    
    //增加選取上傳照片
    @State private var selectedImage: UIImage? = nil // 選取的圖片
    @State private var selectedItem: PhotosPickerItem? = nil // PhotosPicker 選取的項目
    
    var modelPath: URL? {
        return modelFolderPath?.appending(path: "model.usdz")
    }
    
    var isLiDARAvailable: Bool {
        return ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
    }
    
    var body: some View {
        
        Group {
            if isLiDARAvailable {
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
                        Color.black.opacity(0.2) // 背景變得更亮
                            .edgesIgnoringSafeArea(.all)  // 確保背景覆蓋整個螢幕
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
                    //            ZStack{
                    //                VStack{
                    //                    Spacer()
                    //                    //Rectangle().background(.clear).frame(height: 100)
                    //                }
                    //                Color.gray.opacity(0.8).frame(height: 50).padding(.top,800)
                    //            }
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(height: 80)  // 設定高度以覆蓋 TabBar 的位置
                        .edgesIgnoringSafeArea(.bottom)  // 確保覆蓋整個底部
                        .padding(.bottom, -100)
                }
            }
            //        .task {
            //            guard let directory = createNewScanDirectory() else { return }
            //            session = ObjectCaptureSession()
            //            modelFolderPath = directory.appending(path: "Models/")
            //            imageFolderPath = directory.appending(path: "Images/")
            //            guard let imageFolderPath else { return }
            //            session?.start(imagesDirectory: imageFolderPath)
            //        }
        }
        .task {
            guard isLiDARAvailable else {
                print("不支援AR掃描")
                return
            }
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
        // MARK: - Input Filename Setting
        .sheet(isPresented: $showNameInputSheet) {
            VStack {
                Text("輸入模型名稱")
                    .font(.headline)
                    .padding()
                TextField("輸入名稱", text: $inputModelName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Picker 選擇種類
                Picker("選擇種類", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                
                // 添加 HStack 包含照片選擇器和預覽圖片
                HStack {
                    PhotosPicker(selection: $selectedItem, matching: .images) { // 添加 PhotosPicker
                        Text("選擇圖片")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .onChange(of: selectedItem) { newItem in
                        if let newItem = newItem {
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }
                    }
                    // 顯示選擇的圖片的預覽
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50) // 設定預覽圖片的大小
                            .clipShape(RoundedRectangle(cornerRadius: 8)) // 圓角圖片
                            .padding(.leading)
                    }
                }
                Button("保存") {
                    guard !inputModelName.isEmpty else { return }
                    showNameInputSheet = false  // 關閉輸入框
                    print("==Model name entered: \(inputModelName)")
                    // 使用 DispatchQueue 確保上傳操作不會阻塞 UI
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { }
                    // 上傳文件並在完成後清空輸入框
                    uploadModelToFirebase {
                        scanPassCount = 0
                        inputModelName = ""
                        // test
                        selectedImage = nil // 清空剛剛選擇的圖片
                        selectedItem = nil // 清空剛剛選擇的 PhotosPickerItem
                        restartObjectCapture()  // 確保在上傳成功後再重新開始捕捉
                    }
                    print("==== Already upload the usdz File!!!!======")
//                    }
                }
                .padding()

                Button("取消") {
                    showNameInputSheet = false  // 關閉輸入框
                    scanPassCount = 0
                    inputModelName = ""
                    restartObjectCapture()  // 確保在上傳成功後再重新開始捕捉
                }
                .padding()
            }
            .padding()
        }
        .sheet(isPresented: $quickLookIsPresented) {
            if let modelPath {
                ARQuickLookView(modelFile: modelPath) {    //use trailing closure
                    quickLookIsPresented = false
                    showNameInputSheet = true  // 顯示名稱輸入 sheet
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
    @MainActor func restartObjectCapture() {   //重新啟用掃描的function
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
                default:
                    break
                }
            }
        } catch {
            print("error", error)
        }
    }
    // MARK: - 上傳到 Firebase Storage 再存儲 URL 到 Firestore
    func uploadModelToFirebase(completion: @escaping () -> Void) {
        guard let modelPath = modelFolderPath?.appending(path: "model.usdz") else {
            print("Error: Model path not found.")
            return
        }
        // 檢查模型文件是否存在並且可以讀取
        do {
            let modelData = try Data(contentsOf: modelPath)
            print("Model data size: \(modelData.count) bytes")  // 打印模型文件大小
            // 使用 UUID 生成 Storage 路徑和模型名稱
            let uniqueID = UUID().uuidString
            let storageRef = Storage.storage().reference().child("3DModels/\(uniqueID).usdz")
            print("Starting upload to Firebase Storage...")
            // 上傳模型文件到 Firebase Storage
            let uploadTask = storageRef.putData(modelData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading model: \(error.localizedDescription)")
                    return
                }
                print("Model uploaded to Firebase Storage, fetching download URL...")
                // 獲取下載 URL
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else if let downloadURL = url {
                        print("Model uploaded successfully to Firebase Storage: \(downloadURL.absoluteString)")
                        // 使用用戶輸入的名稱來保存到 Firestore
//                        saveDownloadURLToFirestore(downloadURL, name: inputModelName)
//                        // 在成功上傳後執行閉包
//                        completion()
                        
                        uploadImageToFirebase { imageURL in
                            // 使用用戶輸入的名稱來保存到 Firestore
                            saveDownloadURLToFirestore(modelURL: downloadURL, imageURL: imageURL, name: inputModelName, category: selectedCategory)
                            
                            // 在成功上傳後執行閉包
                            completion()
                        }
      
                    }
                }
            }
            uploadTask.observe(.progress) { snapshot in
                let percentComplete = 100.0 * Double(snapshot.progress?.completedUnitCount ?? 0) / Double(snapshot.progress?.totalUnitCount ?? 0)
                print("Upload is \(percentComplete)% complete")
            }
        } catch {
            print("Error reading model data: \(error.localizedDescription)")
        }
    }
    // 將下載 URL 儲存到 Firestore
//    func saveDownloadURLToFirestore(_ downloadURL: URL,name: String) {
//        let db = Firestore.firestore()
//        let modelData: [String: Any] = [
//            "modelURL": downloadURL.absoluteString,
//            "name": name,  // 使用與 Storage 同樣的 UUID 作為名稱
//            "timestamp": Timestamp(date: Date())
//        ]
//        db.collection("3DModels").addDocument(data: modelData) { error in
//            if let error = error {
//                print("Error saving model URL to Firestore: \(error.localizedDescription)")
//            } else {
//                print("Model URL saved to Firestore!")
//            }
//        }
//    }
    
    // 上傳圖片到 Firebase Storage
    func uploadImageToFirebase(completion: @escaping (URL?) -> Void) {
        guard let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            print("Error: No image selected.")
            completion(nil)
            return
        }

       // let uniqueID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL for image: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    print("Image uploaded successfully to Firebase Storage: \(url?.absoluteString ?? "")")
                    completion(url)
                }
            }
        }
    }

    // 將模型和圖片的下載 URL 儲存到 Firestore
    func saveDownloadURLToFirestore(modelURL: URL, imageURL: URL?, name: String,category: String) {
        let db = Firestore.firestore()
        let modelData: [String: Any] = [
            "modelURL": modelURL.absoluteString,
            "imageURL": imageURL?.absoluteString ?? "", // 保存圖片 URL
            "name": name,
            "category": category,  // 保存選擇的種類
            "timestamp": Timestamp(date: Date())
        ]
        db.collection("3DModels").addDocument(data: modelData) { error in
            if let error = error {
                print("Error saving model URL to Firestore: \(error.localizedDescription)")
            } else {
                print("Model URL and Image URL saved to Firestore!")
            }
        }
    }
    
}
