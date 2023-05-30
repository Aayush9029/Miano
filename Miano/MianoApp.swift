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
            ContentView()
                .ignoresSafeArea()
                .frame(maxWidth: 720, maxHeight: 280)
        }

        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
