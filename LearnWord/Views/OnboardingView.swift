import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            title: NSLocalizedString("Welcome to LearnWord", comment: "Onboarding welcome title"),
            description: NSLocalizedString("Start your journey to learn new words in a fun way!", comment: "Onboarding welcome description"),
            imageName: "book.fill",
            backgroundColor: .blue
        ),
        OnboardingPage(
            title: NSLocalizedString("Choose Your Level", comment: "Onboarding level title"),
            description: NSLocalizedString("Study at your own pace from beginner to advanced levels", comment: "Onboarding level description"),
            imageName: "chart.line.uptrend.xyaxis",
            backgroundColor: .green
        ),
        OnboardingPage(
            title: NSLocalizedString("Manage Your Words", comment: "Onboarding manage title"),
            description: NSLocalizedString("Create and manage your own word lists", comment: "Onboarding manage description"),
            imageName: "pencil.and.list.clipboard",
            backgroundColor: .purple
        )
    ]
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            // Start Button
            VStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(currentPage == pages.count - 1 ? "Start" : "Skip")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .ignoresSafeArea()
    }
}

struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        ZStack {
            page.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: page.imageName)
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                Text(page.title)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Text(page.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal)
            }
            .padding()
        }
        .transition(.slide)
        .animation(.spring(), value: page)
    }
} 

#Preview {
    OnboardingView()
}
