//
//  MetronomeViewModel.swift
//  Phrini Click
//

import Foundation
import Combine
import AVFoundation

final class MetronomeViewModel: ObservableObject {

    // MARK: ‑ Published state
    @Published var bpm: Double = 120           { didSet { restartTimer() } }
    @Published var beatsPerMeasure = 4 {
        didSet {
            // default pattern only when the user is on a 4‑beat bar;
            // otherwise fill with .medium
            if beatsPerMeasure == 4 {
                beatStates = [.medium, .low, .low, .low]
            } else {
                beatStates = Array(repeating: .medium, count: beatsPerMeasure)
            }
        }
    }
    @Published var beatStates: [BeatType] = [.medium, .low, .low, .low]   // ← default pattern
    @Published var currentBeatIndex = -1
    @Published var imageName        = "phriniclick_normal"
    @Published var isPlaying        = false

    // MARK: ‑ Private
    private var timer: DispatchSourceTimer?
    private let audio = SoundManager.shared
    private var secondsPerBeat: Double { 60.0 / bpm }

    // MARK: ‑ Playback
    func togglePlaying() { isPlaying ? stop() : start() }

    func start() {
        guard !isPlaying else { return }
        isPlaying        = true
        currentBeatIndex = -1
        scheduleTimer()
        playNextBeat()                           // first click immediately
    }

    func stop() {
        isPlaying        = false
        timer?.cancel(); timer = nil
        currentBeatIndex = -1
        imageName        = "phriniclick_normal"
    }

    private func scheduleTimer() {
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now() + secondsPerBeat,
                        repeating: secondsPerBeat,
                        leeway: .milliseconds(2))
        timer?.setEventHandler { [weak self] in self?.playNextBeat() }
        timer?.resume()
    }

    private func restartTimer() { if isPlaying { scheduleTimer() } }

    private func playNextBeat() {
        currentBeatIndex = (currentBeatIndex + 1) % beatsPerMeasure
        let beat = beatStates[currentBeatIndex]
        animateImage(for: beat)
        if beat != .off { audio.playSound(for: beat) }
    }

    func updateBeat(at index: Int) {
        guard beatStates.indices.contains(index) else { return }
        beatStates[index] = beatStates[index].next()
    }

    // MARK: ‑ Image
    private func animateImage(for beat: BeatType) {
        switch beat {
        case .low:          imageName = "phriniclick_down"
        case .medium, .high:imageName = "phriniclick_nod"
        default:            imageName = "phriniclick_normal"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsPerBeat / 2) { [weak self] in
            self?.imageName = "phriniclick_normal"
        }
    }
}
