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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 根據 showYouTubePlayer 來決定是否顯示 YouTube 播放器
                if showYouTubePlayer {
                    YouTubePlayerView(player)
                        .frame(height: 500)
                        .transition(.opacity) // 使用過渡動畫
                } else {
                    Text("Turn off the ytView.!!!!")
                }

                Text(skill.name)
                    .font(.title)
                    .foregroundColor(Color(UIColor.darkGray))
                    .bold()
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("技巧說明：")
                        .font(.title2)
                        .foregroundColor(Color(.systemGray))
                        .bold()
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    Text(skill.description)
                        .foregroundColor(Color(.systemGray))
                        .padding(.horizontal)
                }
                Spacer()
            }.background(Color(.systemGray6))
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode2.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward").foregroundColor(.black)
                Text("")
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
