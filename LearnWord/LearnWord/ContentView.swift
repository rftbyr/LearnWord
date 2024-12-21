//
//  ContentView.swift
//  LearnWord
//
//  Created by Rıfat on 28.11.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: page = .card
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PracticeModeView()
                .tabItem {
                    Label("Practice", systemImage: "gamecontroller")
                }
                .tag(page.practice)
            HomeView()
                .tabItem {
                    Label("Cards", systemImage: "square.stack.3d.up")
                }
                .tag(page.card)
            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(page.stats)
        }
    }
    enum page: Hashable {
        case words, card, stats, practice
    }
}
#Preview {
    ContentView()
}
