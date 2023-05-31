//
//  VocalTrack.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AudioKit
import AudioKitEX
import AudioKitUI
import AudioToolbox
import Combine
import SoundpipeAudioKit
import SwiftUI

struct VocalTractView: View {
    @Environment(\.controlActiveState) private var controlActiveState
    @StateObject var conductor = VocalTractConductor()

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
                Button {
                    conductor.voc.frequency = AUValue.random(in: 0 ... 2000)
                    conductor.voc.tonguePosition = AUValue.random(in: 0 ... 1)
                    conductor.voc.tongueDiameter = AUValue.random(in: 0 ... 1)
                    conductor.voc.tenseness = AUValue.random(in: 0 ... 1)
                    conductor.voc.nasality = AUValue.random(in: 0 ... 1)
                } label: {
                    Label("Randomize", systemImage: "die.face.\(Int.random(in: 1 ... 6))")
                        .labelStyle(.iconOnly)
                }
                .font(.title2)
                .buttonStyle(.plain)

                Button {
                    conductor.isPlaying.toggle()
                } label: {
                    Group {
                        if conductor.isPlaying {
                            Label("Stop", systemImage: "stop")
                        } else {
                            Label("Play", systemImage: "play")
                        }
                    }
                    .labelStyle(.iconOnly)
                }
                .font(.title2)
                .buttonStyle(.plain)
            }

            HStack {
                ForEach(conductor.voc.parameters) {
                    ParameterRow(param: $0)
                }
            }.frame(height: 150)
            NodeOutputView(conductor.voc)
                .padding(.horizontal, -12)
                .id(conductor.isPlaying)
        }
        .padding()
        .background(.black)
        .ignoresSafeArea()
        .frame(minHeight: 300)

        .onChange(of: controlActiveState) { phase in
            if phase == .active || phase == .key {
                conductor.start()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { _ in
            print("close")
            conductor.isPlaying = false
            conductor.stop()
        }
    }
}

struct VocalTrackVie_Previews: PreviewProvider {
    static var previews: some View {
        VocalTractView()
            .cornerRadius(12)
            .padding()
    }
}

import AudioKit
import Controls
import CoreMIDI
import SwiftUI

/// Hack to get SwiftUI to poll and refresh our UI.
class Refresher: ObservableObject {
    @Published var version = 0
}

public struct ParameterRow: View {
    var param: NodeParameter
    @StateObject var refresher = Refresher()

    public init(param: NodeParameter) {
        self.param = param
    }

    func floatToDoubleRange(_ floatRange: ClosedRange<Float>) -> ClosedRange<Double> {
        Double(floatRange.lowerBound) ... Double(floatRange.upperBound)
    }

    func getBinding() -> Binding<Float> {
        Binding(
            get: { param.value },
            set: { param.value = $0; refresher.version += 1 }
        )
    }

    func getIntBinding() -> Binding<Int> {
        Binding(get: { Int(param.value) }, set: { param.value = AUValue($0); refresher.version += 1 })
    }

    func intValues() -> [Int] {
        Array(Int(param.range.lowerBound) ... Int(param.range.upperBound))
    }

    public var body: some View {
        VStack(alignment: .center) {
            VStack {
                HStack {
                    Spacer()
                    Text(param.def.name)
                        .font(.callout)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
            .frame(height: 50)
            switch param.def.unit {
            case .boolean:
                Toggle(isOn: Binding(get: { param.value == 1.0 }, set: {
                    param.value = $0 ? 1.0 : 0.0; refresher.version += 1
                }), label: { Text(param.def.name) })
            case .indexed:
                if param.range.upperBound - param.range.lowerBound < 5 {
                    Picker(param.def.name, selection: getIntBinding()) {
                        ForEach(intValues(), id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                } else {
                    SmallKnob(value: getBinding(), range: param.range)
                        .frame(width: 64)
                }
            default:
                SmallKnob(value: getBinding(), range: param.range)
                    .frame(width: 64)
            }
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
