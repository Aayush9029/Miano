//
//  InstrumentModel.swift
//  Miano
//
//  Created by Aayush Pokharel on 2023-05-30.
//

import SwiftUI

struct InstrumentModel: Identifiable, Equatable {
    var id: String { image + description }
    let type: InstrumentType
    let name: String
    let image: String
    let description: String
    let emoji: String
    let tags: [String]
    let microphoneUsed: Bool

    init(
        type: InstrumentType,
        description: String,
        emoji: String,
        tags: [String] = [],
        microphoneUsed: Bool = false
    ) {
        self.type = type
        self.name = type.rawValue
        self.image = type.rawValue
        self.description = description
        self.emoji = emoji
        self.tags = tags
        self.microphoneUsed = microphoneUsed
    }

    static let allInstruments: [InstrumentModel] = [
        .init(
            type: .linearSpectrogram,
            description: "The Linear Spectrogram is a powerful analysis tool used in audio signal processing. It provides a visual representation of the frequency content of a sound wave over time. With its linear frequency axis, the Linear Spectrogram allows for precise analysis of individual frequencies and their variations. It is widely used in fields such as acoustics, speech recognition, and music production.",
            emoji: "📊",
            tags: ["audio analysis", "frequency visualization", "signal processing"],
            microphoneUsed: true
        ),
        .init(
            type: .melSpectrogram,
            description: "The Mel Spectrogram is an essential tool for analyzing and visualizing the frequency content of audio signals. Based on the Mel scale, which approximates the human auditory system's perception of pitch, the Mel Spectrogram provides a more perceptually accurate representation of sound compared to a linear spectrogram. It is widely used in fields like speech recognition, music analysis, and sound synthesis.",
            emoji: "📈",
            tags: ["audio visualization", "frequency analysis", "perceptual accuracy"],
            microphoneUsed: true
        ),
        .init(
            type: .miniKeyboard,
            description: "The Mini Keyboard is a compact and portable musical instrument that brings the joy of playing piano-like sounds to musicians of all levels. It features a small form factor without compromising on the quality of its key action and sound generation. With its versatile features and easy-to-use interface, the Mini Keyboard is perfect for composing, performing, or practicing on the go.",
            emoji: "🎹",
            tags: ["portable instrument", "piano-like sounds", "musical expression"]
        ),
        .init(
            type: .miniDrums,
            description: "Mini Drums is a compact percussion instrument that allows users to explore their rhythmic creativity. Its portable size and versatile sound make it perfect for musicians on the go. Whether you're a beginner or an experienced drummer, Mini Drums offers an intuitive interface and responsive drum pads for a dynamic playing experience. Ideal for practicing, jamming, or adding percussion to your compositions.",
            emoji: "🥁",
            tags: ["percussion", "portable", "rhythmic exploration"]
        ),
        .init(
            type: .pitchFinder,
            description: "The Pitch Finder is a handy tool for accurately identifying and analyzing the pitch of a musical note. It provides real-time feedback and precise pitch detection, making it valuable for musicians, vocalists, and music educators. Whether you need to tune an instrument, transcribe melodies, or train your ear, the Pitch Finder offers a reliable solution with its user-friendly interface and accurate results.",
            emoji: "🔍",
            tags: ["pitch detection", "music analysis", "ear training"]
        ),
        .init(
            type: .vocals,
            description: "Vocals refer to the human voice or singing in music. As a vital element in many genres, vocals can convey emotions, tell stories, and add depth to musical compositions. Whether it's a solo performance, harmonies, or layered vocals, the versatility of vocals allows for creative expression and interpretation. From professional singers to amateurs, vocals play a central role in the world of music.",
            emoji: "🎤",
            tags: ["singing", "expression", "musical storytelling"]
        ),
        .init(
            type: .whiteNoise,
            description: "White Noise refers to a random signal that contains equal energy at all frequencies. As a sound, it is characterized by its soothing and calming properties. It is widely used in various applications, such as relaxation, sleep aid, and sound masking. White Noise can help create a peaceful environment, promote concentration, and improve sleep quality.",
            emoji: "🌬️",
            tags: ["relaxation", "sound therapy", "sleep aid"]
        )
    ]

    static func getInstrument(_ type: InstrumentType) -> InstrumentModel? {
        return allInstruments.filter { $0.type == type }.first
    }

    static let firstInstrument: InstrumentModel = .allInstruments.first!
}

enum InstrumentType: String {
    case miniDrums = "Mini Drums"
    case linearSpectrogram = "Linear Spectrogram"
    case melSpectrogram = "Mel Spectrogram"
    case miniKeyboard = "Mini Keyboard"
    case whiteNoise = "White Noise"
    case pitchFinder = "Pitch Finder"
    case vocals = "Vocals"
}
