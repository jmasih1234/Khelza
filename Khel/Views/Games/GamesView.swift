import SwiftUI

struct GamesView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = GamesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Daily Challenge
                    if let challenge = viewModel.dailyChallenge, !challenge.isCompleted {
                        dailyChallengeCard(challenge)
                    }
                    
                    // Quick Trivia
                    triviaSection
                    
                    // Predictions
                    predictionsSection
                    
                    // Leaderboard
                    leaderboardSection
                }
                .padding()
            }
            .navigationTitle("Games")
            .sheet(isPresented: $viewModel.isTriviaActive) {
                triviaSheet
            }
            .sheet(isPresented: $viewModel.showingTriviaResult) {
                if let result = viewModel.triviaResult {
                    triviaResultSheet(result)
                }
            }
            .onAppear {
                viewModel.loadData(for: appState.userProfile)
            }
        }
    }
    
    func dailyChallengeCard(_ challenge: DailyChallenge) -> some View {
        GradientCard(colors: [.orange, .red]) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "star.circle.fill")
                        .font(.title2)
                    Text("Daily Challenge")
                        .font(.headline)
                    Spacer()
                    Text("+\(challenge.xpReward) XP")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                .foregroundStyle(.white)
                
                Text(challenge.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Text(challenge.description)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                
                Button {
                    viewModel.startTrivia()
                } label: {
                    Text("Start Challenge")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
        }
    }
    
    var triviaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Trivia")
                .font(.headline)
            
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(LessonTopic.allCases) { topic in
                    Button {
                        viewModel.startTrivia(topic: topic)
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: topic.icon)
                                .font(.title2)
                                .foregroundStyle(topic.color)
                            Text(topic.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(topic.color.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    var predictionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Predict Scores")
                .font(.headline)
            
            if viewModel.upcomingMatchesForPrediction.isEmpty {
                Text("No upcoming matches to predict")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.upcomingMatchesForPrediction.prefix(3)) { match in
                    PredictionCard(
                        match: match,
                        hasPrediction: viewModel.hasPrediction(for: match.id),
                        onSubmit: { home, away in
                            viewModel.submitPrediction(matchID: match.id, home: home, away: away)
                        }
                    )
                }
            }
        }
    }
    
    var leaderboardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Leaderboard")
                    .font(.headline)
                Spacer()
            }
            
            ForEach(viewModel.leaderboard.prefix(5)) { entry in
                HStack(spacing: 12) {
                    Text("#\(entry.rank)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(entry.rank <= 3 ? .yellow : .secondary)
                        .frame(width: 30)
                    
                    Text(entry.avatarEmoji)
                        .font(.title3)
                    
                    VStack(alignment: .leading) {
                        Text(entry.userName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Level \(entry.level)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(entry.xp) XP")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var triviaSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let question = viewModel.currentQuestion {
                    // Progress
                    ProgressView(value: Double(viewModel.currentQuestionIndex), total: Double(viewModel.triviaQuestions.count))
                        .tint(.blue)
                        .padding(.horizontal)
                    
                    Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.triviaQuestions.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(question.question)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                            Button {
                                _ = viewModel.answerTrivia(index)
                            } label: {
                                Text(option)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Trivia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Quit") {
                        viewModel.resetTrivia()
                    }
                }
            }
        }
    }
    
    func triviaResultSheet(_ result: QuizResult) -> some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: result.isPerfect ? "star.fill" : "checkmark.seal.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(result.isPerfect ? .yellow : .green)
                
                Text(result.isPerfect ? "Perfect!" : "Well Done!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("\(result.correctCount)/\(result.totalCount) correct")
                    .font(.title3)
                
                XPBadgeView(xp: result.xpEarned, animated: true)
                    .scaleEffect(1.3)
                
                Spacer()
                
                Button {
                    appState.awardXP(result.xpEarned)
                    appState.recordQuizCompletion(isPerfect: result.isPerfect)
                    viewModel.showingTriviaResult = false
                    viewModel.resetTrivia()
                } label: {
                    Text("Done")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct PredictionCard: View {
    let match: Match
    let hasPrediction: Bool
    var onSubmit: (Int, Int) -> Void
    
    @State private var homeScore: Int = 0
    @State private var awayScore: Int = 0
    @State private var submitted = false
    
    var homeClub: Club? { MockDataService.club(byID: match.homeClubID) }
    var awayClub: Club? { MockDataService.club(byID: match.awayClubID) }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                clubLabel(homeClub)
                
                if submitted || hasPrediction {
                    Text("\(homeScore) - \(awayScore)")
                        .font(.headline)
                        .fontWeight(.bold)
                } else {
                    HStack(spacing: 12) {
                        Stepper("", value: $homeScore, in: 0...10)
                            .labelsHidden()
                            .fixedSize()
                        Text("\(homeScore) - \(awayScore)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .monospacedDigit()
                        Stepper("", value: $awayScore, in: 0...10)
                            .labelsHidden()
                            .fixedSize()
                    }
                }
                
                clubLabel(awayClub)
            }
            
            if !submitted && !hasPrediction {
                Button {
                    onSubmit(homeScore, awayScore)
                    submitted = true
                } label: {
                    Text("Submit Prediction")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(.purple)
                        .clipShape(Capsule())
                }
            } else {
                Text("Prediction submitted!")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    func clubLabel(_ club: Club?) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(club?.primaryColor ?? .gray)
                .frame(width: 28, height: 28)
                .overlay(
                    Text(club?.shortName ?? "")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(.white)
                )
            Text(club?.shortName ?? "")
                .font(.caption2)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    GamesView()
        .environment(AppState())
}
