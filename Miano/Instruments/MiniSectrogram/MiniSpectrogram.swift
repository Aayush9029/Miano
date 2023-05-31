//
//  MiniSpectrogram.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

struct MiniSpectrogram: View {
    @Environment(\.scenePhase) private var scenePhase
    let audioSpectrogram = AudioSpectrogram()
    let mode: Mode

    var body: some View {
        SpectrogramView(audioSpectrogram: audioSpectrogram, .mel)
            .environmentObject(audioSpectrogram)

            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    Task(priority: .userInitiated) {
                        audioSpectrogram.startRunning()
                    }
                }
            }
    }
}

struct MiniSpectrogram_Previews: PreviewProvider {
    static var previews: some View {
        MiniSpectrogram(mode: .linear)
    }
}
