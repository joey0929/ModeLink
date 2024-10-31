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
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                // 根據 showYouTubePlayer 來決定是否顯示 YouTube 播放器
                if showYouTubePlayer {
                    YouTubePlayerView(player)
                        .frame(height: 400)
                        .padding(.horizontal, 0)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(radius: 10) // 添加陰影
                        .padding(.top, 25)
                } else {
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
                        .padding(.top, 25)
                }
                // 白色圓角背景
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.clear))
                        .shadow(radius: 5) // 添加陰影以突出效果
                        .padding(.horizontal, 8)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(skill.name)
                            .font(.custom("LexendDeca-Medium", size: 22))
                            .foregroundColor(Color(.white))
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 16)
                        Divider()
                        
                            .overlay(Color.white).padding(.horizontal,15)
                            .padding(.bottom, 15)
                        
                        Text("技巧說明：")
                            .font(.custom("LexendDeca-Medium", size: 18))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.bottom, 0)
                        ScrollView {
                            Text(skill.description)
                                .font(.custom("LexendDeca-Medium", size: 16))
                                .lineLimit(nil)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                                .lineSpacing(10)
                        }
                        Spacer()
                    }
                }.frame(height: 250)
                Spacer()
            }
            .background(
                Color.theme
            )
            .frame(minHeight: UIScreen.main.bounds.height - 150)
            .padding(.top, 95)
            .edgesIgnoringSafeArea(.top)
            .toolbarBackground(Color(.theme).opacity(0.5), for: .navigationBar)
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
            ZStack{
                VStack{
                    Spacer()
                }
                Color.white.frame(height: 125).padding(.top,800)
            }
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
