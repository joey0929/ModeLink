//
//  TabView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/12.
//

import SwiftUI

struct TaBarView: View {
    var body: some View {
        
        TabView {
            
//            View().tabItem()
            ArticleView().tabItem {
                Label("article",systemImage: "character")
            }.tag(1)
            ARview().tabItem {
                Label("scanner",systemImage:"camera.viewfinder")
            }.tag(2)
            
            IntroView().tabItem {
                Label("Intro",systemImage:"bold")
            }.tag(3)
            MapView().tabItem {
                Label("map",systemImage:"map")
            }.tag(4)
            
        }
        
        
    }
}

#Preview {
    TaBarView()
}
