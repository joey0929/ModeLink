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


//struct IntroToolView: View {
//    let tool: Tool
//    
//    
//    var body: some View {
//        ScrollView(showsIndicators: false) { // 使用 ScrollView 以防資料過多無法顯示完整
//            VStack(alignment: .leading, spacing: 20) {
//                // 使用 Kingfisher 加載圖片
//                KFImage(URL(string: tool.imageUrl))
//                    .resizable()
//                    .aspectRatio(contentMode: .fill) // 保持圖片比例
//                    .frame(height: 400) // 調整圖片高度
//                    .clipped()
//                    //.padding(.top)
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
//}
struct IntroToolView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let tool: Tool

    var body: some View {
        ScrollView(showsIndicators: false) { // 使用 ScrollView 以防資料過多無法顯示完整
            VStack(alignment: .leading, spacing: 5) {
                // 使用 Kingfisher 加載圖片
                KFImage(URL(string: tool.imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill) // 保持圖片比例
                    .frame(height: 420) // 調整圖片高度
                    .clipped()
                    .frame(maxWidth: .infinity) // 寬度撐滿
                
                // 品名
                Text(tool.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(UIColor.darkGray)) // 使用主題色
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    .padding(.top, 10)
                // 用途部分
                VStack(alignment: .leading, spacing: 10) {
                    Text("用途：")
                        .font(.title3)
                        .bold()
                        //.foregroundColor(Color(.systemGray)) // 使用主題色來突出標題
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    Text(tool.description)
                        .font(.body)
                        .foregroundColor(.secondary) // 使用次要顏色，降低文本的視覺優先級
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    Text("價位：")
                        .font(.title3)
                        .bold()
                       //.foregroundColor(Color(.systemGray)) // 使用主題色來突出標題
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    Text(tool.price)
                        .font(.body)
                        .foregroundColor(.secondary) // 使用次要顏色
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    Text("推薦品牌：")
                        .font(.title3)
                        .bold()
//                        .foregroundColor(Color(.systemGray)) // 使用主題色來突出標題
                        .foregroundColor(Color(UIColor.darkGray))
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    Text(tool.recommend)
                        .font(.body)
                        .foregroundColor(.secondary) // 使用次要顏色
                        .padding(.horizontal)
                }
                Spacer() // 將內容往上推，留出下方空間
            }
            //.padding() // 整體增加內邊距
            .background(Color.white) // 添加白色背景
            .cornerRadius(10) // 添加圓角
            //.shadow(radius: 5) // 添加陰影以提高視覺層次
            .navigationTitle("工具詳情")
            .background(Color(.systemGray6))
            .ignoresSafeArea()
        }
        .background(Color(.systemGray5))
        .navigationBarBackButtonHidden(true) 
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward").foregroundColor(.black)
                Text("")
            }
        })
    }
}




#Preview {
    IntroToolView(tool: sampleTool)
}
