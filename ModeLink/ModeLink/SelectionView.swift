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
    @AppStorage("isProUser") private var isProUser: Bool = false // 保存用戶是否是 Pro 系列的選擇
    @AppStorage("hasCheckedProStatus") private var hasCheckedProStatus: Bool = false // 記錄是否已經檢查過

    @State private var showAlert = false // 控制顯示 Alert

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

            // 按鈕1: 進入 AR 掃描
            Button(action: {
                if isProUser {
                    isShowingARSelection = false // 點擊後將顯示 ARView
                }
            }) {
                Text("進入模型掃描")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isProUser ? Color.blue : Color.gray) // 根據用戶選擇決定按鈕顏色
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(!isProUser) // 如果不是 Pro 系列，則禁用按鈕
            }
            .padding(.horizontal, 30)

            // 按鈕2: 其他操作
            Button(action: {
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
            
            
            // 按鈕3: 進入 TestCrashView
            NavigationLink(destination: TestCrashView()) {
                Text("進入 TestCrashView")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
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
            if !hasCheckedProStatus {
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("請確認"),
                message: Text("您是否使用 Pro 系列的手機？"),
                primaryButton: .default(Text("是")) {
                    isProUser = true // 設定為 Pro 系列
                    hasCheckedProStatus = true // 設定為已檢查過
                },
                secondaryButton: .destructive(Text("否")) {
                    isProUser = false // 設定為非 Pro 系列
                    hasCheckedProStatus = true // 設定為已檢查過
                }
            )
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView(isShowingARSelection: .constant(true), selectedTab: .constant(1))
    }
}
