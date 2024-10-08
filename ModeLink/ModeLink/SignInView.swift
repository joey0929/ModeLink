//
//  SignInView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit

struct SignInView: View {
    @State private var currentNonce: String?
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to ModeLink!")
//                .font(.largeTitle)
                .font(.custom("LexendDeca-SemiBold", size: 51))
                //.foregroundColor(.black.opacity(0.8))
                .foregroundStyle(Color(.black).opacity(0.8))
                .bold()
                .padding(.top, 60)
            Spacer()
            // 登入說明
            Text("Please sign in with your Apple ID:")
                .font(.custom("LexendDeca-Bold", size: 16))
                .foregroundColor(.theme)
                .padding(.bottom, 0)
            //Text("Please sign in with apple Id:")
            if !isLoggedIn {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = sha256(nonce)
                    },
                    onCompletion: handleSignInWithApple // 使用提取出的函數
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding(.horizontal, 15)
                .cornerRadius(10) // 圓角按鈕
                .shadow(radius: 5) // 陰影效果
                .padding()
                .padding(.top, -15)
            } else {
                // 顯示登入成功後的主頁面
                ContentView()
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.theme, Color(.white)]), // 設定漸層顏色
                startPoint: .topLeading, // 漸層起點
                endPoint: .bottomTrailing // 漸層終點
            )
            
            
        )
    }
    // 處理 Apple 登入的函數
    private func handleSignInWithApple(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else {
                print("Error: Could not retrieve credential.")
                return
            }
            guard let nonce = currentNonce else {
                print("Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // 使用 Firebase Authentication 登入
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error authenticating: \(error.localizedDescription)")
                    return
                }
                // 取得用戶資訊
                let user = authResult?.user
                let displayName = appleIDCredential.fullName?.givenName ?? ""
                let email = appleIDCredential.email ?? ""
                
                // 確認這是首次登入並儲存到 Firestore
                saveUserToFirestore(uid: user?.uid ?? "", displayName: displayName, email: email)
                
                // 更新登入狀態
                isLoggedIn = true
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
    
    // 儲存用戶資訊到 Firestore
    private func saveUserToFirestore(uid: String, displayName: String, email: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("User already exists in Firestore.")
            } else {
                // 儲存用戶資訊
                let userData: [String: Any] = [
                    "uid": uid,
                    "displayName": displayName,
                    "email": email,
                    "createdAt": Timestamp(date: Date()),
                    "blockedUsers": [] // 初始化空的封鎖列表
                ]
                
                userRef.setData(userData) { error in
                    if let error = error {
                        print("Error saving user data: \(error.localizedDescription)")
                    } else {
                        print("User data successfully saved to Firestore.")
                    }
                }
            }
        }
    }
    
    // Helper functions
    private func randomNonceString(length: Int = 32) -> String {
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}

#Preview {
    SignInView()
}
