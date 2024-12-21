//
//  WordData.swift
//  LearnWord
//
//  Created by Rıfat on 30.11.2024.
//

import SwiftUI

struct WordData {
    @AppStorage("userWords") private static var userWordsString: String = "[]"
    
    private static var userWords: [Word] {
        get {
            if let data = userWordsString.data(using: .utf8),
               let words = try? JSONDecoder().decode([Word].self, from: data) {
                return words
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                userWordsString = string
            }
        }
    }
    
    // Tüm kelimeleri birleştiren computed property
    static var allWords: [Word] {
        var words = elementary + beginner + intermediate + advanced + userWords
        
        // Satın alınmış paketleri ekle
        if StoreManager.isPurchased(.aircraft) {
            words += aircraft
        }
        if StoreManager.isPurchased(.yds) {
            words += yds
        }
        
        return words
    }
    
    static func getWordsByTag(tag: WordTag) -> [Word] {
        // Önce satın alma durumunu kontrol et
        switch tag {
        case .aircraft:
            guard StoreManager.isPurchased(.aircraft) else { return [] }
        case .yds:
            guard StoreManager.isPurchased(.yds) else { return [] }
        default:
            break
        }
        
        return allWords.filter { $0.tag == tag }
    }
    
    static func getRandomWord(for tag: WordTag) -> Word {
        // Önce satın alma durumunu kontrol et
        switch tag {
        case .aircraft:
            guard StoreManager.isPurchased(.aircraft) else { return beginner[0] }
        case .yds:
            guard StoreManager.isPurchased(.yds) else { return beginner[0] }
        default:
            break
        }
        
        let wordList = getWordsByTag(tag: tag)
        return wordList.randomElement() ?? beginner.randomElement()!
    }
    
    // Diğer fonksiyonlar aynı kalacak
    static func addUserWord(word: String, meaning: String) {
        let newWord = Word(word: word, meaning: meaning, tag: .user)
        var currentWords = userWords
        currentWords.append(newWord)
        userWords = currentWords
    }
    
    static func removeUserWord(at index: Int) {
        var currentWords = userWords
        currentWords.remove(at: index)
        userWords = currentWords
    }
    
    static func getUserWords() -> [Word] {
        return userWords
    }
    
    static func searchWords(query: String) -> [Word] {
        let lowercasedQuery = query.lowercased()
        return allWords.filter { word in
            word.word.lowercased().contains(lowercasedQuery) ||
            word.meaning.lowercased().contains(lowercasedQuery)
        }
    }
}
