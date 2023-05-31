//
//  InstrumentDetailView.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import Colorful
import SwiftUI

struct InstrumentDetailView: View {
    @State private var hovering: Bool = false
    let instrument: InstrumentModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                ZStack(alignment: .bottomLeading) {
                    Image(instrument.image)
                        .resizable()
                        .scaledToFill()
                    VStack {
                        HStack {
                            Text(instrument.emoji)
                            Text("Launch Instrument")
                        }
                        .font(hovering ? .largeTitle : .caption)
                        .padding(.horizontal, hovering ? 0 : 6)
                        .frame(maxWidth: hovering ? .infinity : 128, maxHeight: hovering ? .infinity : 24)
                    }
                    .padding(hovering ? 0 : 4)
                    .background(
                        ColorfulView(animated: hovering, animation: .easeInOut(duration: 2))
                            .blendMode(.color)
                    )
                    .background(.ultraThinMaterial)
                    .clipShape(
                        RoundedRectangle(cornerRadius: hovering ? 12 : 32)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: hovering ? 12 : 32)
                            .stroke(hovering ? .primary : .tertiary, lineWidth: hovering ? 2 : 1)
                            .shadow(color: .white.opacity(hovering ? 1 : 0), radius: 16)
                    )

                    .padding(hovering ? 0 : 12)
                    .contentShape(RoundedRectangle(cornerRadius: 12))

                    .onHover { state in
                        withAnimation {
                            hovering = state
                        }
                    }
                }
            }
            .cornerRadius(12)
            VStack(alignment: .leading) {
                HStack {
                    Text(instrument.name)
                        .font(.title.bold())
                    Spacer()
                }

                Text(instrument.description)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }

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
                .padding(4)
            }
            .padding(.bottom)
        }
        .roundedCorners(radius: 12, corners: .top)
        .padding([.horizontal, .top])
        .background(.black)
        .frame(minWidth: 320)
        .toolbar {
            ToolbarItem {
                Label("Open Window", systemImage: "macwindow.on.rectangle")
            }
        }
    }
}

struct InstrumentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentDetailView(instrument: .firstInstrument)
            .frame(height: 640)
    }
}
