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
            ArticleView().tabItem {
                Label("article", systemImage:"house")
            }.tag(1)
            ARview().tabItem {
                Label("scanner", systemImage: "camera.viewfinder")
            }.tag(2)
            ModelListView().tabItem {
                Label("Model", systemImage: "square.and.arrow.down")
            }.tag(3)
            IntroView().tabItem {
                Label("Intro", systemImage: "lightbulb.circle")
            }.tag(4)
            MapView().tabItem {
                Label("map", systemImage: "map")
            }.tag(5)
            
        }
    }
}

#Preview {
    TaBarView()
}
