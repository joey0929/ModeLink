//
//  SelectionView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/10/11.
//

import SwiftUI

struct SelectionView: View {
    @Binding var isShowingARSelection: Bool
    @Binding var selectedTab: Int  // 添加 Binding 來控制選擇的 Tab
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("可以在這選擇是否要進入掃描頁面，盡情掃描模型吧！")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 27)
            Text("(請確認您的手機是否為 Pro 系列，如果不是，請點擊下方的 '回到文章頁面' 按鈕返回文章頁面)")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 27)
                .padding(.bottom)
            
            // 按鈕1: 進入 AR 扫描
            Button(action: {
                isShowingARSelection = false // 點擊後將顯示 ARView
            }) {
                Text("進入模型掃描")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            
            // 按鈕2: 其他操作
            Button(action: {
                // 可以在這裡添加其他操作
//                print("其他操作被選擇")
                // 切換到 tab 1
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
        //.padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.white]), // 設定漸層顏色
                startPoint: .bottom, // 漸層起點
                endPoint: .top // 漸層終點
            )
        )
        
    }
        
    
}

//#Preview {
//    SelectionView(true)
//}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView(isShowingARSelection: .constant(true), selectedTab: .constant(1))
    }
}
