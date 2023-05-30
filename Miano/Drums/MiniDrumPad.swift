//
//  MiniDrumPad.swift
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

struct MiniDrumPad: View {
    @StateObject var conductor = DrumsConductor()
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Miano by Aayush")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                PadsView(conductor: conductor) { pad in
                    conductor.playPad(padNumber: pad)
                }

            }.padding(8)
                .background(.black)

                .onAppear {
                    conductor.start()
                }
                .onDisappear {
                    conductor.stop()
                }
        }
        .ignoresSafeArea()
        .frame(minWidth: 360, maxWidth: 512, minHeight: 280, maxHeight: 460)
    }
}

struct MiniDrumPad_Previews: PreviewProvider {
    static var previews: some View {
        MiniDrumPad()
            .padding()
    }
}

struct DrumSample {
    var name: String
    var fileName: String
    var midiNote: Int
    var audioFile: AVAudioFile?
    var color: Color

    init(_ prettyName: String, file: String, note: Int, _ drumColor: Color = Color.red) {
        name = prettyName
        fileName = file
        midiNote = note
        color = drumColor

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
            DrumSample("OPEN HI HAT", file: "open_hi_hat_A#1.wav", note: 34, .red),
            DrumSample("HI TOM", file: "hi_tom_D2.wav", note: 38, .blue),
            DrumSample("MID TOM", file: "mid_tom_B1.wav", note: 35, .green),
            DrumSample("LO TOM", file: "lo_tom_F1.wav", note: 29, .orange),
            DrumSample("HI HAT", file: "closed_hi_hat_F#1.wav", note: 30, .teal),
            DrumSample("CLAP", file: "clap_D#1.wav", note: 27, .pink),
            DrumSample("SNARE", file: "snare_D1.wav", note: 26, .indigo),
            DrumSample("KICK", file: "bass_drum_C1.wav", note: 24, .mint),
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
}

struct PadsView: View {
    var conductor: DrumsConductor

    var padsAction: (_ padNumber: Int) -> Void
    @State var downPads: [Int] = []

    var body: some View {
        VStack(spacing: 0) {
            NodeOutputView(conductor.drums)
                .padding(.horizontal, -24)
            ForEach(0 ..< 2, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0 ..< 4, id: \.self) { column in
                        ZStack {
                            SingleDrumPad(drumpad: conductor.drumSamples.map { $0 }[getPadID(row: row, column: column)])
                                .padding(6)
                        }
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { _ in
                            if !(downPads.contains(where: { $0 == row * 4 + column })) {
                                padsAction(getPadID(row: row, column: column))
                                downPads.append(row * 4 + column)
                            }
                        }.onEnded { _ in
                            downPads.removeAll(where: { $0 == row * 4 + column })
                        })
                    }
                }
            }
        }
    }
}

private func getPadID(row: Int, column: Int) -> Int {
    return (row * 4) + column
}
