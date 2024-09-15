//
//  ARQuickLookView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/15.
//

import SwiftUI
import QuickLook
    
struct ARQuickLookView: UIViewControllerRepresentable {
    
    let modelFile: URL
    let endCaptureCallback: () -> Void
    
    func makeUIViewController(context: Context) -> QLPreviewControllerWrapper {
        let controller = QLPreviewControllerWrapper()
        controller.previewController.dataSource = context.coordinator
        controller.previewController.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QLPreviewControllerWrapper, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
        let parent: ARQuickLookView
        
        init(parent: ARQuickLookView) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {  //要顯示多少個文件，這裡只顯示一個 3D 模型
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.modelFile as QLPreviewItem
        }
        
        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            parent.endCaptureCallback()  // 關閉此頁面時，會調用此閉包的function
        }
    }
}

extension ARQuickLookView {
    
    class QLPreviewControllerWrapper: UIViewController {
        let previewController = QLPreviewController()
        var quickLookIsPresented = false
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            if !quickLookIsPresented {
                present(previewController, animated: false)
                quickLookIsPresented = true
            }
        }
    }
}

//#Preview {
//    ARQuickLookView()
//}
