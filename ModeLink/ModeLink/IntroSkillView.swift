//
//  IntroSkillView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/20.
//

import SwiftUI
import Kingfisher
import YouTubePlayerKit
import FirebaseRemoteConfig

let skill2 = Skill(name: "剪裁技巧", description: "剪刀平穩操作，避免過度用力",imageUrl: "", position: 1, ytUrl: "https://www.youtube.com/watch?v=UCGDG7zd1wE")
struct IntroSkillView: View {
    @Environment(\.presentationMode) var presentationMode2
    let skill: Skill
    @State private var player: YouTubePlayer
    @State private var showYouTubePlayer: Bool = false  // 由遠程控制的參數
 
    // 初始化 Remote Config
    private var remoteConfig: RemoteConfig = {
        let config = RemoteConfig.remoteConfig()
        // 設置默認值
        let defaultValues: [String: NSObject] = [
            "showYouTubePlayer": true as NSObject
        ]
        config.setDefaults(defaultValues)
        return config
    }()
 
    init(skill: Skill) {
        _player = State(initialValue: YouTubePlayer(source: .url(skill.ytUrl)))
        self.skill = skill
    }
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 30) {
//                // 根據 showYouTubePlayer 來決定是否顯示 YouTube 播放器
//                if showYouTubePlayer {
//                    YouTubePlayerView(player)
//                        .frame(height: 400)
//                        .padding(.horizontal,2)
//                        //.transition(.opacity) // 使用過渡動畫
//                } else {
//                    //Text("Turn off the ytView.!!!!")
//                    Image(systemName: "photo").frame(height: 400)
//                }
//                
////                Text(skill.name)
////                    .font(.title)
////                    .foregroundColor(Color(UIColor.darkGray))
////                    .bold()
////                    .padding(.horizontal)
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color.white)
//                        .shadow(radius: 5) // 添加陰影以突出效果
//                    VStack(alignment: .leading) {
//                        Text(skill.name)
//                            .font(.title)
//                            .foregroundColor(Color(UIColor.darkGray))
//                            .bold()
//                            //.padding(.horizontal)
//                            .padding(.bottom,10)
//                        Text("技巧說明：")
//                            .font(.title2)
//                            .foregroundColor(Color(.systemGray))
//                            .bold()
//                            //.padding(.horizontal)
//                            .padding(.bottom, 10)
//                        Text(skill.description)
//                            .foregroundColor(Color(.systemGray))
//                            //.padding(.horizontal)
////                            .padding(.bottom,300)
//                    }.padding(.leading)
//                    
//                }
//                //.background(Color.blue)
//                Spacer()
//            }
//            .background(Color(.theme))
//            .frame(height: 400)
//        }
//        .safeAreaInset(edge: .top) { Color.clear.frame(height: 80)}
//        .background(Color(.theme))
//        .toolbarBackground(Color(.white), for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action: {
//            presentationMode2.wrappedValue.dismiss()
//        }) {
//            HStack {
//                Image(systemName: "chevron.backward").foregroundColor(.black)
//                Text("")
//            }
//        })
//        
//        .onAppear {
//            fetchRemoteConfig()
//        }
//    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 根據 showYouTubePlayer 來決定是否顯示 YouTube 播放器
                if showYouTubePlayer {
                    YouTubePlayerView(player)
                        .frame(height: 400)
                        .padding(.horizontal, 0)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(radius: 10) // 添加陰影
                        .padding(.top, 0)
                } else {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 400)
//                        .padding(.horizontal, 16)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .shadow(radius: 10) // 添加陰影
//                        .padding(.top, 16)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 400)
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("尚未選擇圖片")
                                    .foregroundColor(Color(.gray))
                            }
                        )
                        .padding([.horizontal],15)
                        .padding(.top, 15)
                }

                // 白色圓角背景
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.clear))
                        .shadow(radius: 5) // 添加陰影以突出效果
                        .padding(.horizontal, 8)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(skill.name)
                            .font(.custom("LexendDeca-Medium", size: 25))
                            .foregroundColor(Color(.white))
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 16)
                        Divider()
                            
                            .overlay(Color.white).padding(.horizontal,15)
                            .padding(.bottom, 15)
                            
                        Text("技巧說明：")
//                            .font(.title2)
//                            .foregroundColor(Color(.systemGray))
//                            .bold()
//                            .padding(.horizontal)
                            //.font(.headline).bold()
                            .font(.custom("LexendDeca-Medium", size: 20))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, -5)
                        
                        
                        Text(skill.description)
//                            .foregroundColor(Color(.systemGray))
//                            .padding(.horizontal)
//                            .padding(.bottom, 16)
//                            .font(.body)
                            .font(.custom("LexendDeca-Medium", size: 20))
                            .lineLimit(nil)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        Spacer()
                    }
                }.frame(height: 250)
                
                //.padding(.horizontal, 16) // 控制圓角背景與螢幕邊緣的距離
                //.padding(.top, 16)

                Spacer()
            }
            .background(
//                LinearGradient(
//                    gradient: Gradient(colors: [Color(.theme), Color(.white)]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
                Color.theme
            )
            .frame(minHeight: UIScreen.main.bounds.height - 150)
            .padding(.top, 16) // 給 ScrollView 添加頂部間距
        }
        .padding(.top, 70)
        
        .edgesIgnoringSafeArea(.top)
        //.safeAreaInset(edge: .top) { Color.clear.frame(height: 80) }
        .toolbarBackground(Color(.white), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode2.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward").foregroundColor(.black)
            }
        })
        .onAppear {
            fetchRemoteConfig()
        }
    }

    // 從 Firebase Remote Config 取回參數
    func fetchRemoteConfig() {
        // 設定最短取回間隔為 0 秒（開發期間使用）
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.fetchAndActivate { (status, error) in
            if let error = error {
                print("Error fetching remote config: \(error.localizedDescription)")
                return
            }
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                // 取得 showYouTubePlayer 的值，並更新本地狀態
                self.showYouTubePlayer = remoteConfig["showYouTubePlayer"].boolValue
                print("Remote config updated! showYouTubePlayer: \(self.showYouTubePlayer)")
            } else {
                print("Failed to fetch remote config")
            }
        }
    }
}
#Preview {
    IntroSkillView(skill: skill2)
}
