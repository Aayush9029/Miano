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
    @Environment(\.controlActiveState) private var controlActiveState

    @State private var layoutType: Float = 0 // 0, 1, 2
    @State private var octave: Int = 3 // pitch * 8 = lowest note
    @State private var amplitude: Float = 0.25
    @State private var velocity: Float = 0.25
    
    @StateObject var conductor: InstrumentEXSConductor = .init()
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Miano")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        Text("Made by Aayush")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.vertical)
                    
                    HStack {
                        KeyboardLayoutChanger(0, binded: $layoutType, shortcutKey: "1")
                        Spacer()
                        KeyboardLayoutChanger(1, binded: $layoutType, shortcutKey: "2")
                        Spacer()
                        KeyboardLayoutChanger(2, binded: $layoutType, shortcutKey: "3")
                        Spacer()
                    }
                    .frame(width: 100)
                }
                
                Spacer()
                
                HStack {
                    SmallKnob(
                        value: $layoutType,
                        range: 0 ... 0.3
                    )
                    .frame(width: 60)
                    .shadow(color: .white.opacity(0.125), radius: 12, y: 4)
                    
                    SmallKnob(value: $conductor.velocity)
                        .frame(width: 60)
                        .shadow(color: .white.opacity(0.125), radius: 12, y: 4)
                }
                
                NodeOutputView(conductor.instrument)
                    .id(conductor.running)
                    .overlay(content: {
                        Color.blue.opacity(0.5)
                            .blendMode(.color)
                    })
                    .frame(width: 120, height: 80)
                    .cornerRadius(12)
                
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.125), lineWidth: 2)
                    )
                    .shadow(color: .white.opacity(0.125), radius: 6, y: 4)
            }
            HStack {
                VStack(spacing: 0) {
                    OctaveButton(type: .increase, pitch: $octave)
                    
                    Divider().frame(width: 12)
                    
                    OctaveButton(type: .decrease, pitch: $octave)
                }
                .labelStyle(.iconOnly)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 2)
                )
                
                CustomKeys(
                    layoutFloat: $layoutType,
                    customPitch: $octave
                )
                .background(.gray)
                
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.black.opacity(1), lineWidth: 2)
                )
                .shadow(radius: 8, y: 4)
                .environmentObject(conductor)
            }
            .frame(minHeight: 100, maxHeight: 200)
        }
        .padding()
        .background(
            Rectangle()
                .fill(.shadow(.inner(color: .white.opacity(0.25), radius: 32)))
                .foregroundColor(.black)
        )
        .ignoresSafeArea()
        .frame(maxWidth: 720, maxHeight: 280)
        
        .onChange(of: controlActiveState) { phase in
            if phase == .active || phase == .key {
                conductor.start()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { _ in
            print("close")
            conductor.stop()
        }
    }
}
    
struct KeyboardLayoutChanger: View {
    @Binding var layoutType: Float
    var lt: Int {
        Int(layoutType * 10)
    }

    let setLayout: Int
    var st: Float {
        Float(setLayout / 10)
    }
    
    let shortcutKey: KeyEquivalent
        
    init(_ setLayout: Int, binded: Binding<Float>, shortcutKey: KeyEquivalent) {
        self.setLayout = setLayout
        self._layoutType = binded
        self.shortcutKey = shortcutKey
    }
        
    var body: some View {
        Button {
            withAnimation {
                layoutType = st
            }
            
        } label: {
            ZStack {
                Circle()
                    .frame(width: 12)
                    .foregroundColor(
                        lt == setLayout ? .green : .clear
                    )

                    .blur(radius: lt == setLayout ? 12 : 0)
                Circle()
                    .frame(width: 6)
                    .foregroundColor(
                        lt == setLayout ? .green : .white.opacity(0.25)
                    )
                    .shadow(
                        color: lt == setLayout ?
                            .green : .white.opacity(0.25),
                        radius: 12
                    )
            }
            .padding(.horizontal, 4)
        }
        .buttonStyle(.plain)
        .keyboardShortcut(shortcutKey, modifiers: .command)
    }
}
    
enum PitchType {
    case increase, decrease
}
    
struct OctaveButton: View {
    let maxOctave = 9
    let minOctave = 0
    let type: PitchType
    @Binding var pitch: Int
        
    var inRange: Bool {
        if type == .decrease {
            return pitch > minOctave
        }
        if type == .increase {
            return pitch < maxOctave
        }
        return false
    }
        
    var body: some View {
        Button {
            if inRange {
                if type == .increase {
                    pitch += 1
                }
                if type == .decrease {
                    pitch -= 1
                }
            }
        } label: {
            VStack {
                Spacer()
                Group {
                    if type == .increase {
                        Label(
                            "Increase Octave",
                            systemImage: "triangle.fill"
                        )
                    } else {
                        Label(
                            "Decrease Octave",
                            systemImage: "arrowtriangle.down.fill"
                        )
                    }
                }
                .foregroundStyle(.gray)
                    
                Spacer()
            }
            .frame(width: 12)
            .padding()
            .background(inRange ? .white : .white.opacity(0.5))
        }
        .disabled(!inRange)
        .buttonStyle(.plain)
    }
}

struct MiniKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        MiniKeyboard()
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black, lineWidth: 2)
            )
            .environmentObject(InstrumentEXSConductor())
            .padding()
    }
}
