//
//  ContentView.swift
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

struct ContentView: View {
    @State private var layoutType: Int = 0 // 0, 1, 2
    @State private var pitch: Int = 0 // pitch * 8 = lowest note
    @State private var amplitude: Float = 0.25
    @StateObject var conductor: InstrumentEXSConductor = .init()
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Miano")
                            .font(.largeTitle.bold())
                        Text("Made in Canada")
                            .font(.caption)
                    }
                    .foregroundColor(.black.opacity(0.5))
                    
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
                    SmallKnob(value: $amplitude)
                        .frame(width: 60)
                        .shadow(radius: 12, y: 10)
                    
                    SmallKnob(value: $amplitude)
                        .frame(width: 60)
                        .shadow(radius: 12, y: 10)
                    
                    SmallKnob(value: $amplitude)
                        .frame(width: 60)
                        .shadow(radius: 12, y: 10)
                }
                
                //                NodeOutputView(conductor.instrument)
                //                    .overlay(content: {
                //                        Color.green
                //                            .blendMode(.color)
                //                    })
                Rectangle()
                    .fill(.black)
                    .frame(width: 120, height: 80)
                    .cornerRadius(12)
                
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(radius: 4, y: 2)
            }
            HStack {
                VStack(spacing: 0) {
                    PitchButton(type: .increase, pitch: $pitch)
                    
                    Divider().frame(width: 12)
                    
                    PitchButton(type: .decrease, pitch: $pitch)
                }
                .labelStyle(.iconOnly)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray, lineWidth: 2)
                )
                
                //                MiniKeyboard(
                //                    layoutType: $layoutType,
                //                    customPitch: $pitch
                //                )
                //                .background(.black)
                Rectangle()
                    .fill(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.black.opacity(1), lineWidth: 2)
                    )
                    .shadow(radius: 8, y: 4)
                    .environmentObject(conductor)
            }
            .frame(minHeight: 80, maxHeight: 200)
        }
        .padding()
        .background(.gray)
        .cornerRadius(12)
    }
}
    
struct KeyboardLayoutChanger: View {
    @Binding var layoutType: Int
    let setLayout: Int
    let shortcutKey: KeyEquivalent
        
    init(_ setLayout: Int, binded: Binding<Int>, shortcutKey: KeyEquivalent) {
        self.setLayout = setLayout
        self._layoutType = binded
        self.shortcutKey = shortcutKey
    }
        
    var body: some View {
        Button {
            layoutType = setLayout
        } label: {
            Circle()
                .frame(width: 6)
                .foregroundColor(
                    layoutType == setLayout ? .green : .black.opacity(0.5)
                )
                .shadow(
                    color: layoutType == setLayout ?
                        .green : .black.opacity(0.125),
                    radius: 4
                )
        }
        .buttonStyle(.plain)
        .keyboardShortcut(shortcutKey, modifiers: .command)
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(InstrumentEXSConductor())
            .padding()
    }
}
    
enum PitchType {
    case increase, decrease
}
    
struct PitchButton: View {
    let maxPitch = 9
    let minPitch = -1
    let type: PitchType
    @Binding var pitch: Int
        
    var inRange: Bool {
        if type == .decrease {
            return pitch > minPitch
        }
        if type == .increase {
            return pitch < maxPitch
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
                            "Increase Pitch",
                            systemImage: "triangle.fill"
                        )
                    } else {
                        Label(
                            "Decrease Pitch",
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
