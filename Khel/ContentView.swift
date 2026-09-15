//
//  ContentView.swift
//  Khel
//
//  Created by Joshua Masih on 9/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    
    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingContainerView()
            }
        }
        .environment(appState)
    }
}

#Preview {
    ContentView()
}
