//
//  SpectrogramView.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

struct SpectrogramView: View {
    @ObservedObject var audioSpectrogram: AudioSpectrogram

    init(audioSpectrogram: AudioSpectrogram, _ mode: Mode) {
        self.audioSpectrogram = audioSpectrogram

        self.audioSpectrogram.mode = mode
    }

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Image(decorative: audioSpectrogram.outputImage,
                      scale: 1,
                      orientation: .left)
                    .resizable()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Miano")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        Text("Made by Aayush")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding()
                    Spacer()
                    VStack {
                        HStack {
                            CustomSlider(value: $audioSpectrogram.gain, range: 0.01 ... 0.04)

                            Text("Gain")
                                .frame(width: 64)
                                .foregroundStyle(.secondary)
                        }

                        HStack {
                            CustomSlider(value: $audioSpectrogram.zeroReference, range: 10 ... 2500)

                            Text("Zero Ref")
                                .frame(width: 64)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 320)
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .frame(minWidth: 640, minHeight: 320)
        .background(.black)
        .ignoresSafeArea()
    }
}

struct LinearSpectrogramView_Previews: PreviewProvider {
    static var previews: some View {
        SpectrogramView(audioSpectrogram: AudioSpectrogram(), .linear)
    }
}

struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let color: Color
    let height: CGFloat = 12

    init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        color: Color = .white
    ) {
        self._value = value
        self.range = range
        self.color = color
    }

    var body: some View {
        HStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(color.opacity(0.5))
                        .opacity(0.25)
                        .frame(width: geometry.size.width)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * (geometry.size.width))
                        .foregroundColor(color)
                        .opacity(0.3)
                }
                .frame(width: geometry.size.width)

                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gestureValue in
                            let newValue = Double((gestureValue.location.x - height / 2) / (geometry.size.width - height)) * (range.upperBound - range.lowerBound) + range.lowerBound
                            value = min(max(range.lowerBound, newValue), range.upperBound)
                        }
                )
            }
            .frame(height: height)
            .cornerRadius(24)
        }
    }
}
