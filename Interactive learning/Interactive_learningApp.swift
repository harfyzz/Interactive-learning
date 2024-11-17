//
//  Interactive_learningApp.swift
//  Interactive learning
//
//  Created by Afeez Yunus on 31/10/2024.
//

import SwiftUI

@main
struct Interactive_learningApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(climber: character.shared.riveImage,mainButton: character.shared.mainButton)
        }
    }
}
