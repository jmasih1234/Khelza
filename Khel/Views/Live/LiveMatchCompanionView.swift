import SwiftUI

struct LiveMatchCompanionView: View {
    @Environment(AppState.self) private var appState
    @State var viewModel: LiveViewModel
    @State private var xpAwarded: Int = 0
    @State private var showXPToast: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Match header
                if let match = viewModel.currentMatch {
                    matchHeader(match)
                }
                
                // Events timeline
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            if let match = viewModel.currentMatch {
                                ForEach(match.events) { event in
                                    MatchEventRow(event: event) {
                                        viewModel.explainableEvent = event
                                        viewModel.showExplanation()
                                    }
                                    .id(event.id)
                                    .padding(.horizontal)
                                    
                                    Divider()
                                        .padding(.leading, 66)
                                }
                            }
                            
                            // VAR Review banner
                            if let reviewEvent = viewModel.eventUnderReview {
                                varReviewBanner(reviewEvent)
                                    .padding()
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                            
                            // Live quiz (existing behavior)
                            if viewModel.isShowingQuiz, let quiz = viewModel.liveQuiz {
                                LiveQuizBanner(question: quiz) { answer in
                                    let correct = viewModel.answerLiveQuiz(optionIndex: answer)
                                    if correct {
                                        Task {
                                            let gamification = MockGamificationRepository(appState: appState)
                                            let txn = await gamification.awardXP(
                                                amount: XPEngine.liveQuizCorrectXP,
                                                reason: .liveQuizCorrect
                                            )
                                            xpAwarded = txn.amount
                                            showXPToast = true
                                        }
                                    }
                                }
                                .padding()
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                            
                            if viewModel.isSimulating {
                                HStack(spacing: 8) {
                                    ProgressView()
                                    Text("Watching match...")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                            }
                        }
                    }
                    .onChange(of: viewModel.currentMatch?.events.count) {
                        if let lastEvent = viewModel.currentMatch?.events.last {
                            withAnimation {
                                proxy.scrollTo(lastEvent.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Stats toggle
                if let match = viewModel.currentMatch {
                    statsBar(match)
                }
            }
            
            // Explain This overlay
            if viewModel.isShowingExplanation, let event = viewModel.explainableEvent {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            viewModel.dismissExplanation(showQuiz: false)
                        }
                    }
                
                ExplainThisView(
                    event: event,
                    knowledgeLevel: appState.userProfile.knowledgeLevel,
                    onDismiss: {
                        withAnimation {
                            viewModel.dismissExplanation(showQuiz: false)
                        }
                    },
                    onTakeQuiz: {
                        withAnimation {
                            viewModel.dismissExplanation(showQuiz: true)
                        }
                    }
                )
                .padding()
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            
            // Contextual Quiz overlay
            if viewModel.isShowingContextualQuiz,
               let quiz = viewModel.contextualQuiz,
               let topic = viewModel.contextualQuizTopic {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ContextualQuizView(
                    question: quiz,
                    topic: topic
                ) { correct in
                    Task {
                        if correct {
                            let gamification = MockGamificationRepository(appState: appState)
                            let txn = await gamification.awardXP(
                                amount: XPEngine.liveQuizCorrectXP,
                                reason: .contextualQuizCorrect,
                                metadata: ["topic": topic.id]
                            )
                            xpAwarded = txn.amount
                            showXPToast = true
                            
                            // Update knowledge profile
                            let knowledge = MockKnowledgeRepository(appState: appState)
                            await knowledge.recordCorrectAnswer(for: topic)
                        } else {
                            let knowledge = MockKnowledgeRepository(appState: appState)
                            await knowledge.recordIncorrectAnswer(for: topic)
                        }
                    }
                    
                    // Dismiss after delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            _ = viewModel.answerContextualQuiz(optionIndex: 0)
                        }
                    }
                }
                .padding()
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
            
            // XP toast
            if showXPToast {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("+\(xpAwarded) XP earned!")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .shadow(radius: 10)
                    .padding(.bottom, 80)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            showXPToast = false
                        }
                    }
                }
            }
        }
        .animation(.spring(response: 0.4), value: viewModel.isShowingExplanation)
        .animation(.spring(response: 0.4), value: viewModel.isShowingContextualQuiz)
        .animation(.spring(response: 0.4), value: showXPToast)
        .animation(.spring(response: 0.4), value: viewModel.eventUnderReview?.id)
        .navigationTitle("Live Match")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.showStats.toggle()
                } label: {
                    Image(systemName: "chart.bar.fill")
                }
            }
        }
        .sheet(isPresented: $viewModel.showStats) {
            if let match = viewModel.currentMatch {
                matchStatsSheet(match)
            }
        }
        .onDisappear {
            viewModel.stopSimulation()
        }
    }
    
    // MARK: - VAR Review Banner
    
    func varReviewBanner(_ event: MatchEvent) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "tv.fill")
                .font(.title3)
                .foregroundStyle(.purple)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("VAR REVIEW IN PROGRESS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.purple)
                
                Text("Checking: \(event.description)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            ProgressView()
                .tint(.purple)
        }
        .padding(12)
        .background(.purple.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.purple.opacity(0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Match Header
    
    func matchHeader(_ match: Match) -> some View {
        let home = viewModel.homeClub()
        let away = viewModel.awayClub()
        
        return VStack(spacing: 8) {
            HStack {
                VStack(spacing: 4) {
                    Circle()
                        .fill(home?.primaryColor ?? .gray)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(home?.shortName ?? "")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )
                    Text(home?.name ?? "Home")
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(1)
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
                    
                    HStack(spacing: 4) {
                        if match.status.isActive {
                            Circle()
                                .fill(.red)
                                .frame(width: 6, height: 6)
                        }
                        Text(match.status.isActive ? "\(match.currentMinute)'" : match.status.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(match.status.isActive ? .red : .secondary)
                    }
                }
                
                VStack(spacing: 4) {
                    Circle()
                        .fill(away?.primaryColor ?? .gray)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(away?.shortName ?? "")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )
                    Text(away?.name ?? "Away")
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    // MARK: - Stats
    
    func statsBar(_ match: Match) -> some View {
        HStack(spacing: 16) {
            statItem("Poss", home: "\(match.stats.possessionHome)%", away: "\(match.stats.possessionAway)%")
            Divider().frame(height: 30)
            statItem("Shots", home: "\(match.stats.shotsHome)", away: "\(match.stats.shotsAway)")
            Divider().frame(height: 30)
            statItem("On Target", home: "\(match.stats.shotsOnTargetHome)", away: "\(match.stats.shotsOnTargetAway)")
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
    
    func statItem(_ label: String, home: String, away: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            HStack(spacing: 8) {
                Text(home)
                    .font(.caption)
                    .fontWeight(.bold)
                Text("-")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(away)
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
    }
    
    func matchStatsSheet(_ match: Match) -> some View {
        NavigationStack {
            List {
                statRow("Possession", home: "\(match.stats.possessionHome)%", away: "\(match.stats.possessionAway)%")
                statRow("Shots", home: "\(match.stats.shotsHome)", away: "\(match.stats.shotsAway)")
                statRow("Shots on Target", home: "\(match.stats.shotsOnTargetHome)", away: "\(match.stats.shotsOnTargetAway)")
                statRow("Corners", home: "\(match.stats.cornersHome)", away: "\(match.stats.cornersAway)")
                statRow("Fouls", home: "\(match.stats.foulsHome)", away: "\(match.stats.foulsAway)")
                statRow("Pass Accuracy", home: "\(match.stats.passAccuracyHome)%", away: "\(match.stats.passAccuracyAway)%")
            }
            .navigationTitle("Match Stats")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
    }
    
    func statRow(_ label: String, home: String, away: String) -> some View {
        HStack {
            Text(home)
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            Text(away)
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
        }
    }
}
