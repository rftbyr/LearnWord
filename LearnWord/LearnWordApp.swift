//
//  LearnWordApp.swift
//  LearnWord
//
//  Created by Rıfat on 28.11.2024.
//

import SwiftUI
import TipKit

@main
struct LearnWordApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    init(){
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
            } else {
                OnboardingView()
            }
        }
    }
}
