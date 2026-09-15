import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = ProfileViewModel()
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    profileHeader
                    
                    // XP Progress
                    xpSection
                    
                    // Streak
                    streakSection
                    
                    // Badges
                    badgesSection
                    
                    // League Progress
                    if !viewModel.leagueProgress.isEmpty {
                        leagueProgressSection
                    }
                    
                    // Stats
                    statsSection
                }
                .padding()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environment(appState)
            }
            .onAppear {
                viewModel.loadProfile(appState.userProfile)
            }
        }
    }
    
    var profileHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.15))
                    .frame(width: 80, height: 80)
                
                Text(String(appState.userProfile.name.prefix(1)).uppercased())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            }
            
            Text(appState.userProfile.name.isEmpty ? "Fan" : appState.userProfile.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(appState.userProfile.knowledgeLevel.rawValue) • Joined \(appState.userProfile.createdAt, format: .dateTime.month().year())")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    var xpSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Level \(appState.userProfile.level)")
                    .font(.headline)
                Spacer()
                Text("\(appState.userProfile.totalXP) XP total")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            let progress = viewModel.xpProgress(for: appState.userProfile)
            
            VStack(spacing: 4) {
                ProgressView(value: Double(progress.current), total: Double(max(progress.needed, 1)))
                    .tint(.blue)
                
                HStack {
                    Text("\(progress.current) XP")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(progress.needed) XP to Level \(appState.userProfile.level + 1)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var streakSection: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                StreakFlame(count: appState.userProfile.currentStreak, size: 32)
                Text("Current")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 40)
            
            VStack(spacing: 4) {
                Text("\(appState.userProfile.longestStreak)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Best Streak")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 40)
            
            VStack(spacing: 4) {
                Text("\(appState.userProfile.completedLessonIDs.count)")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Lessons")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var badgesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Badges")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.earnedBadges.count)/\(viewModel.badges.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.badges) { badge in
                        VStack(spacing: 6) {
                            Image(systemName: badge.iconName)
                                .font(.title2)
                                .foregroundStyle(badge.isEarned ? Color(hex: badge.iconColor) : .gray)
                                .frame(width: 44, height: 44)
                                .background(badge.isEarned ? Color(hex: badge.iconColor).opacity(0.15) : Color(.systemGray5))
                                .clipShape(Circle())
                                .opacity(badge.isEarned ? 1.0 : 0.5)
                            
                            Text(badge.name)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            
                            Text(badge.description)
                                .font(.system(size: 9))
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 80)
                    }
                }
            }
        }
    }
    
    var leagueProgressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("League Knowledge")
                .font(.headline)
            
            ForEach(viewModel.leagueProgress, id: \.leagueID) { item in
                let league = MockDataService.league(byID: item.leagueID)
                HStack(spacing: 12) {
                    Text(league?.flagEmoji ?? "")
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.leagueName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ProgressView(value: item.progress)
                            .tint(league?.primaryColor ?? .blue)
                    }
                    
                    Text("\(Int(item.progress * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stats")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statCard("Quizzes Taken", value: "\(appState.userProfile.quizzesTaken)", icon: "questionmark.circle.fill", color: .blue)
                statCard("Perfect Scores", value: "\(appState.userProfile.perfectQuizzes)", icon: "star.fill", color: .yellow)
                statCard("Predictions", value: "\(appState.userProfile.correctPredictions)", icon: "eye.fill", color: .purple)
                statCard("Clubs Following", value: "\(appState.userProfile.favoriteClubIDs.count)", icon: "shield.fill", color: .green)
            }
        }
    }
    
    func statCard(_ title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(appState.userProfile.name)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Level")
                        Spacer()
                        Text(appState.userProfile.knowledgeLevel.rawValue)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Following") {
                    HStack {
                        Text("Leagues")
                        Spacer()
                        Text("\(appState.userProfile.favoriteLeagueIDs.count)")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Clubs")
                        Spacer()
                        Text("\(appState.userProfile.favoriteClubIDs.count)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section {
                    Button("Reset Progress", role: .destructive) {
                        appState.resetOnboarding()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
}
