//
//  InstrumentsSidebar.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

struct InstrumentsSidebar: View {
    @Binding var selected: InstrumentModel

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Miano")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("Made by Aayush")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
                LazyVGrid(columns: columns) {
                    ForEach(InstrumentModel.allInstruments) { instrument in
                        SingleInstrumentSelector(selectedInstrument: $selected, instrument: instrument)
                    }
                }
            }
            .cornerRadius(12)
            .padding([.horizontal, .top])

        }.frame(minWidth: 200)
    }
}

struct InstrumentsSidebar_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentsSidebar(
            selected: .constant(.firstInstrument)
        )
    }
}
