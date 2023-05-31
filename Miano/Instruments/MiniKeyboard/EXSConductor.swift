//
//  EXSConductor.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AudioKit
import AudioKitUI
import AVFoundation
import Keyboard
import SwiftUI
import Tonic

class InstrumentEXSConductor: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    var instrument = MIDISampler(name: "Instrument 1")

    func noteOn(pitch: Pitch, point _: CGPoint) {
        print("Playing \(pitch.midiNoteNumber)")
        instrument.play(noteNumber: MIDINoteNumber(pitch.midiNoteNumber), velocity: 90, channel: 0)
    }

    func noteOff(pitch: Pitch) {
        print("Stopping \(pitch.midiNoteNumber)")
        instrument.stop(noteNumber: MIDINoteNumber(pitch.midiNoteNumber), channel: 0)
    }

    init() {
        engine.output = instrument

        do {
            try engine.start()
        } catch {
            Log("AudioKit did not start!")
        }
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
