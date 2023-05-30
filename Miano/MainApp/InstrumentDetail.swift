//
//  InstrumentDetailView.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

struct InstrumentDetailView: View {
    let instrument: InstrumentModel

    var body: some View {
        ScrollView(.vertical) {
            ZStack(alignment: .bottomLeading) {
                Image(instrument.image)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(12)
                    .padding()

                Text(instrument.emoji)
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(.tertiary, lineWidth: 1)
                    )

                    .padding()
            }
            VStack(alignment: .leading) {
                Text(instrument.name)
                    .font(.title.bold())

                Text(instrument.description)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(instrument.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(4)
                            .padding(.horizontal, 6)
                            .background(.thinMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.quaternary, lineWidth: 1)
                            )
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal)
                .padding(.leading, 4)
            }
        }
        .padding(.bottom)
        .background(.black)
    }
}

struct InstrumentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentDetailView(instrument: .firstInstrument)
            .frame(height: 640)
    }
}
