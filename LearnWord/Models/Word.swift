//
//  Word.swift
//  LearnWord
//
//  Created by Rıfat on 28.11.2024.
//

import Foundation

struct Word: Identifiable, Equatable, Codable {
    var id = UUID()
    var word: String
    var meaning: String
    var tag: WordTag
    
    // Equatable protokolü için gerekli
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.id == rhs.id &&
               lhs.word == rhs.word &&
               lhs.meaning == rhs.meaning &&
               lhs.tag == rhs.tag
    }
}
