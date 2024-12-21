import SwiftUI
import TipKit

struct PracticeModeView: View {
    
    @ObservedObject private var statisticsManager = StatisticsManager.shared
    @State private var selectedTag: WordTag = .beginner
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // Seviye seçici
                Picker("Level", selection: $selectedTag) {
                    ForEach(WordTag.allCases, id: \.self) { tag in
                        if tag != .user {
                            HStack{
                                Text(tag.rawValue.uppercased().prefix(3))
                                    .tag(tag)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    }
                }
                .popoverTip(PraticTip())
                .padding(.horizontal, 20)
                .pickerStyle(.segmented)
                if statisticsManager.getWrongWords(for: selectedTag).isEmpty {
                    // Yanlış kelime yoksa
                    Spacer()
                    VStack {
                        Image(systemName: "checkmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        Text("No words to practice!")
                            .font(.headline)
                    }
                    Spacer()
                } else {
                    // Yanlış kelimeleri göster
                    List {
                        ForEach(statisticsManager.getWrongWords(for: selectedTag), id: \.word) { word in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(word.word)
                                        .font(.headline)
                                    Text(word.meaning)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    statisticsManager.removeWord(word, from: selectedTag)
                                }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Practice")
        }
    }
}

#Preview {
    PracticeModeView()
}
