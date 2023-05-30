//
//  MianoApp.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

@main
struct MianoApp: App {
//    @Environment(\.scenePhase) private var scenePhase
//    let audioSpectrogram = AudioSpectrogram()

    var body: some Scene {
        WindowGroup {
            InstrumentSelection()
//            SpectrogramView(audioSpectrogram: audioSpectrogram, .mel)
//                .environmentObject(audioSpectrogram)
        }
//        .onChange(of: scenePhase) { phase in
//            if phase == .active {
//                Task(priority: .userInitiated) {
//                    audioSpectrogram.startRunning()
//                }
//            }
//        }
        .windowStyle(.hiddenTitleBar)
//        .windowResizability(.contentSize)
    }
}
