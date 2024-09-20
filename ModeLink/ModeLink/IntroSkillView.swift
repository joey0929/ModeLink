//
//  IntroSkillView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/20.
//

import SwiftUI
import Kingfisher

let skill2 = Skill(name: "剪裁技巧", description: "剪刀平穩操作，避免過度用力",imageUrl: "", position: 1)


struct IntroSkillView: View {
    let skill: Skill
    
    var body: some View {
           VStack(alignment: .leading, spacing: 20) {
               // 圖片放置最上方
//               Image(systemName: skill.imageUrl)
//                   .resizable()
//                   .aspectRatio(contentMode: .fit) // 保持圖片比例
//                   .frame(height: 200) // 調整圖片高度
//                   .padding(.top)
//                   .frame(maxWidth: .infinity) // 寬度撐滿
               // 使用 Kingfisher 加載圖片
               KFImage(URL(string: skill.imageUrl))
                   .resizable()
                   .aspectRatio(contentMode: .fit) // 保持圖片比例
                   .frame(height: 400) // 調整圖片高度
                   .clipped()
                   .padding(.top)
                   .frame(maxWidth: .infinity) // 寬度撐滿
               
               
               
               
               // 品名
               Text(skill.name)
                   .font(.largeTitle)
                   .bold()
                   .padding(.horizontal)
               
               // 用途
               
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
           .navigationTitle("技巧詳情")
       }
}

#Preview {
    IntroSkillView(skill: skill2)
}
