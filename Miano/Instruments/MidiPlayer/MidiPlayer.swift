//
//  MidiPlayer.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AudioKit
import AudioKitEX
import AudioKitUI
import SwiftUI

// MARK: - it's buggin on a stack on my mac will retire it

struct MidiPlayer: View {
    @StateObject var viewModel = MIDITrackViewModel()
    @State var fileURL: URL
    @State var isPlaying = false

    init() {
        viewModel.startEngine()
        fileURL = Bundle.main.url(forResource: "Demo", withExtension: "mid")!
        viewModel.loadSequencerFile(fileURL: fileURL)
    }

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    if let fileURL = fileURL {
                        ForEach(
                            MIDIFile(url: fileURL).tracks.indices, id: \.self
                        ) { number in
                            VStack {
                                Text("\(number)")
                                MIDITrackView(fileURL: $fileURL,
                                              trackNumber: number,
                                              trackWidth: geometry.size.width,
                                              trackHeight: 220.0)
                                    .background(.white.opacity(0.25))

                                    .cornerRadius(10.0)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onTapGesture {
            isPlaying.toggle()
        }
        .onChange(of: isPlaying, perform: { newValue in
            if newValue == true {
                viewModel.play()
            } else {
                viewModel.stop()
            }
        })
        .onDisappear(perform: {
            viewModel.stop()
            viewModel.stopEngine()
        })
        .environmentObject(viewModel)
    }
}

struct MidiPlayer_Previews: PreviewProvider {
    static var previews: some View {
        MidiPlayer()
    }
}
