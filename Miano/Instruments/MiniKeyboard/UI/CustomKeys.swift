//
//  CustomKeys.swift
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

struct CustomKeys: View {
    @EnvironmentObject var conductor: InstrumentEXSConductor

    @State var octaveRange = 0
    @Binding var layoutFloat: Float // 0.1...3 (1, 2, 3)
    var layoutType: Int {
        Int(layoutFloat * 10)
    }

    @Binding var customPitch: Int
    var lowestNote: Int {
        customPitch * 12
    }

    var hightestNote: Int {
        (octaveRange + 1) * 12 + lowestNote
    }

    var layout: KeyboardLayout {
        let pitchRange = Pitch(intValue: lowestNote) ... Pitch(intValue: hightestNote)
        if layoutType == 0 {
            return .piano(pitchRange: pitchRange)
        } else if layoutType == 1 {
            return .isomorphic(pitchRange: pitchRange)
        } else {
            return .guitar()
        }
    }

    var body: some View {
        Keyboard(
            layout: layout,
            noteOn: conductor.noteOn,
            noteOff: conductor.noteOff
        )
    }
}

struct CustomKeys_Previews: PreviewProvider {
    static var previews: some View {
        CustomKeys(
            layoutFloat: .constant(0.1),
            customPitch: .constant(2)
        )
        .environmentObject(InstrumentEXSConductor())
    }
}
