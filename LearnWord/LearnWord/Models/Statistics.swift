import SwiftUI

class StatisticsManager: ObservableObject {
    static let shared = StatisticsManager()
    
    @Published var correctDictString: String {
        didSet {
            UserDefaults.standard.set(correctDictString, forKey: "stats_correct")
            objectWillChange.send()
        }
    }
    
    @Published var wrongDictString: String {
        didSet {
            UserDefaults.standard.set(wrongDictString, forKey: "stats_wrong")
            objectWillChange.send()
        }
    }
    
    @Published var wrongWordsDict: [String: [Word]] {
        didSet {
            if let encoded = try? JSONEncoder().encode(wrongWordsDict) {
                UserDefaults.standard.set(encoded, forKey: "wrong_words")
            }
        }
    }
    
    init() {
        self.correctDictString = UserDefaults.standard.string(forKey: "stats_correct") ?? "{}"
        self.wrongDictString = UserDefaults.standard.string(forKey: "stats_wrong") ?? "{}"

         if let data = UserDefaults.standard.data(forKey: "wrong_words"),
           let decoded = try? JSONDecoder().decode([String: [Word]].self, from: data) {
            self.wrongWordsDict = decoded
        } else {
            self.wrongWordsDict = [:]
        }
    }
    
    private var correctDict: [String: Int] {
        get {
            if let data = correctDictString.data(using: .utf8),
               let dict = try? JSONDecoder().decode([String: Int].self, from: data) {
                return dict
            }
            return [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                correctDictString = string
            }
        }
    }
    
    private var wrongDict: [String: Int] {
        get {
            if let data = wrongDictString.data(using: .utf8),
               let dict = try? JSONDecoder().decode([String: Int].self, from: data) {
                return dict
            }
            return [:]
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                wrongDictString = string
            }
        }
    }
    
    func correctAnswers(for tag: WordTag) -> Int {
        correctDict[tag.rawValue, default: 0]
    }
    
    func wrongAnswers(for tag: WordTag) -> Int {
        wrongDict[tag.rawValue, default: 0]
    }
    
    func totalAnswers(for tag: WordTag) -> Int {
        correctAnswers(for: tag) + wrongAnswers(for: tag)
    }
    
    func successRate(for tag: WordTag) -> Double {
        let total = totalAnswers(for: tag)
        guard total > 0 else { return 0 }
        return Double(correctAnswers(for: tag)) / Double(total) * 100
    }
    
    func incrementCorrect(for tag: WordTag) {
        var dict = correctDict
        dict[tag.rawValue, default: 0] += 1
        correctDict = dict
    }
    
    func incrementWrong(for tag: WordTag) {
        var dict = wrongDict
        dict[tag.rawValue, default: 0] += 1
        wrongDict = dict
    }
    
    func resetStats() {
        correctDict = [:]
        wrongDict = [:]
    }
    
    var totalCorrectAnswers: Int {
        correctDict.values.reduce(0, +)
    }
    
    var totalWrongAnswers: Int {
        wrongDict.values.reduce(0, +)
    }
    
    var totalAnswers: Int {
        totalCorrectAnswers + totalWrongAnswers
    }
    
    var overallSuccessRate: Double {
        guard totalAnswers > 0 else { return 0 }
        return Double(totalCorrectAnswers) / Double(totalAnswers) * 100
    }

     // Yanlış kelime ekleme fonksiyonu
    func addWrongWord(_ word: Word, for tag: WordTag) {
        var words = wrongWordsDict[tag.rawValue] ?? []
        if !words.contains(where: { $0.word == word.word }) {
            words.append(word)
            wrongWordsDict[tag.rawValue] = words
        }
    }
    
    // Doğru bilinen kelimeyi listeden çıkarma
    func removeWord(_ word: Word, from tag: WordTag) {
        var words = wrongWordsDict[tag.rawValue] ?? []
        words.removeAll { $0.word == word.word }
        wrongWordsDict[tag.rawValue] = words
    }
    
    // Belirli tag için yanlış kelimeleri getir
    func getWrongWords(for tag: WordTag) -> [Word] {
        return wrongWordsDict[tag.rawValue] ?? []
    }
}

struct Statistics {
    private static let manager = StatisticsManager.shared
    
    static func correctAnswers(for tag: WordTag) -> Int {
        manager.correctAnswers(for: tag)
    }
    
    static func wrongAnswers(for tag: WordTag) -> Int {
        manager.wrongAnswers(for: tag)
    }
    
    static func incrementCorrect(for tag: WordTag) {
        manager.incrementCorrect(for: tag)
    }
    
    static func incrementWrong(for tag: WordTag) {
        manager.incrementWrong(for: tag)
    }
    
    static func resetStats() {
        manager.resetStats()
    }
    
    static var totalCorrectAnswers: Int {
        manager.totalCorrectAnswers
    }
    
    static var totalWrongAnswers: Int {
        manager.totalWrongAnswers
    }
    
    static var totalAnswers: Int {
        manager.totalAnswers
    }
    
    static var overallSuccessRate: Double {
        manager.overallSuccessRate
    }
}
