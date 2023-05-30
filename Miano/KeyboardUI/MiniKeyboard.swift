//
//  MiniKeyboard.swift
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

struct MiniKeyboard: View {
    @EnvironmentObject var conductor: InstrumentEXSConductor

    @State var octaveRange = 1
    @State var layoutType = 0

    @State var lowestNote = 48
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

struct MiniKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        MiniKeyboard()
            .environmentObject(InstrumentEXSConductor())
    }
}
