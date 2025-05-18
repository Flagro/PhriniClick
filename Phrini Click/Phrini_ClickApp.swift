//
//  Phrini_ClickApp.swift
//  Phrini Click
//
//  Created by Anton Potapov on 16.3.25..
//

import SwiftUI
import AVFoundation

@main
struct Phrini_ClickApp: App {

    init() {
        _ = SoundManager.shared      // ← forces eager initialisation & priming
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
