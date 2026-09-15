import SwiftUI

struct LiveMatchCompanionView: View {
    @Environment(AppState.self) private var appState
    @State var viewModel: LiveViewModel
    
    var body: some View {
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
                                MatchEventRow(event: event)
                                    .id(event.id)
                                
                                Divider()
                                    .padding(.leading, 66)
                            }
                        }
                        
                        // Live quiz
                        if viewModel.isShowingQuiz, let quiz = viewModel.liveQuiz {
                            LiveQuizBanner(question: quiz) { answer in
                                let correct = viewModel.answerLiveQuiz(optionIndex: answer)
                                if correct {
                                    appState.awardXP(XPEngine.liveQuizCorrectXP)
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
