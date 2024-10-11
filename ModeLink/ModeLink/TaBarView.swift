//
//  TabView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/12.
//

import SwiftUI

struct TaBarView: View {
    @State private var selectedTab = 1 // record the selected tab item
    @State private var isShowingARSelection = true // 用於控制是否顯示 ARView 的選擇畫面
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ArticleView().tabItem {
                Label("article", systemImage : "house")
            }.tag(1)
//            ARview().tabItem {
//                Label("scanner", systemImage : "camera.viewfinder")
//            }.tag(2).background(.clear)
            
            // AR Scanner 頁面
            NavigationView {
                if isShowingARSelection {
                    SelectionView(isShowingARSelection: $isShowingARSelection, selectedTab: $selectedTab) // 顯示選擇畫面
                } else {
                    ARview() // 當按鈕被點擊後進入 ARView
                }
            }
            .tabItem {
                Label("scanner", systemImage : "camera.viewfinder")
            }.tag(2)        
            ModelListView().tabItem {
                Label("Model", systemImage : "square.and.arrow.down")
            }.tag(3)
            IntroView().tabItem {
                Label("Intro", systemImage : "lightbulb.circle")
            }.tag(4)
            MapView().tabItem {
                Label("map", systemImage : "map")
            }.tag(5)
        }
        
        .accentColor(selectedTab == 2 ? .red : .blue) // 根據當前選中的頁面設置選中項目顏色
        .onChange(of: selectedTab) { newTab in
            if newTab == 2 {
                // 當再次選中 AR tab 時，重置顯示狀態為選擇畫面
                isShowingARSelection = true
            } else {
                // 當切換到其他 tab 時，隱藏 AR 選擇畫面
                isShowingARSelection = false
            }
        }
        //.background(selectedTab == 2 ? .white : .white)
//        .onAppear {
//            //customizeTabBarAppearance() // 自定義 TabBar 外觀
//           // updateTabBarAppearance()
//        }
//        .onChange(of: selectedTab) { _ in
//            updateTabBarAppearance()
//        }
    }
    // 自定義 TabBar 外觀
    func customizeTabBarAppearance() {
        // 修改背景色
//        UITabBar.appearance().barTintColor = UIColor.white
        // 設定未選中項目的顏色
        UITabBar.appearance().backgroundColor = UIColor.white
       // UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        // 禁用透明效果
        //UITabBar.appearance().isTranslucent = false
        // 修改未選中項目的顏色

    }
    
    func updateTabBarAppearance() {
        if selectedTab == 2 {
            // 如果選中 ARView，將 TabBar 設為透明
            UITabBar.appearance().backgroundColor = UIColor.clear
            UITabBar.appearance().isTranslucent = true
        } else {
            // 否則設為白色
            UITabBar.appearance().backgroundColor = UIColor.white
           // UITabBar.appearance().isTranslucent = false
        }
    }
}
#Preview {
    TaBarView()
}
