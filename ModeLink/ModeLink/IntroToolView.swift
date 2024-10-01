//
//  IntroToolView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/20.
//

import SwiftUI
import Kingfisher


let sampleTool = Tool(
            id: "1",
            name: "斜口剪",
            price: "200 - 500 TWD",
            recommend: "Tamiya, GodHand",
            description: "用於剪斷各種材料的工具，適合於模型製作。",
            imageUrl: "https://via.placeholder.com/400", // 假的圖片 URL
            position: 1
        )


struct IntroToolView: View {
    let tool: Tool
    
    
//    var body: some View {
//        ScrollView(showsIndicators: false) { // 使用 ScrollView 以防資料過多無法顯示完整
//            VStack(alignment: .leading, spacing: 20) {
//                // 使用 Kingfisher 加載圖片
//                KFImage(URL(string: tool.imageUrl))
//                    .resizable()
//                    .aspectRatio(contentMode: .fit) // 保持圖片比例
//                    .frame(height: 400) // 調整圖片高度
//                    .clipped()
//                    .padding(.top)
//                    .frame(maxWidth: .infinity) // 寬度撐滿
//                
//                
//                // 品名
//                Text(tool.name)
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.horizontal)
//                // 用途部分
//                VStack(alignment: .leading) {
//                    Text("用途：")
//                        .font(.title3)
//                        .bold()
//                        .padding(.horizontal)
//                    Text(tool.description)
//                        .padding(.horizontal)
//                }
//                // 價位部分
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("價位：")
//                        .font(.title3)
//                        .bold()
//                        .padding(.horizontal)
//                    Text(tool.price)
//                        .padding(.horizontal)
//                    Text("推薦品牌：")
//                        .font(.title3)
//                        .bold()
//                        .padding(.horizontal)
//                    Text(tool.recommend)
//                        .padding(.horizontal)
//                }
//                Spacer() // 將內容往上推，留出下方空間
//            }
//            .navigationTitle("工具詳情")
//            .background(Color(.systemGray6))
//            .ignoresSafeArea()
//        }
//        .background(Color(.systemGray5))
//    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // 使用 Kingfisher 加載圖片
                KFImage(URL(string: tool.imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit) // 保持圖片比例
                    .frame(height: 400) // 調整圖片高度
                    .clipped()
                    .padding(.top)
                    .frame(maxWidth: .infinity) // 寬度撐滿
                
                // 包裹文字的部分，並添加白色背景
                ZStack {
                    // 背景視圖
                    Color.white
                        .cornerRadius(10) // 圓角
                        .shadow(radius: 5) // 添加陰影
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // 品名
                        Text(tool.name)
                            .font(.largeTitle)
                            .bold()
                            //.padding(.horizontal)
                        
                        // 用途部分
                        VStack(alignment: .leading) {
                            Text("用途：")
                                .font(.title3)
                                .bold()
                                //.padding(.horizontal)
                            Text(tool.description)
                                //.padding(.horizontal)
                        }
                        
                        // 價位部分
                        VStack(alignment: .leading, spacing: 10) {
                            Text("價位：")
                                .font(.title3)
                                .bold()
                                //.padding(.horizontal)
                            Text(tool.price)
                               // .padding(.horizontal)
                            Text("推薦品牌：")
                                .font(.title3)
                                .bold()
                                //.padding(.horizontal)
                            Text(tool.recommend)
                                //.padding(.horizontal)
                        }
                    }
                    .padding(.horizontal,5)
                    .padding(.vertical,8)
                    //.padding() // 內邊距
                }
                .padding(.horizontal) // 外邊距
                Spacer() // 將內容往上推，留出下方空間
            }
            .navigationTitle("工具詳情")
            .background(Color(.systemGray6))
            .ignoresSafeArea()
        }
        .background(Color(.systemGray5))
    }
    
    
    
    
}
#Preview {
    
    IntroToolView(tool: sampleTool)
}
