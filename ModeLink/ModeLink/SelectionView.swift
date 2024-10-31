//
//  SelectionView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/10/11.
//

import SwiftUI
import UIKit
import ARKit

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView(isShowingARSelection: .constant(true), selectedTab: .constant(1))
    }
}
struct SelectionView: View {
    @Binding var isShowingARSelection: Bool
    @Binding var selectedTab: Int  // 添加 Binding 來控制選擇的 Tab
    @State private var isProUser: Bool = false // 保存用戶是否是 Pro 系列的選擇
    var isLiDARAvailable: Bool {
        return ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
    }
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("可以在這選擇是否要進入掃描頁面，盡情掃描模型吧！")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 27)
            Text("(會自動確認您的手機是否為 Pro 系列，如果不是請點擊下方的'回到文章頁面'按鈕返回文章頁面)")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 27)
                .padding(.bottom)
            Button(action: {
                if isProUser && isLiDARAvailable {
                    isShowingARSelection = false
                }
            }) {
                Text("進入模型掃描")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isProUser ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(!isProUser || !isLiDARAvailable)
            .padding(.horizontal, 30)
            Button(action: {
                selectedTab = 1
            }) {
                Text("回到文章頁面")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            Spacer()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.white]),
                startPoint: .bottom,
                endPoint: .top
            )
        )
        .onAppear {
            let modelName = UIDevice.current.modelName
            isProUser = modelName.contains("Pro") && !modelName.contains("Unknown")
            // 根據設備型號自動判斷是否是 Pro 系列
        }
    }
}


// Extension to get device model name
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.compactMap { element in
            element.value as? Int8
        }.filter { $0 != 0 }.map { String(UnicodeScalar(UInt8($0))) }.joined()

        switch identifier {
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"
        case "iPhone16,1": return "iPhone 15 Pro"
        case "iPhone16,2": return "iPhone 15 Pro Max"
        case "iPhone17,1": return "iPhone 16 Pro"
        case "iPhone17,2": return "iPhone 16 Pro Max"
        default: return "Unknown Device"
        }
    }
}
