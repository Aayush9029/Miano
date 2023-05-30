//
//  InstrumentSelection.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

struct InstrumentSelection: View {
    @State private var selectedInstrument: InstrumentModel

    init() {
        self.selectedInstrument = .firstInstrument
    }

    var body: some View {
        NavigationSplitView {
            InstrumentsSidebar(selected: $selectedInstrument)
        } detail: {
            InstrumentDetailView(instrument: selectedInstrument)
        }
    }
}

struct SingleInstrumentSelector: View {
    @State private var hovered: Bool = false

    @Binding var selectedInstrument: InstrumentModel
    let instrument: InstrumentModel

    var selected: Bool {
        selectedInstrument == instrument
    }

    var body: some View {
        VStack {
            VStack {
                Image(instrument.image)
                    .resizable()
                    .scaledToFit()
                    .saturation((hovered || selected) ? 1.25 : 0.5)
                    .cornerRadius(8)

                Text(instrument.name)
                    .foregroundColor(.white.opacity((hovered || selected) ? 1 : 0.5))
            }
            .padding(6)
            .background(
                .gray.gradient.opacity(hovered ? 0.25 : 0.125)
            )
            .background(selectedInstrument == instrument ? .blue : .clear)
            .cornerRadius(12)
            .overlay(
                Group {
                    if selected {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                .white,
                                lineWidth: 2
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                .gray.opacity(hovered ? 0.5 : 0.25),
                                lineWidth: 2
                            )
                    }
                }
            )
            .onHover { state in
                withAnimation {
                    hovered = state
                }
            }
        }
        .padding(4)
        .containerShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            selectedInstrument = instrument
        }
        .preferredColorScheme(.dark)
    }
}

struct InstrumentSelection_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentSelection()
            .frame(minWidth: 480, minHeight: 540)
            .cornerRadius(12)
            .padding()
    }
}
