//
//  ModeLinkApp.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/12.
//

import SwiftUI
import FirebaseCore
import IQKeyboardManagerSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
@main
struct ModeLinkApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        IQKeyboardManager.shared.enable = true
    }

    var body: some Scene {
        WindowGroup {
            //ContentView()
            if isLoggedIn {
                ContentView()  // 登入後進入的主頁面
            } else {
                SignInView()   // 登入頁面
            }
            
        }
    }
}
