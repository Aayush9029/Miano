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
    var instrument = MIDISampler(name: "Instrument 2")

    func noteOn(pitch: Pitch, point _: CGPoint) {
        instrument.play(noteNumber: MIDINoteNumber(pitch.midiNoteNumber), velocity: 90, channel: 0)
    }

    func noteOff(pitch: Pitch) {
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
}
