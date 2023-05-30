//
//  ContentView.swift
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

struct ContentView: View {
    @State private var pitch: Float = 0.25
    @StateObject var conductor: InstrumentEXSConductor = .init()
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Miano")
                            .font(.largeTitle.bold())
                        Text("Made in Canada")
                            .font(.caption)
                    }
                    .foregroundColor(.black.opacity(0.5))

                    HStack {
                        Circle()
                            .frame(width: 6)
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 4)
                        Spacer()
                        Circle()
                            .frame(width: 6)
                            .foregroundColor(.black.opacity(0.5))
                        Spacer()
                        Circle()
                            .frame(width: 6)
                            .foregroundColor(.black.opacity(0.5))
                        Spacer()
                    }
                    .frame(width: 100)
                }

                Spacer()

                HStack {
                    SmallKnob(value: $pitch)
                        .frame(width: 60)
                        .shadow(radius: 12, y: 10)

                    SmallKnob(value: $pitch)
                        .frame(width: 60)
                        .shadow(radius: 12, y: 10)

                    SmallKnob(value: $pitch)
                        .frame(width: 60)
                        .shadow(radius: 12, y: 10)
                }

                NodeOutputView(conductor.instrument)
//                    .overlay(content: {
//                        Color.green
//                            .blendMode(.color)
//                    })
//                Rectangle()
//                    .fill(.black)
                    .frame(width: 120, height: 80)
                    .cornerRadius(12)

                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(radius: 4, y: 2)
            }
            HStack {
                VStack(spacing: 0) {
                    VStack {
                        Spacer()
                        Label("Increase Pitch", systemImage: "triangle.fill")

                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    .frame(width: 12)
                    .padding()
                    .background(.white)

                    Divider().frame(width: 12)
                    VStack {
                        Spacer()
                        Label("Decrease Pitch", systemImage: "arrowtriangle.down.fill")

                            .foregroundStyle(.gray)

                        Spacer()
                    }
                    .frame(width: 12)
                    .padding()
                    .background(.white)
                }
                .labelStyle(.iconOnly)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 2)
                )
                MiniKeyboard()
//                Rectangle()
//                    .fill(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.black.opacity(1), lineWidth: 2)
                    )
                    .shadow(radius: 8, y: 4)
                    .environmentObject(conductor)
            }
            .frame(height: 200)
        }
        .padding()
        .background(.gray)
        .cornerRadius(12)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(InstrumentEXSConductor())
            .padding()
    }
}

import Controls

/// Knob in which you start by tapping in its bound and change the value by either horizontal or vertical motion
public struct SmallKnob: View {
    @Binding var value: Float
    var range: ClosedRange<Float> = 0.0 ... 1.0

    var backgroundColor: Color = .white
    var foregroundColor: Color = .black.opacity(0.5)

    /// Initialize the knob with a bound value and range
    /// - Parameters:
    ///   - value: value being controlled
    ///   - range: range of the value
    public init(value: Binding<Float>, range: ClosedRange<Float> = 0.0 ... 1.0) {
        _value = value
        self.range = range
    }

    var normalizedValue: Double {
        Double((value - range.lowerBound) / (range.upperBound - range.lowerBound))
    }

    public var body: some View {
        Control(value: $value, in: range,
                geometry: .twoDimensionalDrag(xSensitivity: 1, ySensitivity: 1))
        { geo in
            ZStack(alignment: .center) {
                Ellipse().foregroundColor(backgroundColor)
                Rectangle().foregroundColor(foregroundColor)
                    .frame(width: geo.size.width / 20, height: geo.size.height / 4)
                    .rotationEffect(Angle(radians: normalizedValue * 1.6 * .pi + 0.2 * .pi))
                    .offset(x: -sin(normalizedValue * 1.6 * .pi + 0.2 * .pi) * geo.size.width / 2.0 * 0.75,
                            y: cos(normalizedValue * 1.6 * .pi + 0.2 * .pi) * geo.size.height / 2.0 * 0.75)
            }.drawingGroup() // Drawing groups improve antialiasing of rotated indicator
        }
        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
    }
}

public extension SmallKnob {
    /// Modifier to change the background color of the knob
    /// - Parameter backgroundColor: background color
    func backgroundColor(_ backgroundColor: Color) -> SmallKnob {
        var copy = self
        copy.backgroundColor = backgroundColor
        return copy
    }

    /// Modifier to change the foreground color of the knob
    /// - Parameter foregroundColor: foreground color
    func foregroundColor(_ foregroundColor: Color) -> SmallKnob {
        var copy = self
        copy.foregroundColor = foregroundColor
        return copy
    }
}
