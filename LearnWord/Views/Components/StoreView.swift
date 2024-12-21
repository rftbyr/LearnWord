import SwiftUI
import StoreKit

struct StoreView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var isRestoring = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(storeManager.products) { product in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.displayName)
                                .font(.headline)
                            Text(product.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if storeManager.isPurchased(product.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                        } else {
                            Button(action: {
                                Task {
                                    do {
                                        try await storeManager.purchase(product)
                                    } catch {
                                        errorMessage = error.localizedDescription
                                        showingError = true
                                    }
                                }
                            }) {
                                Text(product.displayPrice)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Geri yükleme butonu
                Section {
                    Button(action: {
                        Task {
                            isRestoring = true
                            do {
                                try await storeManager.restorePurchases()
                            } catch {
                                errorMessage = error.localizedDescription
                                showingError = true
                            }
                            isRestoring = false
                        }
                    }) {
                        HStack {
                            Text("Restore Purchases")
                            if isRestoring {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                    .disabled(isRestoring)
                }
            }
            .navigationTitle("Store")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
            .task {
                await storeManager.loadProducts()
            }
        }
    }
}

#Preview {
    StoreView()
}
