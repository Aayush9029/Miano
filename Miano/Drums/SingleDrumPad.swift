//
//  SingleDrumPad.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

struct SingleDrumPad: View {
    @State private var hovering: Bool = false
    let drumpad: DrumSample

    var body: some View {
        ZStack {
            Rectangle()
                .fill(
                    .gray.opacity(0.125)
                        .shadow(
                            .inner(color: drumpad.color, radius: hovering ? 32 : 256)
                        )
                        .shadow(
                            .inner(color: drumpad.color.opacity(0.5), radius: hovering ? 64 : 1024)
                        )
                )
                .blur(radius: hovering ? 12 : 24)
                .saturation(hovering ? 3 : 2)

                .shadow(
                    color: drumpad.color, radius: 3
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(drumpad.color.opacity(hovering ? 1 : 0.5), lineWidth: 2)
                )

            Text(drumpad.name)
                .bold()
                .foregroundColor(drumpad.color)
                .brightness(0.5)
        }
        .onHover { state in
            withAnimation {
                hovering = state
            }
        }
    }
}

struct SingleDrumPad_Previews: PreviewProvider {
    static var previews: some View {
        SingleDrumPad(drumpad: DrumSample("KICK", file: "bass_drum_C1.wav", note: 24, .mint))
            .padding()
            .background(.black)
    }
}
