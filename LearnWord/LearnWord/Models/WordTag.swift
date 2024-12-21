//
//  WordTag.swift
//  LearnWord
//
//  Created by Rıfat on 28.11.2024.
//

import SwiftUI

enum WordTag: String, Codable, CaseIterable {
    case beginner, elementary, intermediate, advanced, yds, aircraft, user
    
    var description: String {
        switch self {
        case .beginner: return NSLocalizedString("Beginner", comment: "")
        case .elementary: return NSLocalizedString("Elementary", comment: "")
        case .intermediate: return NSLocalizedString("Intermediate", comment: "")
        case .advanced: return NSLocalizedString("Advanced", comment: "")
        case .yds: return NSLocalizedString("YDS", comment: "")
        case .aircraft: return NSLocalizedString("Aircraft", comment: "")
        case .user: return NSLocalizedString("User", comment: "")
        }
    }
    
    var color: Color {
        switch self {
        case .beginner: return .blue.opacity(0.6)
        case .elementary: return .green.opacity(0.6)
        case .intermediate: return .yellow.opacity(0.6)
        case .advanced: return .red.opacity(0.6)
        case .yds: return .purple.opacity(0.6)
        case .aircraft: return .orange.opacity(0.6)
        case .user: return .cyan.opacity(0.6)
        }
    }
    
    var icon: Image {
        switch self {
        case .beginner: return Image(systemName: "leaf")
        case .elementary: return Image(systemName: "sparkles")
        case .intermediate: return Image(systemName: "star")
        case .advanced: return Image(systemName: "trophy")
        case .yds: return Image(systemName: "graduationcap")
        case .aircraft: return Image(systemName: "airplane")
        case .user: return Image(systemName: "person")
        }
    }
}
