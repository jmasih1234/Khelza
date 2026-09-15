import SwiftUI

struct MatchRecapView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = MatchRecapViewModel()
    let leagueID: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let match = viewModel.match {
                    // Score header
                    scoreHeader(match)
                    
                    // Key moments
                    if !viewModel.keyMoments.isEmpty {
                        keyMomentsSection
                    }
                    
                    // Stats
                    statsSection(match)
                    
                    // Recap quiz
                    recapQuizSection
                }
            }
            .padding()
        }
        .navigationTitle("Match Recap")
        .onAppear {
            viewModel.loadRecap(leagueID: leagueID)
        }
    }
    
    func scoreHeader(_ match: Match) -> some View {
        let home = MockDataService.club(byID: match.homeClubID)
        let away = MockDataService.club(byID: match.awayClubID)
        
        return VStack(spacing: 12) {
            HStack {
                VStack(spacing: 6) {
                    Circle()
                        .fill(home?.primaryColor ?? .gray)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Text(home?.shortName ?? "")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )
                    Text(home?.name ?? "Home")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 4) {
                    HStack(spacing: 12) {
                        Text("\(match.homeScore)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("-")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text("\(match.awayScore)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Text("Full Time")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 6) {
                    Circle()
                        .fill(away?.primaryColor ?? .gray)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Text(away?.shortName ?? "")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )
                    Text(away?.name ?? "Away")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var keyMomentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Moments")
                .font(.headline)
            
            ForEach(viewModel.keyMoments) { event in
                MatchEventRow(event: event)
                Divider()
            }
        }
    }
    
    func statsSection(_ match: Match) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Match Stats")
                .font(.headline)
            
            VStack(spacing: 8) {
                statBar("Possession", home: match.stats.possessionHome, away: match.stats.possessionAway)
                statBar("Shots", home: match.stats.shotsHome, away: match.stats.shotsAway)
                statBar("On Target", home: match.stats.shotsOnTargetHome, away: match.stats.shotsOnTargetAway)
                statBar("Corners", home: match.stats.cornersHome, away: match.stats.cornersAway)
                statBar("Fouls", home: match.stats.foulsHome, away: match.stats.foulsAway)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    func statBar(_ label: String, home: Int, away: Int) -> some View {
        HStack {
            Text("\(home)")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(width: 36, alignment: .trailing)
            
            GeometryReader { geo in
                let total = max(home + away, 1)
                let homeWidth = geo.size.width * CGFloat(home) / CGFloat(total)
                HStack(spacing: 2) {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: homeWidth)
                    Rectangle()
                        .fill(.red.opacity(0.7))
                }
                .clipShape(Capsule())
            }
            .frame(height: 8)
            
            Text("\(away)")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(width: 36, alignment: .leading)
        }
        .overlay {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
    
    var recapQuizSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Test Your Recall")
                    .font(.headline)
                Spacer()
                if !viewModel.showingQuiz {
                    Button("Start Quiz") {
                        viewModel.startQuiz()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                }
            }
            
            if viewModel.showingQuiz {
                ForEach(Array(viewModel.recapQuiz.enumerated()), id: \.element.id) { index, question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question.question)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ForEach(Array(question.options.enumerated()), id: \.offset) { optIndex, option in
                            Button {
                                viewModel.answerRecapQuiz(optIndex)
                            } label: {
                                Text(option)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                            .disabled(index < viewModel.quizAnswers.count)
                        }
                    }
                }
                
                if let result = viewModel.quizResult {
                    HStack {
                        Text("\(result.correctCount)/\(result.totalCount) correct!")
                            .fontWeight(.bold)
                        Spacer()
                        XPBadgeView(xp: result.xpEarned, animated: true)
                    }
                    .padding()
                    .background(.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MatchRecapView(leagueID: "premier-league")
            .environment(AppState())
    }
}
