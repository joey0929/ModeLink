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
//struct IntroToolView: View {
//    
//    @Environment(\.presentationMode) var presentationMode
//    let tool: Tool
//
//    var body: some View {
//        ScrollView(showsIndicators: false) { // 使用 ScrollView 以防資料過多無法顯示完整
//            VStack(alignment: .leading, spacing: 5) {
//                // 使用 Kingfisher 加載圖片
//                KFImage(URL(string: tool.imageUrl))
//                    .resizable()
//                    .aspectRatio(contentMode: .fill) // 保持圖片比例
//                    .frame(height: 420) // 調整圖片高度
//                    .clipped()
//                    .frame(maxWidth: .infinity) // 寬度撐滿
//                
//                // 品名
//                Text(tool.name)
//                    .font(.title)
//                    .bold()
//                    .foregroundColor(Color(UIColor.darkGray)) // 使用主題色
//                    .padding(.horizontal)
//                    .padding(.bottom, 30)
//                    .padding(.top, 10)
//                // 用途部分
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("用途：")
//                        .font(.title3)
//                        .bold()
//                        //.foregroundColor(Color(.systemGray)) // 使用主題色來突出標題
//                        .foregroundColor(Color(UIColor.darkGray))
//                        .padding(.horizontal)
//                        .padding(.bottom, 10)
//                    Text(tool.description)
//                        .font(.body)
//                        .foregroundColor(.secondary) // 使用次要顏色，降低文本的視覺優先級
//                        .padding(.horizontal)
//                        .padding(.bottom, 10)
//                    Text("價位：")
//                        .font(.title3)
//                        .bold()
//                       //.foregroundColor(Color(.systemGray)) // 使用主題色來突出標題
//                        .foregroundColor(Color(UIColor.darkGray))
//                        .padding(.horizontal)
//                        .padding(.bottom, 10)
//                    Text(tool.price)
//                        .font(.body)
//                        .foregroundColor(.secondary) // 使用次要顏色
//                        .padding(.horizontal)
//                        .padding(.bottom, 10)
//                    Text("推薦品牌：")
//                        .font(.title3)
//                        .bold()
////                        .foregroundColor(Color(.systemGray)) // 使用主題色來突出標題
//                        .foregroundColor(Color(UIColor.darkGray))
//                        .padding(.horizontal)
//                        .padding(.bottom, 10)
//                    Text(tool.recommend)
//                        .font(.body)
//                        .foregroundColor(.secondary) // 使用次要顏色
//                        .padding(.horizontal)
//                }
//                Spacer() // 將內容往上推，留出下方空間
//            }
//            //.padding() // 整體增加內邊距
//            .background(Color.white) // 添加白色背景
//            .cornerRadius(10) // 添加圓角
//            //.shadow(radius: 5) // 添加陰影以提高視覺層次
//            .navigationTitle("工具詳情")
//            .background(Color(.systemGray6))
//            .ignoresSafeArea()
//        }
//        .background(Color(.systemGray5))
//        .navigationBarBackButtonHidden(true) 
//        .navigationBarItems(leading: Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            HStack {
//                Image(systemName: "chevron.backward").foregroundColor(.black)
//                Text("")
//            }
//        })
//    }
//}
struct IntroToolView: View {
    
    @Environment(\.presentationMode) var presentationMode
    let tool: Tool

    var body: some View {
        ZStack {
//            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // 頂部圖片
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
                        .padding(.top, 50) // 調整返回按鈕距離
                        .padding(.leading, 20)
                    }
                    
                    // 下方藍色區塊
                    VStack(alignment: .leading, spacing: 16) {
                        Text(tool.name)
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top, 15)
                            .padding(.bottom,0)
                        // 增加頂部間距
                        
                        // 價位和推薦品牌部分 - 模仿白色小框樣式
                        HStack(spacing: 40) {
                            VStack {
                                Text("價位")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Divider().padding(.horizontal, 20)
                                Text("$\(tool.price)")
                                    .font(.system(size: 15))
                                    .bold()
                            }
                            .frame(width: 150, height: 100)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            
                            VStack {
                                Text("推薦品牌")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Divider().padding(.horizontal, 20)
                                Text(tool.recommend)
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.center)
                                    .bold()
                            }
                            .frame(width: 150, height: 100)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        
                        // 用途部分
                        VStack(alignment: .leading, spacing: 8) {
                            Text("用途：")
//                                .font(.headline)
                                .font(.custom("LexendDeca-Medium", size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            
                            Text(tool.description)
                                //.font(.body)
                                .font(.custom("LexendDeca-Medium", size: 18))
                                .foregroundColor(.white)
                                //.foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.bottom, 15)
                                .lineSpacing(10)
                            
                            Text("注意事項：")
//                                .font(.headline)
                                .font(.custom("LexendDeca-Medium", size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            ScrollView {
                                Text(tool.careful)
                                //.font(.body)
                                    .font(.custom("LexendDeca-Medium", size: 18))
                                    .foregroundColor(.white)
                                // .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .lineSpacing(10)
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer() // 添加一個 Spacer 來填充空間
                    }
                    .frame(maxWidth: .infinity) // 讓內容寬度自適應螢幕
                    .frame(height: 550)
                    .background(Color.theme) // 設置藍色背景
//                    .background(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.theme, Color.white]), // 設定漸層顏色
//                            startPoint: .top, // 漸層起點
//                            endPoint: .bottom // 漸層終點
//                        )
//                    )
                    .cornerRadius(30) // 只設置上方圓角
                    .padding(.top, -30) // 使卡片稍微往上與圖片疊加
                    
                    
                    
                }
//            }
//            .background(Color(UIColor.darkGray).opacity(0.9)) // 設置背景顏色
//            .ignoresSafeArea()
            ZStack{
                VStack{
                    Spacer()
                    //Rectangle().background(.clear).frame(height: 100)
                }
                Color.white.frame(height: 100).padding(.top,800)
            }
            
        }
        .navigationBarHidden(true) // 隱藏默認導航欄
    }
}


#Preview {
    IntroToolView(tool: sampleTool)
}
