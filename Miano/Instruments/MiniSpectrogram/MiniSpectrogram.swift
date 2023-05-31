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

    init(_ mode: Mode) {
        self.mode = mode
    }

    var body: some View {
        SpectrogramView(audioSpectrogram: audioSpectrogram, mode)
            .environmentObject(audioSpectrogram)
            .onAppear(perform: {
                audioSpectrogram.startRunning()
            })
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    Task(priority: .userInitiated) {
                        audioSpectrogram.startRunning()
                    }
                }
            }

            .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { _ in
                audioSpectrogram.stopRunning()
            }
    }
}

struct MiniSpectrogram_Previews: PreviewProvider {
    static var previews: some View {
        MiniSpectrogram(.linear)
    }
}
