//
//  PersonalView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/24.
//

import SwiftUI

struct PersonalView: View {
    var body: some View {
        VStack {
            Text("個人頁面")
                .font(.largeTitle)
                .padding()
            Spacer()
            Button(action: {
                // 實現登出功能
                logout()
            }) {
                Text("登出")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .navigationTitle("個人設定")
    }

    func logout() {
        // 在這裡實現登出邏輯，比如 Firebase 的 signOut 方法
        print("User logged out")
    }
}

#Preview {
    PersonalView()
}
