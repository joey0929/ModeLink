//
//  IntroToolView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/20.
//

import SwiftUI
import Kingfisher

struct IntroToolView: View {
    let tool: Tool
    
    var body: some View {
        ScrollView(showsIndicators: false) { // 使用 ScrollView 以防資料過多無法顯示完整
            VStack(alignment: .leading, spacing: 20) {
                
                // 使用 Kingfisher 加載圖片
                KFImage(URL(string: tool.imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit) // 保持圖片比例
                    .frame(height: 400) // 調整圖片高度
                    .clipped()
                    .padding(.top)
                    .frame(maxWidth: .infinity) // 寬度撐滿
                
                // 品名
                Text(tool.name)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                // 用途部分
                VStack(alignment: .leading) {
                    Text("用途：")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                    Text(tool.description)
                        .padding(.horizontal)
                }
                
                // 價位部分
                VStack(alignment: .leading, spacing: 10) {
                    Text("價位：")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                    Text(tool.price)
                        .padding(.horizontal)
                    
                    Text("推薦品牌：")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                    Text(tool.recommend)
                        .padding(.horizontal)
                }
                
                Spacer() // 將內容往上推，留出下方空間
            }
            .navigationTitle("工具詳情")
        }
    }
}



//#Preview {
//    IntroToolView(tool: mockdata2)
//}
