import Foundation

@Observable
class HomeViewModel {
    var upcomingMatches: [Match] = []
    var liveMatches: [Match] = []
    var dailyChallenge: DailyChallenge?
    var recommendedLessons: [Lesson] = []
    var recentActivity: [ActivityItem] = []
    
    func loadHomeData(for profile: UserProfile) {
        let leagueIDs = profile.favoriteLeagueIDs.isEmpty
            ? MockDataService.leagues.map(\.id)
            : profile.favoriteLeagueIDs
        
        upcomingMatches = MockDataService.generateUpcomingMatches(for: leagueIDs, count: 8)
        
        // Generate 1-2 live matches randomly
        if Bool.random() {
            let leagueID = leagueIDs.randomElement() ?? "premier-league"
            liveMatches = [MockDataService.generateLiveMatch(leagueID: leagueID)]
        }
        
        dailyChallenge = MockDataService.generateDailyChallenge()
        
        recommendedLessons = LessonEngine.recommendedLessons(
            for: profile,
            allTracks: MockDataService.lessonTracks,
            limit: 3
        )
    }
    
    func greeting(for profile: UserProfile) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting: String
        switch hour {
        case 0..<12: timeGreeting = "Good morning"
        case 12..<17: timeGreeting = "Good afternoon"
        default: timeGreeting = "Good evening"
        }
        let name = profile.name.isEmpty ? "Fan" : profile.name
        return "\(timeGreeting), \(name)!"
    }
}
