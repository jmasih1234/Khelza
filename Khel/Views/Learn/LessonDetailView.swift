import SwiftUI

struct LessonDetailView: View {
    @Environment(AppState.self) private var appState
    let lesson: Lesson
    var onComplete: () -> Void
    
    @State private var currentCardIndex: Int = 0
    @State private var showingQuiz: Bool = false
    @State private var quizAnswers: [Int] = []
    @State private var currentQuizIndex: Int = 0
    @State private var selectedAnswer: Int?
    @State private var showExplanation: Bool = false
    @State private var quizResult: QuizResult?
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color(.systemGray5))
                    Rectangle()
                        .fill(showingQuiz ? .green : .blue)
                        .frame(width: geo.size.width * progress)
                        .animation(.easeInOut, value: progress)
                }
            }
            .frame(height: 4)
            
            if let result = quizResult {
                // Quiz results
                quizResultView(result)
            } else if showingQuiz {
                // Quiz mode
                quizView
            } else {
                // Card mode
                cardView
            }
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var progress: Double {
        if let result = quizResult {
            return result.percentage > 0 ? 1.0 : 0.9
        }
        if showingQuiz {
            let quizProgress = lesson.quiz.isEmpty ? 1.0 : Double(currentQuizIndex) / Double(lesson.quiz.count)
            return 0.7 + (quizProgress * 0.3)
        }
        return lesson.cards.isEmpty ? 0 : Double(currentCardIndex + 1) / Double(lesson.cards.count) * 0.7
    }
    
    var cardView: some View {
        VStack(spacing: 0) {
            if currentCardIndex < lesson.cards.count {
                let card = lesson.cards[currentCardIndex]
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Card counter
                        HStack {
                            Text("Card \(currentCardIndex + 1) of \(lesson.cards.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            XPBadgeView(xp: XPEngine.lessonCardXP)
                        }
                        
                        if let iconName = card.iconName {
                            Image(systemName: iconName)
                                .font(.system(size: 40))
                                .foregroundStyle(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        
                        Text(card.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(card.content)
                            .font(.body)
                            .lineSpacing(4)
                        
                        if let fact = card.highlightFact {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundStyle(.yellow)
                                    .font(.title3)
                                
                                Text(fact)
                                    .font(.subheadline)
                                    .italic()
                            }
                            .padding()
                            .background(.yellow.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding()
                }
            }
            
            // Navigation buttons
            HStack {
                if currentCardIndex > 0 {
                    Button {
                        withAnimation { currentCardIndex -= 1 }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        if currentCardIndex < lesson.cards.count - 1 {
                            currentCardIndex += 1
                            appState.awardXP(XPEngine.lessonCardXP)
                        } else {
                            appState.awardXP(XPEngine.lessonCardXP)
                            showingQuiz = true
                        }
                    }
                } label: {
                    HStack {
                        Text(currentCardIndex < lesson.cards.count - 1 ? "Next" : "Start Quiz")
                        Image(systemName: "chevron.right")
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.blue)
                    .clipShape(Capsule())
                }
            }
            .padding()
        }
    }
    
    var quizView: some View {
        VStack(spacing: 0) {
            if currentQuizIndex < lesson.quiz.count {
                let question = lesson.quiz[currentQuizIndex]
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Question \(currentQuizIndex + 1) of \(lesson.quiz.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            XPBadgeView(xp: question.xpValue)
                        }
                        
                        Text(question.question)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 12) {
                            ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                                Button {
                                    if selectedAnswer == nil {
                                        selectedAnswer = index
                                        showExplanation = true
                                        quizAnswers.append(index)
                                    }
                                } label: {
                                    HStack {
                                        Text(option)
                                            .font(.subheadline)
                                            .foregroundStyle(.primary)
                                            .multilineTextAlignment(.leading)
                                        
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
                                    .padding()
                                    .background(optionBackground(index: index, question: question))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(optionBorder(index: index, question: question), lineWidth: 2)
                                    )
                                }
                                .disabled(selectedAnswer != nil)
                            }
                        }
                        
                        if showExplanation {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: selectedAnswer == question.correctIndex ? "checkmark.circle.fill" : "info.circle.fill")
                                        .foregroundStyle(selectedAnswer == question.correctIndex ? .green : .blue)
                                    Text(selectedAnswer == question.correctIndex ? "Correct!" : "Not quite!")
                                        .fontWeight(.bold)
                                        .foregroundStyle(selectedAnswer == question.correctIndex ? .green : .red)
                                }
                                
                                Text(question.explanation)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding()
                }
                
                if showExplanation {
                    Button {
                        withAnimation {
                            selectedAnswer = nil
                            showExplanation = false
                            if currentQuizIndex < lesson.quiz.count - 1 {
                                currentQuizIndex += 1
                            } else {
                                quizResult = QuizEngine.scoreQuiz(answers: quizAnswers, questions: lesson.quiz)
                            }
                        }
                    } label: {
                        Text(currentQuizIndex < lesson.quiz.count - 1 ? "Next Question" : "See Results")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.green)
                            .clipShape(Capsule())
                    }
                    .padding()
                }
            }
        }
    }
    
    func quizResultView(_ result: QuizResult) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: result.isPerfect ? "star.fill" : "checkmark.seal.fill")
                .font(.system(size: 60))
                .foregroundStyle(result.isPerfect ? .yellow : .green)
            
            Text(result.isPerfect ? "Perfect Score!" : "Lesson Complete!")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 8) {
                Text("\(result.correctCount)/\(result.totalCount) correct")
                    .font(.title3)
                
                Text("\(Int(result.percentage))%")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(result.percentage >= 80 ? .green : .orange)
            }
            
            XPBadgeView(xp: result.xpEarned + lesson.xpReward, animated: true)
                .scaleEffect(1.5)
            
            Spacer()
            
            Button {
                appState.completeLesson(lesson.id, xp: result.xpEarned + lesson.xpReward)
                appState.recordQuizCompletion(isPerfect: result.isPerfect)
                onComplete()
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.blue)
                    .clipShape(Capsule())
            }
            .padding()
        }
    }
    
    func optionBackground(index: Int, question: QuizQuestion) -> Color {
        guard let selected = selectedAnswer else { return Color(.systemGray6) }
        if index == question.correctIndex { return .green.opacity(0.1) }
        if index == selected { return .red.opacity(0.1) }
        return Color(.systemGray6)
    }
    
    func optionBorder(index: Int, question: QuizQuestion) -> Color {
        guard let selected = selectedAnswer else { return .clear }
        if index == question.correctIndex { return .green }
        if index == selected { return .red }
        return .clear
    }
}
