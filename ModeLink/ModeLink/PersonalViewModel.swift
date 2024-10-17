//
//  PersonalViewModel.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/10/17.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class PersonalViewModel: ObservableObject {
    @Published var userName: String = "Loading..."
    @Published var blockedUsers: [BlockedUser] = []
    @Published var showBlockedList: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true
    
    private let db = Firestore.firestore()
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
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
        
        let userRef = db.collection("users").document(userId)
        
        // 更新 isDelete 狀態
        userRef.updateData([
            "isDelete": true
        ]) { error in
            if let error = error {
                print("更新 isDelete 狀態時發生錯誤: \(error.localizedDescription)")
            } else {
                print("已成功更新 isDelete 狀態")
                self.logout() 
            }
        }
    }
    
    func fetchUserName() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["displayName"] as? String ?? "Unknown"
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
        
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let blockedUserIDs = data?["blockedUsers"] as? [String] ?? []
                
                self.blockedUsers.removeAll()
                
                for blockedUserID in blockedUserIDs {
                    let blockedUserRef = self.db.collection("users").document(blockedUserID)
                    blockedUserRef.getDocument { blockedUserDoc, error in
                        if let blockedUserDoc = blockedUserDoc, blockedUserDoc.exists {
                            let blockedUserData = blockedUserDoc.data()
                            let blockedUserName = blockedUserData?["displayName"] as? String ?? "Unknown"
                            let blockedUser = BlockedUser(id: blockedUserID, name: blockedUserName)
                            self.blockedUsers.append(blockedUser)
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
        
        let userRef = db.collection("users").document(currentUserID)
        
        userRef.updateData([
            "blockedUsers": FieldValue.arrayRemove([userId])
        ]) { error in
            if let error = error {
                print("解除封鎖時發生錯誤: \(error.localizedDescription)")
            } else {
                print("已解除封鎖")
                self.blockedUsers.removeAll { $0.id == userId }
            }
        }
    }
}
