//
//  SoundManager.swift
//  Phrini Click
//

import AVFoundation

/// Centralised, eagerly‑loaded, click‑sound player.
final class SoundManager {

    /// Global shared instance — created once when the app starts.
    static let shared = SoundManager()

    private var players: [BeatType: AVAudioPlayer] = [:]

    // MARK: – Initialisation
    /// Private so nobody can make a second instance.
    private init() {
        preloadSamples()
        primeAudioOutput()          // wake Core Audio before the user hits “Start”
    }

    // MARK: – Public API
    func playSound(for beat: BeatType) {
        guard beat != .off, let player = players[beat] else { return }
        player.currentTime = 0
        player.play()
    }

    // MARK: – Helpers
    private func preloadSamples() {
        for beat in [BeatType.low, .medium, .high] {
            guard let url = Bundle.main.url(forResource: beat.fileName, withExtension: "wav"),
                  let player = try? AVAudioPlayer(contentsOf: url) else { continue }
            player.prepareToPlay()
            players[beat] = player
        }
    }

    /// Plays each sample once at zero volume — this spins‑up the audio HW/driver so the
    /// **real** first click is instant and the Core Audio “factory” warnings disappear.
    private func primeAudioOutput() {
        for player in players.values {
            let original = player.volume
            player.volume = 0
            player.play()
            player.stop()
            player.volume = original
        }
    }
}

// Convenience so SoundManager doesn’t have to know about filenames.
private extension BeatType {
    var fileName: String {
        switch self {
        case .low:    return "ping_low"
        case .medium: return "ping_medium"
        case .high:   return "ping_high"
        default:      return ""
        }
    }
}
