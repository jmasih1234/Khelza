import SwiftUI

struct LiveQuizBanner: View {
    let question: QuizQuestion
    var onAnswer: (Int) -> Void
    
    @State private var selectedAnswer: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundStyle(.yellow)
                Text("Live Quiz!")
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                XPBadgeView(xp: question.xpValue)
            }
            
            Text(question.question)
                .font(.subheadline)
                .foregroundStyle(.white)
            
            VStack(spacing: 8) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    Button {
                        guard selectedAnswer == nil else { return }
                        selectedAnswer = index
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            onAnswer(index)
                        }
                    } label: {
                        HStack {
                            Text(option)
                                .font(.caption)
                                .foregroundStyle(.white)
                            Spacer()
                            if let selected = selectedAnswer {
                                if index == question.correctIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                } else if index == selected {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(answerBackground(index: index))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(selectedAnswer != nil)
                }
            }
            
            if let selected = selectedAnswer {
                Text(selected == question.correctIndex ? "Correct! +\(question.xpValue) XP" : "Not quite — \(question.explanation)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.indigo, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    func answerBackground(index: Int) -> Color {
        guard let selected = selectedAnswer else {
            return .white.opacity(0.15)
        }
        if index == question.correctIndex { return .green.opacity(0.3) }
        if index == selected { return .red.opacity(0.3) }
        return .white.opacity(0.1)
    }
}
