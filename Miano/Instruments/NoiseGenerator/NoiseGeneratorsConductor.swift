//
//  NoiseGeneratorsConductor.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AudioKit
import AudioKitEX
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI

struct NoiseData {
    var brownianAmplitude: AUValue = 0.0
    var pinkAmplitude: AUValue = 0.0
    var whiteAmplitude: AUValue = 0.0
}

class NoiseGeneratorsConductor: ObservableObject, HasAudioEngine {
    var brown = BrownianNoise()
    var pink = PinkNoise()
    var white = WhiteNoise()
    var mixer = Mixer()

    @Published var data = NoiseData() {
        didSet {
            brown.amplitude = data.brownianAmplitude
            pink.amplitude = data.pinkAmplitude
            white.amplitude = data.whiteAmplitude
        }
    }

    let engine = AudioEngine()

    init() {
        mixer.addInput(brown)
        mixer.addInput(pink)
        mixer.addInput(white)

        brown.amplitude = data.brownianAmplitude
        pink.amplitude = data.pinkAmplitude
        white.amplitude = data.whiteAmplitude
        brown.start()
        pink.start()
        white.start()

        engine.output = mixer
    }

    // Refreshing the visualizer UI
    @Published var running: Int = 0

    func start() {
        running += 1
        try? engine.start()
    }

    func stop() {
        running -= 1
        engine.stop()
    }
}
