//
//  HomeView.swift
//  LearnWord
//
//  Created by Rıfat on 30.11.2024.
//

import SwiftUI
import TipKit

struct HomeView: View {
    // MARK: - Properties
    @State private var selectedTag: WordTag = .beginner
    @State private var cardId = UUID()
    @State private var showingAddWordSheet = false
    @State private var showingStoreSheet = false
    @State private var showingSettingSheet = false
    @State private var newWord = ""
    @State private var newMeaning = ""
    @State private var showingPracticeMode = false
    
    // Tipleri property olarak tanımlayalım
    private let addWordTip = AddWordTip()
    
    private var hasWords: Bool {
        !WordData.getWordsByTag(tag: selectedTag)
            .filter { StoreManager.isPurchased($0.tag) }
            .isEmpty
    }
    
    // MARK: - Views
    private var levelSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(WordTag.allCases, id: \.self) { tag in
                    LevelButton(level: tag,
                                isSelected: selectedTag == tag,
                                onTap: {
                        selectedTag = tag
                        cardId = UUID()
                    })
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var mainContent: some View {
        Group {
            if !StoreManager.isPurchased(selectedTag) {
                EmptyStateView(option: true)
            } else if !hasWords {
                EmptyStateView(option: true)
            } else {
                CardView(
                    selectedTag: selectedTag
                )
                .id(cardId)
            }
        }
    }
    
    private var addWordSheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Word")) {
                    TextField("Word", text: $newWord)
                    TextField("Meaning", text: $newMeaning)
                }
            }
            .navigationTitle("Add New Word")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showingAddWordSheet = false
                },
                trailing: Button("Save") {
                    saveNewWord()
                }
                .disabled(newWord.isEmpty || newMeaning.isEmpty)
            )
        }
        .presentationDetents([.medium])
    }
    
    // MARK: - Methods
    private func saveNewWord() {
        if !newWord.isEmpty && !newMeaning.isEmpty {
            WordData.addUserWord(word: newWord, meaning: newMeaning)
            newWord = ""
            newMeaning = ""
            showingAddWordSheet = false
            cardId = UUID()
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                selectedTag.color.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack {
                    levelSelector
                    mainContent
                    Spacer()
                }
            }
            .navigationTitle("Learn Word")
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingStoreSheet = true
                    }) {
                        Label("Store", systemImage: "cart")
                    }
                }
                
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingSettingSheet = true
                    }) {
                        Label("Setting", systemImage: "gearshape")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showingPracticeMode = true
                    }) {
                        Label("List", systemImage: "book")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showingAddWordSheet = true
                    }) {
                        Label("Add New Word", systemImage: "plus")
                    }
                    .popoverTip(addWordTip)
                }
            }
            .sheet(isPresented: $showingStoreSheet) {
                StoreView()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingAddWordSheet) {
                addWordSheet
            }
            .sheet(isPresented: $showingSettingSheet) {
                SettingsView()
            }
            .sheet(isPresented: $showingPracticeMode) {
                WordListView()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
