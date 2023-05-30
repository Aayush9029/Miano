//
//  MianoApp.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

@main
struct MianoApp: App {
    var body: some Scene {
        WindowGroup {
            MiniTuner()
        }

        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
