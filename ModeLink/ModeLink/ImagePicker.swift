//
//  ImagePicker.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/16.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    // 將 UIKit 中的 PHPickerViewController 封裝成可以在 SwiftUI 中使用的圖片選擇器
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // 只允許選擇圖片
        config.selectionLimit = 1 // 只能選擇一張圖片
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {  // 處理用戶選擇圖片
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker  // 父視圖 ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }  // 取得選擇的第一個圖片

            if provider.canLoadObject(ofClass: UIImage.self) {  // 檢查選中的文件是否可以轉換為 UIImage
                provider.loadObject(ofClass: UIImage.self) { image, _ in   // 加載圖片並傳回
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}
