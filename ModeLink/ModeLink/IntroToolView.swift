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
            position: 1, careful: "小心對準零件後再下刀"
        )
struct IntroToolView: View {
    @Environment(\.presentationMode) var presentationMode
    let tool: Tool

    var body: some View {
        ZStack {
                VStack(spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        KFImage(URL(string: tool.imageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 350) // 調整圖片高度
                            .clipped()
                            .ignoresSafeArea(edges: .top) // 忽略安全區域，讓圖片超出狀態欄
                        // 返回按鈕
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.white.opacity(0.1)) // 調整按鈕背景透明度
                                .clipShape(Circle())
                        }
                        .padding(.top, 60) // 調整返回按鈕距離
                        .padding(.leading, 20)
                    }
                    // 下方藍色區塊
                    VStack(alignment: .leading, spacing: 16) {
                        Text(tool.name)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 40)
                            .padding(.leading,15)
                            .padding(.bottom,-28)
                        VStack {
                            HStack {
                                VStack {
                                    Text("$\(tool.price)")
                                        .font(.custom("LexendDeca-Medium", size: 16))
                                        .foregroundColor(Color(.systemGray3))
                                        .bold()
                                        .padding(.leading,15)
                                }
                                Spacer()
                            }
                            .frame(width: 380, height: 50)
                            .shadow(radius: 5)
                            HStack {
                                VStack {
                                    Text(tool.recommend)
                                        .font(.custom("LexendDeca-Medium", size: 16))
                                        .foregroundColor(Color(red: 1.0, green: 0.8745098039215686, blue: 0.43137254901960786))
                                        .bold().padding(.leading,15)
                                }
                                Spacer()
                            }
                            .frame(width: 380, height: 50)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        }
                        // 用途部分
                        VStack(alignment: .leading, spacing: 8) {
                            Text("用途：")
                                .font(.custom("LexendDeca-Medium", size: 18))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                                .padding(.top, 10)
                            Text(tool.description)
                                .font(.custom("LexendDeca-Medium", size: 16))
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                                .lineSpacing(10)
                            Text("注意事項：")
                                .font(.custom("LexendDeca-Medium", size: 18))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            ScrollView {
                                Text(tool.careful)
                                    .font(.custom("LexendDeca-Medium", size: 16))
                                    .foregroundColor(.white)
                                    .lineSpacing(10)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal,30)
                        Spacer() // 添加一個 Spacer 來填充空間
                    }
                    .frame(maxWidth: .infinity) // 讓內容寬度自適應螢幕
                    .frame(height: 550)
                    .background(Color.theme) // 設置藍色背景
                    .cornerRadius(50) // 只設置上方圓角
                    .padding(.top, -30) // 使卡片稍微往上與圖片疊加
                }.padding(.horizontal)
            ZStack{
                VStack{
                    Spacer()
                }
                Color.white.frame(height: 90).padding(.top,800)
            }
        }
        .navigationBarHidden(true) // 隱藏默認導航欄
    }
}
#Preview {
    IntroToolView(tool: sampleTool)
}
