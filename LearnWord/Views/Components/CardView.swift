import SwiftUI
import AVFoundation

struct CardView: View {
    @ObservedObject private var statisticsManager = StatisticsManager.shared
    @State private var currentWord: Word
    @State private var isShowingBack: Bool = false
    @State private var degree: Double = 0
    @State private var options: [String] = []
    @State private var selectedAnswer: String?
    @State private var isCorrect: Bool?
    let selectedTag: WordTag
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    init(selectedTag: WordTag) {
        self.selectedTag = selectedTag
        _currentWord = State(initialValue: WordData.getRandomWord(for: selectedTag))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                ZStack {
                    CardFace(
                        text: currentWord.word.capitalized,
                        color: currentWord.tag.color,
                        tag: currentWord.tag
                    )
                    .opacity(isShowingBack ? 0 : 1)
                    
                    CardFace(
                        text: currentWord.meaning.capitalized,
                        color: currentWord.tag.color,
                        tag: currentWord.tag
                    )
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .opacity(isShowingBack ? 1 : 0)
                }
                .frame(height: 220)
                .shadow(radius: 10)
                .rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            let textToSpeak = isShowingBack ? currentWord.meaning : currentWord.word
                            speakText(textToSpeak)
                        }) {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 15)
                    }
                }
                .frame(height: 220)
            }
            .onTapGesture {
                withAnimation(.spring) {
                    degree += 180
                    isShowingBack.toggle()
                }
            }
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { gesture in
                        if abs(gesture.translation.width) > 50 {
                            withAnimation {
                                currentWord = WordData.getRandomWord(for: selectedTag)
                                isShowingBack = false
                                degree = 0
                                generateOptions()
                            }
                        }
                    }
            )
            
            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        checkAnswer(option)
                    }) {
                        Text(option.capitalized)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(buttonColor(for: option))
                            )
                    }
                    .disabled(selectedAnswer != nil)
                }
            }
            .padding(.horizontal)
        }
        .onAppear(perform: generateOptions)
        .onChange(of: currentWord) { oldValue, newValue in
            generateOptions()
        }
    }
    
    private func generateOptions() {
        guard selectedTag != .user else { return }
        var newOptions = [currentWord.meaning]
        
        let wrongOptions = WordData.getWordsByTag(tag: selectedTag)
            .filter { $0.meaning != currentWord.meaning }
            .map { $0.meaning }
            .shuffled()
        
        if wrongOptions.count >= 3 {
            newOptions.append(contentsOf: Array(wrongOptions.prefix(3)))
        } else {
            newOptions.append(contentsOf: wrongOptions)
            let otherOptions = WordData.allWords
                .filter { $0.tag != selectedTag && $0.meaning != currentWord.meaning }
                .map { $0.meaning }
                .shuffled()
                .prefix(3 - wrongOptions.count)
            newOptions.append(contentsOf: otherOptions)
        }
        
        options = newOptions.shuffled()
        selectedAnswer = nil
        isCorrect = nil
    }
    
    private func loadNewWord() {
        let oldWord = currentWord
        
        var newWord: Word
        repeat {
            newWord = WordData.getRandomWord(for: selectedTag)
        } while newWord.word == oldWord.word
        
        currentWord = newWord
    }
    
    private func buttonColor(for option: String) -> Color {
        guard let selected = selectedAnswer else {
            return .gray.opacity(0.5)
        }
        
        if option == selected {
            return isCorrect == true ? .green : .red
        }
        
        if option == currentWord.meaning && isCorrect == false {
            return .green
        }
        
        return .gray.opacity(0.5)
    }
    
    private func checkAnswer(_ option: String) {
        selectedAnswer = option
        isCorrect = option == currentWord.meaning
        
        if isCorrect == true {
            statisticsManager.incrementCorrect(for: selectedTag)
            statisticsManager.removeWord(currentWord, from: selectedTag)
        } else {
            statisticsManager.incrementWrong(for: selectedTag)
            statisticsManager.addWrongWord(currentWord, for: selectedTag)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                loadNewWord()
                isShowingBack = false
                degree = 0
                generateOptions()
                selectedAnswer = nil
                isCorrect = nil
            }
        }
    }
    
    private func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: isShowingBack ? "tr-TR" : "en-US")
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
}

#Preview {
    ScrollView {
        CardView(selectedTag: .beginner)
        CardView(selectedTag: .elementary)
        CardView(selectedTag: .intermediate)
        CardView(selectedTag: .advanced)
        CardView(selectedTag: .aircraft)
        CardView(selectedTag: .yds)
        CardView(selectedTag: .user)
    }
}
