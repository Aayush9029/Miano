//
//  MiniTuner.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import SoundpipeAudioKit
import SwiftUI

struct MiniTuner: View {
    @StateObject var conductor = TunerConductor()
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    NodeFFTView(conductor.tappableNodeC)
                        .blur(radius: 12)
                        .hueRotation(Angle(degrees: Double(conductor.tracker.amplitude) * 50))
                        .ignoresSafeArea()

                    HStack {
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(conductor.data.pitch, specifier: "%0.1f")")
                                    .font(.largeTitle)
                                    .bold()
                                Spacer()
                            }
                            Text("Frequency")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)

                        VStack {
                            HStack {
                                Spacer()
                                Text("\(conductor.data.amplitude, specifier: "%0.1f")")
                                    .font(.largeTitle)
                                    .bold()
                                Spacer()
                            }
                            Text("Amplitude")
                                .foregroundStyle(.secondary)
                        }.padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)

                        VStack {
                            HStack {
                                Spacer()
                                Text("\(conductor.data.noteNameWithSharps) / \(conductor.data.noteNameWithFlats)")
                                    .font(.largeTitle)
                                    .bold()
                                Spacer()
                            }
                            Text("Note Name")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                NodeRollingView(conductor.tappableNodeA)

                NodeRollingView(conductor.tappableNodeB)
            }
            InputDevicePicker(device: conductor.initialDevice)
                .padding()
        }
        .background(.black)

        .frame(minWidth: 600, minHeight: 320)
        .onAppear {
            conductor.start()
        }
        .onDisappear {
            conductor.stop()
        }
    }
}

struct MiniTuner_Previews: PreviewProvider {
    static var previews: some View {
        MiniTuner()
            .cornerRadius(12)
            .padding()
    }
}

struct InputDevicePicker: View {
    @State var device: Device

    var body: some View {
        Picker("**Input Device**", selection: $device) {
            ForEach(getDevices(), id: \.self) {
                Text("\($0.name)")
            }
        }
        .pickerStyle(.menu)
        .onChange(of: device, perform: setInputDevice)
    }

    func getDevices() -> [Device] {
        return AudioEngine.inputDevices.compactMap { $0 }
    }

    func setInputDevice(to device: Device) {
        do {
            try AudioEngine().setDevice(device)
        } catch let err {
            print(err)
        }
    }
}
