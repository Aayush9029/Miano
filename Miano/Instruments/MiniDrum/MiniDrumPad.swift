//
//  MiniDrumPad.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import AudioKit
import AudioKitEX
import AudioKitUI
import AVFoundation
import Combine
import SwiftUI

struct MiniDrumPad: View {
    @Environment(\.controlActiveState) private var controlActiveState
    @StateObject var conductor = DrumsConductor()

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Miano by Aayush")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                PadsView(conductor: conductor) { pad in
                    conductor.playPad(padNumber: pad)
                }

            }.padding(8)
                .background(.black)

                .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { _ in
                    print("close")
                    conductor.stop()
                }

                .onChange(of: controlActiveState) { phase in
                    if phase == .active || phase == .key {
                        conductor.start()
                    }
                }
        }
        .ignoresSafeArea()
        .frame(minWidth: 360, minHeight: 280)
    }
}

struct MiniDrumPad_Previews: PreviewProvider {
    static var previews: some View {
        MiniDrumPad()
            .padding()
    }
}

struct PadsView: View {
    @ObservedObject var conductor: DrumsConductor

    var padsAction: (_ padNumber: Int) -> Void
    @State var downPads: [Int] = []

    var body: some View {
        VStack(spacing: 0) {
            NodeOutputView(conductor.drums)
                .padding(.horizontal, -24)
                .id(conductor.running)

            ForEach(0 ..< 2, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0 ..< 4, id: \.self) { column in

                        Button {
                            padsAction(getPadID(row: row, column: column))
                            downPads.append(row * 4 + column)
                            withAnimation(.easeIn(duration: 1.0)) {
                                downPads.removeAll(where: { $0 == row * 4 + column })
                            }

                        } label: {
                            ZStack {
                                SingleDrumPad(
                                    playing: downPads.contains(where: { $0 == row * 4 + column }),
                                    drumpad: conductor.drumSamples.map { $0 }[getPadID(row: row, column: column)]
                                )
                                .padding(6)
                            }
                        }
                        .buttonStyle(.plain)
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { _ in
                            if !(downPads.contains(where: { $0 == row * 4 + column })) {
                                padsAction(getPadID(row: row, column: column))
                                downPads.append(row * 4 + column)
                            }
                        }.onEnded { _ in
                            downPads.removeAll(where: { $0 == row * 4 + column })
                        })
                        .keyboardShortcut(
                            conductor.drumSamples.map { $0.key }[getPadID(row: row, column: column)],
                            modifiers: []
                        )
                    }
                }
            }
        }
    }
}

private func getPadID(row: Int, column: Int) -> Int {
    return (row * 4) + column
}
