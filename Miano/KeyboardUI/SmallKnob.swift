//
//  SmallKnob.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import Controls
import SwiftUI

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
                Ellipse()
                    .fill(
                        AngularGradient(gradient: Gradient(colors: [
                            .black.opacity(0.8),
                            .black.opacity(0.9),
                            .black.opacity(0.80),
                            .black.opacity(0.75)
                        ]), center: .center)
                    )
                    .background(.gray)
                    .padding(-2)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.125), lineWidth: 2)
                    )
                    .padding(2)

                Rectangle()
                    .foregroundColor(.white.opacity(0.5))
                    .shadow(
                        color: .white.opacity(0.25),
                        radius: 8,
                        x: 6,
                        y: 4
                    )
                    .frame(width: geo.size.width / 20, height: geo.size.height / 4)
                    .rotationEffect(Angle(radians: normalizedValue * 1.6 * .pi + 0.2 * .pi))
                    .offset(x: -sin(normalizedValue * 1.6 * .pi + 0.2 * .pi) * geo.size.width / 2.0 * 0.75,
                            y: cos(normalizedValue * 1.6 * .pi + 0.2 * .pi) * geo.size.height / 2.0 * 0.75)
            }.drawingGroup()
            // Drawing groups improve antialiasing of rotated indicator
        }
        .aspectRatio(
            CGSize(width: 1, height: 1), contentMode: .fit
        )
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

struct SmallKnob_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            SmallKnob(value: .constant(0.25))
                .shadow(radius: 12, y: 8)
            SmallKnob(value: .constant(0.5))
                .shadow(radius: 12, y: 8)
        }
        .padding()
        .background(.black)
        .ignoresSafeArea()
    }
}
