# Miano

Status: archived. The last commit is from July 2023.

Miano is a macOS 13 SwiftUI app with a set of small music instruments: keyboard, drums, MIDI player, tuner, spectrogram, noise generator, and vocal track. It uses AudioKit, AudioKitEX, AudioKitUI, SoundpipeAudioKit, Keyboard, and Colorful through Swift Package Manager.

## Commands

| Task | Command |
|------|---------|
| Build | `xcodebuild -project Miano.xcodeproj -scheme Miano build` |
| Find unused code | `periphery scan` (reads `.periphery.yml`) |

## Layout

- `Miano/MainApp/`: sidebar, instrument picker, detail view.
- `Miano/Instruments/<Instrument>/`: one folder for each instrument. Put shared views in `SharedComponents`.
- `Sounds/`: WAV samples, SFZ sampler instruments, and MIDI files that the instruments load.
