//
//  PersonalView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct BlockedUser: Identifiable {
    let id: String // 使用者 ID
    let name: String // 使用者名稱
}
struct PersonalView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true // 用於追蹤登入狀態
    @State private var userName: String = "Loading..." // 用於存儲用戶名稱
    @State private var blockedUsers: [BlockedUser] = [] // 用於儲存封鎖的用戶 ID
    @State private var showBlockedList = false // 用於控制是否顯示封鎖列表
    
//    var body: some View {
//        ZStack {
//            VStack(spacing: 20) {
//                // 設定標題
////                HStack {
////                    Text("個人設定")
////                        .font(.custom("LexendDeca-Bold", size: 33))
////                    //                    .font(.largeTitle)
////                        .bold()
////                        .padding()
////                    Spacer()
////                }.padding(.top,65)
//                
//                // 用戶頭像與名稱
//                VStack {
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .frame(width: 80, height: 80)
//                        .foregroundColor(.gray)
//                        .padding(.bottom, 10)
//                    
//                    Text("Hello, \(userName)")
//                        .font(.title2)
//                        .bold()
//                        .padding(.bottom, 10)
//                }.padding(.top, 170)
//                //            .background(
//                //                RoundedRectangle(cornerRadius: 16)
//                //                    .fill(Color.white)
//                //                    .shadow(radius: 5)
//                //            )
//                .padding(.horizontal)
//                
//                // 顯示封鎖列表按鈕
//                Button(action: {
//                    fetchBlockedUsers() // 獲取封鎖的用戶
//                    showBlockedList.toggle() // 切換顯示封鎖列表
//                }) {
//                    Text(showBlockedList ? "關閉封鎖列表" : "顯示封鎖列表")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                        .padding()
////                        .background(Color.blue.opacity(0.9))
//                        .background(Color.clear)
//                        .foregroundColor(.black)
//                        .cornerRadius(12)
//                }
//                .padding(.horizontal)
//                
//                // 封鎖列表
//                if showBlockedList {
//                    List(blockedUsers) { blockedUser in
//                        HStack {
//                            Text(blockedUser.name) // 顯示封鎖的使用者名稱
//                            Spacer()
//                            Button {
//                                unblockUser(userId: blockedUser.id) // 解除封鎖
//                            } label: {
//                                Text("解除封鎖")
//                                    .foregroundColor(.red)
//                            }
//                        }
//                    }
//                    .listStyle(PlainListStyle()) // 使用 PlainListStyle 使列表背景更容易設置
//                    .background(Color.white.opacity(0.5)) // 設定列表的背景顏色
//                    .frame(height:200) // 限制列表高度
//                    .cornerRadius(15)
//                    .padding(.horizontal)
//                } else {
////                    Rectangle().frame(height: 200)
//                }
//                
//                // 按鈕區域
//                
//                VStack(spacing: 15) {
//                    Button(action: {
//                        logout()
//                    }) {
//                        HStack{
//                            Image(systemName: "rectangle.portrait.and.arrow.right")
//                            Text("登出")
//                            
//                        }.font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                //.background(Color.red.opacity(0.9))
//                                .background(Color(red: 0.8509803921568627, green: 0.8509803921568627, blue: 0.8509803921568627))
//                                .foregroundColor(.black)
//                                .cornerRadius(12)
//                       
//                    }
//                    
//                    Button(action: {
//                        deleteAccount()
//                    }) {
//                        Text("刪除帳號")
//                            .font(.headline)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color(red: 0.2823529411764706, green: 0.2823529411764706, blue: 0.2823529411764706))
//                            .foregroundColor(.white)
//                            .cornerRadius(12)
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top,250)
//                
//                
//                Spacer()
//            }
//            
//            ZStack{
//                VStack{
//                    Spacer()
//                    //Rectangle().background(.clear).frame(height: 100)
//                }
//                Color.white.frame(height: 130).padding(.top,800)
//            }
// 
//        }
//        //.padding()
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            HStack {
//                Image(systemName: "chevron.backward").foregroundColor(.black)
//            }
//        })
//        .toolbar {
//            // 自訂標題
//            ToolbarItem(placement: .principal) {
//                Text("個人設定")
////                    .font(.headline)
//                    .font(.custom("LexendDeca-Medium", size: 20))
//                    .bold()
//                    .foregroundStyle(Color(.black))
//            }
//        }
//        .onAppear {
//            fetchUserName()
//        }
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [Color.gray, Color.white]), // 設定漸層顏色
//                startPoint: .bottom, // 漸層起點
//                endPoint: .top // 漸層終點
//            )
//        )
//    }
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // 用戶頭像與名稱
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    Text("Hello, \(userName)")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 10)
                }
                .padding(.top, 170)
                .padding(.horizontal)
                
                // 顯示封鎖列表按鈕
                Button(action: {
                    fetchBlockedUsers() // 獲取封鎖的用戶
                    showBlockedList.toggle() // 切換顯示封鎖列表
                }) {
                    Text(showBlockedList ? "關閉封鎖列表" : "顯示封鎖列表")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.clear)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    
                }
                .padding(.leading, -250)
                
                
                // Divider 作為分隔線
                Divider()
                    .background(Color.gray) // 設定分隔線顏色
                    .frame(width: 100)
                    .padding(.leading, -175)
                    .padding(.top, -30)
                //.padding(.horizontal)
                // 封鎖列表區域，始終保持固定高度
                VStack {
                    if showBlockedList {
                        VStack {  // 在 List 外包裹一個 VStack 來設置背景
                            
                            List(blockedUsers) { blockedUser in
                                HStack {
                                    Text(blockedUser.name) // 顯示封鎖的使用者名稱
                                    Spacer()
                                    Button {
                                        unblockUser(userId: blockedUser.id) // 解除封鎖
                                    } label: {
                                        Text("解除封鎖")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                            }
                            .listStyle(PlainListStyle()) // 使用 PlainListStyle 使列表背景更容易設置
                            .cornerRadius(10)
                        }
                        .background(Color.white.opacity(0.4)) // 設置列表的背景顏色
                        .cornerRadius(10)
                        .padding(.horizontal,5)
                        .padding(.top,-30)
                    } else {
                        // 當封鎖列表未顯示時保留空白區域
                        Rectangle()
                            .fill(Color.clear) // 使用透明的佔位符
                    }
                }
                .frame(height: 200) // 保留固定的高度
                .padding(.horizontal)
                
                
                // 按鈕區域
                VStack(spacing: 15) {
                    Button(action: {
                        logout()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("登出")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
//                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .background(Color(red: 0.28, green: 0.28, blue: 0.28))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        deleteAccount()
                    }) {
                        Text("刪除帳號")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
//                            .background(Color(red: 0.28, green: 0.28, blue: 0.28))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }.padding(.top , -5)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
            
            // 頁面底部的底色色塊
            ZStack {
                VStack {
                    Spacer()
                }
                Color.white.frame(height: 130).padding(.top, 800)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward").foregroundColor(.black)
            }
        })
        .toolbar {
            // 自訂標題
            ToolbarItem(placement: .principal) {
                Text("個人設定")
                    .font(.custom("LexendDeca-Medium", size: 20))
                    .bold()
                    .foregroundStyle(Color(.black))
            }
        }
        .onAppear {
            fetchUserName()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.white]), // 設定漸層顏色
                startPoint: .bottom, // 漸層起點
                endPoint: .top // 漸層終點
            )
        )
    }
    
    func logout() {
        do {
            try Auth.auth().signOut() // 使用 FirebaseAuth 的 signOut 方法登出
            isLoggedIn = false // 更新登入狀態，返回到登入頁面
            print("User logged out")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    
    func deleteAccount() {
            guard let userId = Auth.auth().currentUser?.uid else {
                print("User not logged in")
                return
            }
            
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userId)
            
            // 更新 isDelete 狀態
            userRef.updateData([
                "isDelete": true
            ]) { error in
                if let error = error {
                    print("更新 isDelete 狀態時發生錯誤: \(error.localizedDescription)")
                } else {
                    print("已成功更新 isDelete 狀態")
                    logout() // 更新成功後登出使用者
                }
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
    
    func fetchBlockedUsers() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let blockedUserIDs = data?["blockedUsers"] as? [String] ?? []
                
                // 清空之前的封鎖列表
                blockedUsers.removeAll()
                
                // 遍歷封鎖的 ID，獲取每個使用者的名稱
                for blockedUserID in blockedUserIDs {
                    let blockedUserRef = db.collection("users").document(blockedUserID)
                    blockedUserRef.getDocument { blockedUserDoc, error in
                        if let blockedUserDoc = blockedUserDoc, blockedUserDoc.exists {
                            let blockedUserData = blockedUserDoc.data()
                            let blockedUserName = blockedUserData?["displayName"] as? String ?? "Unknown"
                            // 更新封鎖列表
                            let blockedUser = BlockedUser(id: blockedUserID, name: blockedUserName)
                            blockedUsers.append(blockedUser)
                        }
                    }
                }
            } else {
                print("User not found in Firestore")
            }
        }
    }
    
    func unblockUser(userId: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("無法取得當前使用者 ID")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserID)
        
        userRef.updateData([
            "blockedUsers": FieldValue.arrayRemove([userId]) // 從封鎖列表中移除
        ]) { error in
            if let error = error {
                print("解除封鎖時發生錯誤: \(error.localizedDescription)")
            } else {
                print("已解除封鎖")
                blockedUsers.removeAll { $0.id == userId } // 更新本地封鎖列表
            }
        }
    }

}

#Preview {
    PersonalView()
}
