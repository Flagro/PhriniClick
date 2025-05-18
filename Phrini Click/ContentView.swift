//
//  ContentView.swift
//  Phrini Click
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var metro = MetronomeViewModel()

    @State private var showPrefs      = false
    @State private var selectedOutput = "Default"
    private let outputs = ["Default", "Output 1", "Output 2"]

    // high = red, low = blue, medium = yellow
    private func colour(for beat: BeatType) -> Color {
        switch beat {
        case .low:    return .blue
        case .medium: return .yellow
        case .high:   return .red
        default:      return .gray
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            // purple ground‑layer
            Color.purple.ignoresSafeArea()

            // PNG head
            Image(metro.imageName)
                .resizable().scaledToFit().ignoresSafeArea()

            // ------------- UI -------------
            VStack(spacing: 14) {

                // Tempo
                HStack {
                    Text("Tempo: \(Int(metro.bpm)) BPM")
                        .font(.title3).bold()
                    Slider(value: $metro.bpm, in: 30...300, step: 1)
                }
                .padding(.horizontal)

                // Beats / Measure (LEFT, bigger & bold)
                HStack {
                    Text("Beats / Measure: \(metro.beatsPerMeasure)")
                        .font(.title3).bold()
                    Stepper("", value: $metro.beatsPerMeasure, in: 1...12)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)   // << left‑align

                // Play / Stop – nudged 50 px right
                HStack {
                    Spacer().frame(width: 50)                 // ← 50 px offset
                    Button(action: { metro.togglePlaying() }) {
                        Image(systemName: metro.isPlaying ? "stop.fill" : "play.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(Circle().fill(Color.gray))
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(.space)
                    Spacer()                                  // keep left‑side anchored
                }

                Spacer()

                // Beat circles – centred horizontally
                HStack(spacing: 16) {
                    ForEach(0..<metro.beatStates.count, id: \.self) { i in
                        let active = metro.currentBeatIndex == i && metro.isPlaying
                        ZStack {
                            // Base coloured dot
                            Circle()
                                .fill(colour(for: metro.beatStates[i]))
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))

                            // White “flash” overlay
                            Circle()
                                .fill(Color.white)
                                .opacity(active ? 1.0 : 0.0)
                                .animation(.easeOut(duration: 0.1), value: active)

                            // 1…n labels
                            Text("\(i + 1)")
                                .bold()
                                .foregroundColor(.black)
                        }
                        .frame(width: 48, height: 48)
                        .scaleEffect(active ? 1.15 : 1.0)
                        .animation(.easeOut(duration: 0.1), value: active)
                        .onTapGesture { metro.updateBeat(at: i) }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Spacer(minLength: 8)
            }
            .padding(.top, 18)

            // Bigger black cogwheel
            Button { showPrefs = true } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 34))
                    .foregroundColor(.black)
            }
            .buttonStyle(.plain)
            .padding(6)
            .sheet(isPresented: $showPrefs) {
                PreferencesView(selectedOutput: $selectedOutput,
                                outputs: outputs)
            }
        }
        .frame(width: 368, height: 330)     // fixed window size
    }
}
