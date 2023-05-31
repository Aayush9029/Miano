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
            InstrumentSelection()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

//        MARK: - Instrument Windows

        Window(.linearSpectrogram) {
            MiniSpectrogram(.linear)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        Window(.melSpectrogram) {
            MiniSpectrogram(.mel)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        Window(.miniDrums) {
            MiniDrumPad()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        Window(.miniKeyboard) {
            MiniKeyboard()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        Window(.pitchFinder) {
            MiniTuner()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        Window(.vocals) {
            VocalTractView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)

        Window(.whiteNoise) {
            NoiseGenerator()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

internal extension Window {
    init(_ instrument: InstrumentType, @ViewBuilder content: () -> Content) {
        self.init(instrument.rawValue, id: instrument.rawValue, content: content)
    }
}
