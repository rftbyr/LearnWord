import SwiftUI

struct StatisticsView: View {
    @StateObject private var statisticsManager = StatisticsManager.shared
    @State private var showingResetAlert = false
    @State private var selectedTag: WordTag?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.cyan.opacity(0.05)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Genel İstatistikler
                        SummaryCardView(
                            correct: statisticsManager.totalCorrectAnswers,
                            wrong: statisticsManager.totalWrongAnswers
                        )
                        .padding()
                        
                        // Tag bazlı istatistikler
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(WordTag.allCases, id: \.self) { tag in
                                if statisticsManager.totalAnswers(for: tag) > 0 {
                                    LevelStatCircleView(
                                        tag: tag,
                                        stats: (
                                            correct: statisticsManager.correctAnswers(for: tag),
                                            wrong: statisticsManager.wrongAnswers(for: tag)
                                        )
                                    )
                                    .onTapGesture {
                                        selectedTag = tag
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Statistics")
            .toolbar {
                Button("Reset All Statistics") {
                    showingResetAlert = true
                }.foregroundStyle(Color.red)
            }
        }
        .alert("Reset Statistics", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                statisticsManager.resetStats()
            }
        } message: {
            Text("All statistics will be reset. Are you sure?")
        }
    }
}

struct LevelStatCircleView: View {
    let tag: WordTag
    let stats: (correct: Int, wrong: Int)
    
    var total: Int { stats.correct + stats.wrong }
    var successRate: Double {
        guard total > 0 else { return 0 }
        return Double(stats.correct) / Double(total) * 100
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                
                Circle()
                    .trim(from: 0, to: CGFloat(successRate / 100))
                    .stroke(
                        tag.color,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 5) {
                    tag.icon
                        .font(.title2)
                    Text("\(Int(successRate))%")
                        .font(.headline)
                }
            }
            .frame(height: 100)
            
            Text(tag.rawValue.capitalized)
                .font(.caption)
                .bold()
            
            Text("\(stats.correct)/\(total)")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

struct StatItemView: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text("\(value)")
                .font(.title3)
                .bold()
                .foregroundColor(color)
        }
    }
}

struct SummaryCardView: View {
    let correct: Int
    let wrong: Int
    
    var total: Int { correct + wrong }
    var successRate: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total) * 100
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Overall Success")
                .font(.headline)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                
                Circle()
                    .trim(from: 0, to: CGFloat(successRate / 100))
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.green, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("\(Int(successRate))%")
                        .font(.title)
                        .bold()
                    Text("Success Rate")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 120)
            
            HStack(spacing: 30) {
                StatItemView(title: "Correct", value: correct, color: .green)
                StatItemView(title: "Wrong", value: wrong, color: .red)
                StatItemView(title: "Total", value: total, color: .blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    StatisticsView()
} 
