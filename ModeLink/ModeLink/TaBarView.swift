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
            }
            ARview().tabItem {
                Label("scanner",systemImage:"scanner")
            }.tag(1)
            
            IntroView().tabItem {
                Label("Intro",systemImage:"bold")
            }.tag(1)
            MapView().tabItem {
                Label("map",systemImage:"map")
            }.tag(1)
            
        }
        
        
    }
}

#Preview {
    TaBarView()
}
