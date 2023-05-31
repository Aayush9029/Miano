//
//  DrumsConductor.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AudioKit
import AudioKitEX
import AudioKitUI
import AVFoundation
import Combine
import SwiftUI

struct DrumSample {
    var name: String
    var fileName: String
    var midiNote: Int
    var audioFile: AVAudioFile?
    var color: Color
    var key: KeyEquivalent

    init(_ prettyName: String, file: String, note: Int, _ drumColor: Color = Color.red, keyboardKey: KeyEquivalent) {
        name = prettyName
        fileName = file
        midiNote = note
        color = drumColor
        key = keyboardKey

        guard let url = Bundle.main.resourceURL?.appendingPathComponent(file) else { return }

        do {
            audioFile = try AVAudioFile(forReading: url)
        } catch {
            Log("Could not load: \(fileName)")
        }
    }
}

class DrumsConductor: ObservableObject, HasAudioEngine {
    // Mark Published so View updates label on changes
    @Published private(set) var lastPlayed: String = "None"

    let engine = AudioEngine()

    let drumSamples: [DrumSample] =
        [
            DrumSample(
                "OPEN HI HAT", file: "open_hi_hat_A#1.wav",
                note: 34, .pink,
                keyboardKey: "t"
            ),
            DrumSample(
                "HI TOM", file: "hi_tom_D2.wav",
                note: 38, .orange,
                keyboardKey: "y"
            ),
            DrumSample(
                "MID TOM", file: "mid_tom_B1.wav",
                note: 35, .orange,
                keyboardKey: "u"
            ),
            DrumSample(
                "LO TOM", file: "lo_tom_F1.wav",
                note: 29, .orange,
                keyboardKey: "i"
            ),
            DrumSample(
                "HI HAT", file: "closed_hi_hat_F#1.wav",
                note: 30, .pink,
                keyboardKey: "g"
            ),
            DrumSample(
                "CLAP", file: "clap_D#1.wav",
                note: 27, .blue,
                keyboardKey: "h"
            ),
            DrumSample(
                "SNARE", file: "snare_D1.wav",
                note: 26, .indigo,
                keyboardKey: "j"
            ),
            DrumSample(
                "KICK", file: "bass_drum_C1.wav",
                note: 24, .mint,
                keyboardKey: "k"
            ),
        ]

    let drums = AppleSampler()

    func playPad(padNumber: Int) {
        drums.play(noteNumber: MIDINoteNumber(drumSamples[padNumber].midiNote))
        let fileName = drumSamples[padNumber].fileName
        lastPlayed = fileName.components(separatedBy: "/").last!
    }

    init() {
        engine.output = drums
        do {
            let files = drumSamples.map {
                $0.audioFile!
            }
            try drums.loadAudioFiles(files)

        } catch {
            Log("Files Didn't Load")
        }
    }

    // Refreshing the visualizer UI
    @Published var running: Int = 0

    func start() {
        print("RUNNING INSTANCES \(running)")
        running += 1
        try? engine.start()
    }

    func stop() {
        running -= 1
    }
}
