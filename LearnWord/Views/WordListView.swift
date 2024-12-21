//
//  WordListView.swift
//  LearnWord
//
//  Created by Rıfat on 28.11.2024.
//

import SwiftUI
import TipKit

struct WordListView: View {
    
    @State private var searchText = ""
    @State private var showingPurchaseAlert = false
    @State private var selectedTag: WordTag?
    @State private var userWordsSelected = false
    @State private var showingDeleteAlert = false
    @State private var wordToDelete: Word?
    @State private var showingAddWordSheet = false
    @State private var newWord = ""
    @State private var newMeaning = ""
    
//    init(){
//        try? Tips.resetDatastore()
//        try? Tips.configure()
//    }
    
    var availableWords: [Word] {
        if userWordsSelected {
            return WordData.getUserWords()
        } else {
            return WordData.allWords.filter { StoreManager.isPurchased($0.tag) }
        }
    }
    
    var filteredWords: [Word] {
        if searchText.isEmpty {
            return availableWords
        }
        
        let searchQuery = searchText.lowercased()
        return availableWords.filter { word in
            word.word.lowercased().contains(searchQuery) ||
            word.meaning.lowercased().contains(searchQuery)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.cyan.opacity(0.05)
                    .ignoresSafeArea()
                VStack {
                    if filteredWords.isEmpty {
                        EmptyStateView(option: userWordsSelected ? false : true)
                    } else {
                        wordListView
                    }
                }
                .navigationTitle(userWordsSelected ? "My Words" : "Words")
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search Word..."
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("", systemImage: "plus") {
                            showingAddWordSheet = true
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            userWordsSelected.toggle()
                            searchText = ""
                        } label: {
                            Image(systemName: userWordsSelected ? "person.fill" : "person")
                                .popoverTip(WordListTip())
                        }
                    }
                }
                .sheet(isPresented: $showingAddWordSheet) {
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
                                newWord = ""
                                newMeaning = ""
                            },
                            trailing: Button("Save") {
                                if !newWord.isEmpty && !newMeaning.isEmpty {
                                    WordData.addUserWord(word: newWord, meaning: newMeaning)
                                    newWord = ""
                                    newMeaning = ""
                                    showingAddWordSheet = false
                                }
                            }
                                .disabled(newWord.isEmpty || newMeaning.isEmpty)
                        )
                    }
                    .presentationDetents([.medium])
                }
                .alert("Delete Word", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        deleteWord()
                    }
                } message: {
                    Text("Are you sure you want to delete '\(wordToDelete?.word ?? "")'?")
                }
            } }
        .alert("Purchase Required", isPresented: $showingPurchaseAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Purchase") {
                if let tag = selectedTag {
                    StoreManager.purchaseTag(tag)
                }
            }
        } message: {
            if let tag = selectedTag {
                Text("Would you like to purchase the \(tag.rawValue) package?")
            }
        }
    }
    
    private var wordListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(filteredWords) { word in
                    ListRowView(word: word)
                        .contextMenu {
                            if word.tag == .user {
                                Button(role: .destructive) {
                                    wordToDelete = word
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                }
            }
        }
    }
    
    private func deleteWord() {
        if let word = wordToDelete,
           let index = WordData.getUserWords().firstIndex(where: { $0.id == word.id }) {
            WordData.removeUserWord(at: index)
        }
    }
}

#Preview {
    WordListView()
}
