//
//  IntroSkillView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/20.
//

import SwiftUI
import Kingfisher
import YouTubePlayerKit

let skill2 = Skill(name: "剪裁技巧", description: "剪刀平穩操作，避免過度用力",imageUrl: "", position: 1, ytUrl: "https://www.youtube.com/watch?v=UCGDG7zd1wE")
struct IntroSkillView: View {
    let skill: Skill
    @State private var player: YouTubePlayer
    init(skill: Skill) {
        _player = State(initialValue: YouTubePlayer(source: .url(skill.ytUrl)))
        self.skill = skill
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                YouTubePlayerView(player).frame(height:500)
                Text(skill.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text("技巧說明：")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                    Text(skill.description)
                        .padding(.horizontal)
                }
                Spacer() // 將內容往上推，留出下方空間
            }
        }
    }
}
#Preview {
    IntroSkillView(skill: skill2)
}
