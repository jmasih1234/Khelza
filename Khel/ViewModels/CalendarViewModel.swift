import Foundation

@Observable
class CalendarViewModel {
    var selectedDate: Date = Date()
    var allMatches: [Match] = []
    
    func loadMatches(for profile: UserProfile) {
        let leagueIDs = profile.favoriteLeagueIDs.isEmpty
            ? MockDataService.leagues.map(\.id)
            : profile.favoriteLeagueIDs
        
        allMatches = MockDataService.generateUpcomingMatches(for: leagueIDs, count: 30)
        
        // Add some finished matches in the past
        for leagueID in leagueIDs.prefix(3) {
            allMatches.append(MockDataService.generateFinishedMatch(leagueID: leagueID))
        }
        
        allMatches.sort { $0.kickoffDate < $1.kickoffDate }
    }
    
    func matchesForDate(_ date: Date) -> [Match] {
        let calendar = Calendar.current
        return allMatches.filter { calendar.isDate($0.kickoffDate, inSameDayAs: date) }
    }
    
    func datesWithMatches() -> Set<DateComponents> {
        let calendar = Calendar.current
        var dates = Set<DateComponents>()
        for match in allMatches {
            let components = calendar.dateComponents([.year, .month, .day], from: match.kickoffDate)
            dates.insert(components)
        }
        return dates
    }
    
    var matchesForSelectedDate: [Match] {
        matchesForDate(selectedDate)
    }
}
