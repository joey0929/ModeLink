//
//  PersonalView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct PersonalView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true // 用於追蹤登入狀態
    @State private var userName: String = "Loading..." // 用於存儲用戶名稱
    var body: some View {
        VStack {
            Text("個人頁面")
                .font(.largeTitle)
                .padding()
            
            // 顯示用戶名稱
            Text("Hello, \(userName)")
                .font(.headline)
                .padding()
            
            Spacer()
            Button {
                logout()
            } label: {
                Text("登出")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .onAppear {
                fetchUserName()
            }
            Spacer()
        }
//        .navigationTitle("個人設定")
    }

    func logout() {
        // 在這裡實現登出邏輯，比如 Firebase 的 signOut 方法
//        print("User logged out")
        do {
            try Auth.auth().signOut() // 使用 FirebaseAuth 的 signOut 方法登出
            isLoggedIn = false // 更新登入狀態，返回到登入頁面
            print("User logged out")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func fetchUserName() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                userName = data?["displayName"] as? String ?? "Unknown"
            } else {
                print("User not found in Firestore")
            }
        }
    }
    
    
}

#Preview {
    PersonalView()
}
