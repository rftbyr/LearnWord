//
//  LevelButton.swift
//  LearnWord
//
//  Created by Rıfat on 28.11.2024.
//

import SwiftUI

struct LevelButton: View {
    let level: WordTag
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                level.icon
                    .font(.system(size: 24))
            }
            
            Text(level.description)
                .font(.system(size: 10, weight: .medium))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 70, height: 70)
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(backgroundColor)
                .shadow(color: shadowColor,
                       radius: 8, x: 0, y: 3)
        )
        .onTapGesture {
            onTap()
        }
    }
    
    private var backgroundColor: Color {
        return isSelected ? level.color : .gray.opacity(0.5)
    }
    
    private var shadowColor: Color {
        return isSelected ? level.color.opacity(0.5) : .gray.opacity(0.5)
    }
}

// MARK: - Preview
#Preview() {
    VStack {
        LevelButton(
            level: .beginner,
            isSelected: true,
            onTap: {}
        )
        LevelButton(
            level: .elementary,
            isSelected: true,
            onTap: {}
        )
        LevelButton(
            level: .intermediate,
            isSelected: true,
            onTap: {}
        )
        LevelButton(
            level: .advanced,
            isSelected: true,
            onTap: {}
        )
        LevelButton(
            level: .yds,
            isSelected: true,
            onTap: {}
        )
        LevelButton(
            level: .aircraft,
            isSelected: false,
            onTap: {}
        )
        
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
