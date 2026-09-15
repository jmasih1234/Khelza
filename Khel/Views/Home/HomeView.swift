import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = HomeViewModel()
    @State private var showFreddy = false
    @State private var showCalendar = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.greeting(for: appState.userProfile))
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Level \(appState.userProfile.level) • \(appState.userProfile.totalXP) XP")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        StreakFlame(count: appState.userProfile.currentStreak)
                    }
                    .padding(.horizontal)
                    
                    // Live matches
                    if !viewModel.liveMatches.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Live Now")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.liveMatches) { match in
                                LiveMatchBanner(match: match) {
                                    appState.selectedTab = .live
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Daily Challenge
                    if let challenge = viewModel.dailyChallenge {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Daily Challenge")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            GradientCard(colors: [.orange, .red]) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(challenge.title)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text(challenge.description)
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.8))
                                        
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .font(.caption)
                                            Text("+\(challenge.xpReward) XP")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                        }
                                        .foregroundStyle(.yellow)
                                        .padding(.top, 2)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        appState.selectedTab = .games
                                    } label: {
                                        Text("Start")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.orange)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 8)
                                            .background(.white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Continue Learning
                    if !viewModel.recommendedLessons.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Continue Learning")
                                    .font(.headline)
                                Spacer()
                                Button("See All") {
                                    appState.selectedTab = .learn
                                }
                                .font(.subheadline)
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.recommendedLessons) { lesson in
                                        RecommendedLessonCard(lesson: lesson)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Upcoming Matches
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Upcoming Matches")
                                .font(.headline)
                            Spacer()
                            Button("Calendar") {
                                showCalendar = true
                            }
                            .font(.subheadline)
                        }
                        .padding(.horizontal)
                        
                        ForEach(viewModel.upcomingMatches.prefix(5)) { match in
                            UpcomingMatchCard(match: match)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Khel")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFreddy = true
                    } label: {
                        Label("Freddy", systemImage: "bubble.left.and.bubble.right.fill")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCalendar = true
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
            .sheet(isPresented: $showFreddy) {
                AIGuideView()
                    .environment(appState)
            }
            .sheet(isPresented: $showCalendar) {
                MatchCalendarView()
                    .environment(appState)
            }
            .onAppear {
                viewModel.loadHomeData(for: appState.userProfile)
            }
        }
    }
}

struct RecommendedLessonCard: View {
    let lesson: Lesson
    
    private var track: LessonTrack? {
        MockDataService.lessonTracks.first { $0.id == lesson.trackID }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: track?.topic.icon ?? "book.fill")
                    .foregroundStyle(track?.topic.color ?? .blue)
                Text(track?.topic.rawValue ?? "")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Text(lesson.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            Text(lesson.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            
            HStack {
                Image(systemName: "clock")
                    .font(.caption2)
                Text("\(lesson.estimatedMinutes) min")
                    .font(.caption2)
                Spacer()
                Text("+\(lesson.xpReward) XP")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 200)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    HomeView()
        .environment(AppState())
}
