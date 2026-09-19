import SwiftUI

/// A contextual quiz question triggered by a live match event explanation.
/// Correct answers award XP and update the user's knowledge profile.
struct ContextualQuizView: View {
    let question: QuizQuestion
    let topic: KnowledgeTopic
    let onAnswer: (Bool) -> Void
    
    @State private var selectedIndex: Int?
    @State private var hasAnswered: Bool = false
    @State private var showXPBadge: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "questionmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Test Your Knowledge")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(topic.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if hasAnswered {
                    XPBadgeView(xp: selectedIndex == question.correctIndex ? question.xpValue : 0, animated: true)
                }
            }
            .padding()
            .background(.blue.opacity(0.05))
            
            VStack(alignment: .leading, spacing: 16) {
                // Question
                Text(question.question)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineSpacing(2)
                
                // Options
                VStack(spacing: 8) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        Button {
                            guard !hasAnswered else { return }
                            withAnimation(.spring(response: 0.3)) {
                                selectedIndex = index
                                hasAnswered = true
                            }
                            
                            // Notify parent after brief delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                onAnswer(index == question.correctIndex)
                            }
                        } label: {
                            HStack {
                                Text(optionLabel(index))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(optionLabelColor(index))
                                    .frame(width: 24, height: 24)
                                    .background(optionLabelBackground(index))
                                    .clipShape(Circle())
                                
                                Text(option)
                                    .font(.subheadline)
                                    .foregroundStyle(optionTextColor(index))
                                
                                Spacer()
                                
                                if hasAnswered {
                                    if index == question.correctIndex {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                    } else if index == selectedIndex {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                            .padding(12)
                            .background(optionBackground(index))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(optionBorder(index), lineWidth: hasAnswered ? 2 : 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(hasAnswered)
                    }
                }
                
                // Explanation (shown after answering)
                if hasAnswered {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: selectedIndex == question.correctIndex ? "checkmark.circle.fill" : "info.circle.fill")
                            .foregroundStyle(selectedIndex == question.correctIndex ? .green : .blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedIndex == question.correctIndex ? "Correct!" : "Not quite")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(selectedIndex == question.correctIndex ? .green : .orange)
                            
                            Text(question.explanation)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineSpacing(2)
                        }
                    }
                    .padding(12)
                    .background(
                        (selectedIndex == question.correctIndex ? Color.green : Color.blue).opacity(0.08)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
    }
    
    // MARK: - Styling helpers
    
    private func optionLabel(_ index: Int) -> String {
        ["A", "B", "C", "D"][index]
    }
    
    private func optionLabelColor(_ index: Int) -> Color {
        if !hasAnswered { return .blue }
        if index == question.correctIndex { return .white }
        if index == selectedIndex { return .white }
        return .secondary
    }
    
    private func optionLabelBackground(_ index: Int) -> Color {
        if !hasAnswered { return .blue.opacity(0.1) }
        if index == question.correctIndex { return .green }
        if index == selectedIndex { return .red }
        return Color(.systemGray5)
    }
    
    private func optionTextColor(_ index: Int) -> Color {
        if !hasAnswered { return .primary }
        if index == question.correctIndex { return .green }
        if index == selectedIndex && index != question.correctIndex { return .red }
        return .secondary
    }
    
    private func optionBackground(_ index: Int) -> Color {
        if !hasAnswered { return Color(.systemGray6) }
        if index == question.correctIndex { return .green.opacity(0.08) }
        if index == selectedIndex { return .red.opacity(0.08) }
        return Color(.systemGray6).opacity(0.5)
    }
    
    private func optionBorder(_ index: Int) -> Color {
        if !hasAnswered { return Color(.systemGray4) }
        if index == question.correctIndex { return .green }
        if index == selectedIndex { return .red }
        return .clear
    }
}
