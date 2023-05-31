//
//  NoiseGenerator.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import Controls
import SoundpipeAudioKit
import SwiftUI

struct NoiseGenerator: View {
    @Environment(\.controlActiveState) private var controlActiveState
    @StateObject var conductor = NoiseGeneratorsConductor()

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Miano")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("Made by Aayush")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.vertical)

                Spacer()

                VStack {
                    SmallKnob(value: $conductor.data.brownianAmplitude, strokeColor: .brown.opacity(0.5))

                        .frame(width: 60)
                }
                VStack {
                    SmallKnob(value: $conductor.data.pinkAmplitude, strokeColor: .pink.opacity(0.5))
                        .frame(width: 60)
                }
                VStack {
                    SmallKnob(value: $conductor.data.whiteAmplitude, strokeColor: .white.opacity(0.5))
                        .frame(width: 60)
                }
            }
            NodeOutputView(conductor.mixer)
                .id(conductor.running)
                .padding(.horizontal, -24)
                .ignoresSafeArea()
        }
        .padding()
        .background(.black)
        .ignoresSafeArea()
        .frame(minWidth: 480, minHeight: 200)
        .onAppear {
            conductor.start()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { _ in
            print("close")
            conductor.stop()
        }

        .onChange(of: controlActiveState) { phase in
            if phase == .active || phase == .key {
                conductor.start()
            }
        }
    }
}

struct NoiseGenerator_Previews: PreviewProvider {
    static var previews: some View {
        NoiseGenerator()
            .cornerRadius(12)
            .padding()
    }
}
