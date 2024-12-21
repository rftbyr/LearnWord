import StoreKit

@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()
    private var updateListenerTask: Task<Void, Error>?
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    
    private let productIdentifiers = [
        "com.rftbyr.LearnWord.yds",
        "com.rftbyr.LearnWord.aircraft"
    ]
    
    private init() {
        // Transaction listener'ı başlat
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // Transaction listener
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else {
                    continue
                }
                
                await self.handle(transaction: transaction)
                await transaction.finish()
            }
        }
    }
    
    // Transaction handler
    @MainActor
    private func handle(transaction: Transaction) async {
        purchasedProductIDs.insert(transaction.productID)
        
        // StoreManager'ı güncelle
        if transaction.productID == "com.rftbyr.LearnWord.yds" {
            StoreManager.purchaseTag(.yds)
        } else if transaction.productID == "com.rftbyr.LearnWord.aircraft" {
            StoreManager.purchaseTag(.aircraft)
        }
    }
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIdentifiers)
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(_):
            await updatePurchasedProducts()
            
            // Update StoreManager
            if product.id == "com.rftbyr.LearnWord.yds" {
                StoreManager.purchaseTag(.yds)
            } else if product.id == "com.rftbyr.LearnWord.aircraft" {
                StoreManager.purchaseTag(.aircraft)
            }
            
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            purchasedProductIDs.insert(transaction.productID)
        }
    }
    
    func isPurchased(_ productID: String) -> Bool {
        return purchasedProductIDs.contains(productID)
    }
    
    func restorePurchases() async throws {
        // Mevcut satın alımları temizle
        purchasedProductIDs.removeAll()
        
        // App Store'dan satın alımları yükle
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            purchasedProductIDs.insert(transaction.productID)
            
            // StoreManager'ı güncelle
            if transaction.productID == "com.rftbyr.LearnWord.yds" {
                StoreManager.purchaseTag(.yds)
            } else if transaction.productID == "com.rftbyr.LearnWord.aircraft" {
                StoreManager.purchaseTag(.aircraft)
            }
        }
    }
} 