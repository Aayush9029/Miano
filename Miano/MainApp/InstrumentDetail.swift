//
//  InstrumentDetailView.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AVFoundation
import Colorful
import SwiftUI

struct InstrumentDetailView: View {
    @State private var popoverShown: Bool = false
    @Environment(\.openURL) var openURL
    @Environment(\.openWindow) var openWindow
    @State private var hovering: Bool = false
    let instrument: InstrumentModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .bottomLeading) {
                    Image(instrument.image)
                        .resizable()
                        .scaledToFill()
                    Button {
                        print("launching \(instrument.name)")
                        openWindow(id: instrument.name)
                    } label: {
                        VStack {
                            HStack {
                                Text(instrument.emoji)
                                Text("Launch Instrument")
                            }
                            .font(hovering ? .largeTitle : .callout)
                            .padding(.horizontal, hovering ? 0 : 6)
                            .frame(maxWidth: hovering ? .infinity : 180, maxHeight: hovering ? .infinity : 24)
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
                                .stroke(hovering ? .primary : .secondary, lineWidth: hovering ? 2 : 1)
                                .shadow(color: .white.opacity(hovering ? 1 : 0), radius: 16)
                        )

                        .padding(hovering ? 0 : 12)
                        .contentShape(RoundedRectangle(cornerRadius: 12))

                        .onHover { state in
                            withAnimation(.easeIn(duration: 0.12)) {
                                hovering = state
                                performHapticFeedback(hovering ? .levelChange : .generic)
                            }
                        }
                    }
                    .accessibilityIdentifier("Launch Instrument")
                    .buttonStyle(.plain)
                }

                if instrument.microphoneUsed {
                    Label("Microphone Used", systemImage: "mic.fill")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(
                            Circle()
                        )
                        .overlay(
                            Circle()
                                .stroke(.tertiary, lineWidth: 1)
                        )
                        .padding(12)
                        .containerShape(Circle())
                        .onTapGesture {
                            if AVCaptureDevice.authorizationStatus(for: .audio) != .authorized {
                                openURL(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone")!)
                            }
                        }
                        .onHover { state in
                            withAnimation {
                                popoverShown = state
                            }
                        }
                        .popover(isPresented: $popoverShown) {
                            VStack {
                                Text("This instrument uses microphone.")
                                if AVCaptureDevice.authorizationStatus(for: .audio) != .authorized {
                                    Divider()
                                    Text("Double click mic icon to open settings\nor\nGo to Settings > Privacy > Microphone > Check **Miano**")
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding()
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
    }
}

struct InstrumentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentDetailView(instrument: .firstInstrument)
            .frame(height: 640)
    }
}
