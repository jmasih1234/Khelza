import Foundation
import SwiftUI

@Observable
class LiveViewModel {
    var currentMatch: Match?
    var availableMatches: [Match] = []
    var liveQuiz: QuizQuestion?
    var isShowingQuiz: Bool = false
    var lastQuizCorrect: Bool?
    var isSimulating: Bool = false
    var showStats: Bool = false
    
    private var simulationTask: Task<Void, Never>?
    
    func loadAvailableMatches(for profile: UserProfile) {
        let leagueIDs = profile.favoriteLeagueIDs.isEmpty
            ? MockDataService.leagues.map(\.id)
            : profile.favoriteLeagueIDs
        
        availableMatches = leagueIDs.compactMap { leagueID in
            let clubs = MockDataService.clubs(forLeague: leagueID)
            guard clubs.count >= 2 else { return nil as Match? }
            return MockDataService.generateLiveMatch(leagueID: leagueID)
        }
    }
    
    func startMatch(_ match: Match) {
        currentMatch = match
        startSimulation()
    }
    
    func startSimulation() {
        guard currentMatch != nil else { return }
        isSimulating = true
        
        simulationTask = Task { @MainActor in
            while isSimulating, var match = currentMatch, match.currentMinute < 90 {
                try? await Task.sleep(for: .seconds(Double.random(in: 8...20)))
                
                guard isSimulating else { break }
                
                let event = MockDataService.generateNextEvent(match: match)
                match.events.append(event)
                match.currentMinute = event.minute
                
                if event.type == .goal {
                    if event.clubID == match.homeClubID {
                        match.homeScore += 1
                    } else {
                        match.awayScore += 1
                    }
                }
                
                currentMatch = match
                
                // Trigger quiz for educational events
                if let quiz = QuizEngine.generateLiveQuiz(for: event) {
                    try? await Task.sleep(for: .seconds(2))
                    guard isSimulating else { break }
                    liveQuiz = quiz
                    isShowingQuiz = true
                }
                
                if match.currentMinute >= 90 {
                    match.status = .finished
                    match.events.append(MatchEvent(
                        id: UUID(), minute: 90, type: .fullTime,
                        playerName: "", clubID: match.homeClubID,
                        description: "Full time!",
                        educationalNote: "The match is over. Three points for a win, one for a draw."
                    ))
                    currentMatch = match
                    isSimulating = false
                }
            }
        }
    }
    
    func stopSimulation() {
        isSimulating = false
        simulationTask?.cancel()
        simulationTask = nil
    }
    
    func answerLiveQuiz(optionIndex: Int) -> Bool {
        guard let quiz = liveQuiz else { return false }
        let correct = optionIndex == quiz.correctIndex
        lastQuizCorrect = correct
        isShowingQuiz = false
        liveQuiz = nil
        return correct
    }
    
    func homeClub() -> Club? {
        guard let match = currentMatch else { return nil }
        return MockDataService.club(byID: match.homeClubID)
    }
    
    func awayClub() -> Club? {
        guard let match = currentMatch else { return nil }
        return MockDataService.club(byID: match.awayClubID)
    }
    
    deinit {
        simulationTask?.cancel()
    }
}
