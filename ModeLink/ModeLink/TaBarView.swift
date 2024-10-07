//
//  TabView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/12.
//

import SwiftUI

struct TaBarView: View {
    @State private var selectedTab = 1 // record the selected tab item
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ArticleView().tabItem {
                Label("article", systemImage : "house")
            }.tag(1)
            ARview().tabItem {
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
        //.background(selectedTab == 2 ? .white : .white)
        .onAppear {
            //customizeTabBarAppearance() // 自定義 TabBar 外觀
            updateTabBarAppearance()
        }
        .onChange(of: selectedTab) { _ in
            updateTabBarAppearance()
        }
        
        
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
            //UITabBar.appearance().isTranslucent = true
        } else {
            // 否則設為白色
            UITabBar.appearance().backgroundColor = UIColor.white
            //UITabBar.appearance().isTranslucent = false
        }
    }
    
    
    
}
#Preview {
    TaBarView()
}
