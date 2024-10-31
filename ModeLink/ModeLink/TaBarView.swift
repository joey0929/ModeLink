//
//  TabView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/12.
//

import SwiftUI

struct TaBarView: View {
    @State private var selectedTab = 1
    @State private var isShowingARSelection = true
    var body: some View {
        TabView(selection: $selectedTab) {
            ArticleView().tabItem {
                Label("article", systemImage : "house")
            }.tag(1)
            NavigationView {
                if isShowingARSelection {
                    SelectionView(isShowingARSelection: $isShowingARSelection, selectedTab: $selectedTab)
                } else {
                    ARview()
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
        .onChange(of: selectedTab) { newTab in
            if newTab == 2 {
                isShowingARSelection = true
            } else {
                isShowingARSelection = false
            }
        }
    }
}
#Preview {
    TaBarView()
}
