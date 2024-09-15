//
//  ARview.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/12.
//

import SwiftUI
import RealityKit

struct ARview: View {
    
    @State private var session: ObjectCaptureSession?  // 控制圖像捕捉
    @State private var imageFolderPath: URL?
    @State private var photogrammetrySession: PhotogrammetrySession?
    @State private var modelFolderPath: URL?
    @State private var isProgressing = false
    @State private var quickLookIsPresented = false
    
    
    
    var modelPath: URL? {
        return modelFolderPath?.appending(path: "model.usdz")
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            if let session {
                
                ObjectCaptureView(session: session)   //3d捕捉的介面
                
                
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
                Color.black.opacity(0.4)
                    .overlay {
                        VStack {
                            ProgressView()
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
                session?.finish()
            }
        }
        .onChange(of: session?.state) { _, newValue in
            if newValue == .completed {
                session = nil
                
                Task {
                    await startReconstruction()
                }
            }
        }
        .sheet(isPresented: $quickLookIsPresented) {
            if let modelPath {
                ARQuickLookView(modelFile: modelPath) {
                    quickLookIsPresented = false
                    restartObjectCapture()  // Quick Look 預覽結束後重新開始捕捉
                }
            }
        }
    }
}

extension ARview {
    
    @MainActor func restartObjectCapture() {
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
    
    private func startReconstruction() async {
        guard let imageFolderPath, let modelPath else { return }
        isProgressing = true
        do {
            photogrammetrySession = try PhotogrammetrySession(input: imageFolderPath)
            try photogrammetrySession?.process(requests: [.modelFile(url: modelPath)])
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
}



