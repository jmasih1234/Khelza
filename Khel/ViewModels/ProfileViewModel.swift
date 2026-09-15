import Foundation

@Observable
class ProfileViewModel {
    var badges: [Badge] = []
    var leagueProgress: [(leagueID: String, leagueName: String, progress: Double)] = []
    
    func loadProfile(_ profile: UserProfile) {
        // Load badges with earned status
        badges = MockDataService.allBadges.map { badge in
            var b = badge
            b.isEarned = profile.earnedBadgeIDs.contains(badge.id)
            if b.isEarned {
                b.earnedDate = Date()
            }
            return b
        }
        
        // Calculate per-league progress
        let completedIDs = Set(profile.completedLessonIDs)
        leagueProgress = profile.favoriteLeagueIDs.compactMap { leagueID in
            guard let league = MockDataService.league(byID: leagueID) else { return nil }
            
            // Calculate what percentage of lessons related to this league are complete
            let relevantLessons = MockDataService.lessonTracks.flatMap(\.lessons).filter {
                $0.relatedLeagueIDs.contains(leagueID)
            }
            let completed = relevantLessons.filter { completedIDs.contains($0.id) }.count
            let total = max(relevantLessons.count, 1)
            
            return (leagueID: leagueID, leagueName: league.name, progress: Double(completed) / Double(total))
        }
    }
    
    var earnedBadges: [Badge] {
        badges.filter(\.isEarned)
    }
    
    var unearnedBadges: [Badge] {
        badges.filter { !$0.isEarned }
    }
    
    func xpProgress(for profile: UserProfile) -> (current: Int, needed: Int) {
        XPEngine.xpProgressInCurrentLevel(totalXP: profile.totalXP)
    }
    
    func xpProgressPercentage(for profile: UserProfile) -> Double {
        let progress = xpProgress(for: profile)
        guard progress.needed > 0 else { return 0 }
        return Double(progress.current) / Double(progress.needed)
    }
}
