import SwiftUI

class StoreManager {
    @AppStorage("purchasedTags") private static var purchasedTagsString: String = "[]"
    
    static var purchasedTags: [WordTag] {
        get {
            if let data = purchasedTagsString.data(using: .utf8),
               let tags = try? JSONDecoder().decode([WordTag].self, from: data) {
                return tags
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                purchasedTagsString = string
            }
        }
    }
    
    static func isPurchased(_ tag: WordTag) -> Bool {
        return tag != .yds && tag != .aircraft || purchasedTags.contains(tag)
    }
    
    static func clearPurchases() {
        purchasedTags = []
    }
    
    static func purchaseTag(_ tag: WordTag) {
        var current = purchasedTags
        if !current.contains(tag) {
            current.append(tag)
            purchasedTags = current
        }
    }
} 
