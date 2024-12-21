//
//  WordCardView.swift
//  LearnWord
//
//  Created by Rıfat on 28.11.2024.
//


import SwiftUI

struct ListRowView: View {
    let word: Word
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(word.word.capitalized)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(word.meaning.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Divider()
            }
            
            Spacer()
            
            // Tag için badge
            Text(word.tag.description)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(word.tag.color.opacity(0.1))
                .foregroundColor(word.tag.color)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 20)
    }
}

struct WordCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ListRowView(word: Word(word: "Hello", meaning: "Merhaba", tag: .beginner))
            ListRowView(word: Word(word: "Hello", meaning: "Merhaba", tag: .beginner))
                .previewLayout(.sizeThatFits)
        }
    }
}
