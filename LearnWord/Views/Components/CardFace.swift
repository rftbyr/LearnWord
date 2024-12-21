import SwiftUI
import TipKit

struct CardFace: View {
    let text: String
    let color: Color
    let tag: WordTag
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.7), lineWidth: 2)
                )
            
            VStack {
                // Seviye göstergesi
                HStack {
                    Spacer()
                    Text(tag.description)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding([.top, .trailing], 16)
                }.popoverTip(MeaningTİp())
                
                Spacer()
                
                // Kelime
                Text(text)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                
                Spacer()
            }
        }.frame(width: UIScreen.main.bounds.width - 40 , height: 200)
        .popoverTip(NextWordTip())
    }
}

#Preview {
    CardFace(text: "Selection", color: .red, tag: .beginner)
}
