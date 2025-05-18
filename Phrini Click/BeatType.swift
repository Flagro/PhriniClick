//
//  BeatType.swift
//  Phrini Click
//
//  Created by Anton Potapov on 16.3.25..
//

import Foundation

enum BeatType: Int, CaseIterable, Identifiable {
    case off = 0
    case low
    case medium
    case high

    var id: Int { self.rawValue }

    var description: String {
        switch self {
        case .off: return "Off"
        case .low: return "Low"
        case .medium: return "Med"
        case .high: return "High"
        }
    }

    func next() -> BeatType {
        let nextRaw = (self.rawValue + 1) % BeatType.allCases.count
        return BeatType(rawValue: nextRaw)!
    }
}
