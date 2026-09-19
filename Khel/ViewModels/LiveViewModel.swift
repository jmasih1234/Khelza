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
    
    // Explain This
    var explainableEvent: MatchEvent?
    var isShowingExplanation: Bool = false
    
    // Contextual quiz (triggered by Explain This)
    var contextualQuiz: QuizQuestion?
    var isShowingContextualQuiz: Bool = false
    var contextualQuizTopic: KnowledgeTopic?
    
    // VAR state
    var eventUnderReview: MatchEvent?
    
    private var simulationTask: Task<Void, Never>?
    private let sportsProvider: any SportsDataProvider
    
    init(sportsProvider: (any SportsDataProvider)? = nil) {
        self.sportsProvider = sportsProvider ?? MockSportsDataProvider()
    }
    
    func loadAvailableMatches(for profile: UserProfile) {
        let leagueIDs = profile.favoriteLeagueIDs.isEmpty
            ? MockDataService.leagues.map(\.id)
            : profile.favoriteLeagueIDs
        
        Task { @MainActor in
            do {
                availableMatches = try await sportsProvider.liveMatches(leagueIDs: leagueIDs)
            } catch {
                availableMatches = []
            }
        }
    }
    
    /// Start the test match (Arsenal vs Liverpool scripted experience)
    func startTestMatch() {
        if let mockProvider = sportsProvider as? MockSportsDataProvider {
            currentMatch = mockProvider.testMatch
            startSimulation()
        }
    }
    
    func startMatch(_ match: Match) {
        currentMatch = match
        startSimulation()
    }
    
    func startSimulation() {
        guard let match = currentMatch else { return }
        isSimulating = true
        
        simulationTask = Task { @MainActor in
            for await event in sportsProvider.liveEventStream(for: match.id) {
                guard isSimulating, var currentMatch = self.currentMatch else { break }
                
                // Process event through the reconciliation engine
                MatchEventProcessor.processEvent(event, in: &currentMatch)
                self.currentMatch = currentMatch
                
                // Check for VAR review state
                if event.type == .varCheck, let relatedID = event.relatedEventID {
                    eventUnderReview = currentMatch.events.first { $0.id == relatedID }
                }
                
                // Clear VAR review when decision arrives
                if event.type == .goalDisallowed || event.type == .varDecision || event.type == .penaltyOverturned {
                    eventUnderReview = nil
                }
                
                // Trigger "Explain This" for key events
                if event.type.hasExplanation {
                    explainableEvent = event
                }
                
                // Trigger live quiz for educational events (existing behavior)
                if let quiz = QuizEngine.generateLiveQuiz(for: event) {
                    try? await Task.sleep(for: .seconds(2))
                    guard isSimulating else { break }
                    liveQuiz = quiz
                    isShowingQuiz = true
                }
                
                // Match ended
                if event.type == .fullTime {
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
    
    // MARK: - Explain This
    
    /// Show the explanation for the current explainable event
    func showExplanation() {
        guard explainableEvent != nil else { return }
        isShowingExplanation = true
    }
    
    /// Dismiss the explanation and optionally show the contextual quiz
    func dismissExplanation(showQuiz: Bool) {
        isShowingExplanation = false
        if showQuiz, let event = explainableEvent {
            contextualQuiz = generateContextualQuiz(for: event)
            contextualQuizTopic = knowledgeTopic(for: event)
            isShowingContextualQuiz = true
        }
        explainableEvent = nil
    }
    
    /// Answer the contextual quiz
    func answerContextualQuiz(optionIndex: Int) -> Bool {
        guard let quiz = contextualQuiz else { return false }
        let correct = optionIndex == quiz.correctIndex
        isShowingContextualQuiz = false
        contextualQuiz = nil
        return correct
    }
    
    // MARK: - Club lookups
    
    func homeClub() -> Club? {
        guard let match = currentMatch else { return nil }
        return MockDataService.club(byID: match.homeClubID)
    }
    
    func awayClub() -> Club? {
        guard let match = currentMatch else { return nil }
        return MockDataService.club(byID: match.awayClubID)
    }
    
    // MARK: - Private helpers
    
    private func generateContextualQuiz(for event: MatchEvent) -> QuizQuestion {
        switch event.type {
        case .goalDisallowed, .offside:
            return QuizQuestion(
                id: UUID(),
                question: "Which opponent is normally relevant when determining whether an attacker is in an offside position?",
                options: ["Goalkeeper", "Second-last opponent", "Nearest midfielder", "Captain"],
                correctIndex: 1,
                explanation: "A player is offside if they are nearer to the goal line than the second-last opponent (usually the last outfield defender, since the goalkeeper is typically the last). The second-last opponent is the reference point.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        case .redCard, .secondYellow:
            return QuizQuestion(
                id: UUID(),
                question: "How many players does a team have on the field after a red card?",
                options: ["9 players", "10 players", "11 players", "The player is replaced"],
                correctIndex: 1,
                explanation: "After a red card, the team plays with 10 players. The sent-off player cannot be replaced by a substitute. Playing with fewer players is a significant disadvantage.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        case .varCheck, .varDecision:
            return QuizQuestion(
                id: UUID(),
                question: "Which of these can VAR NOT review?",
                options: ["Goals", "Yellow cards", "Penalties", "Red cards"],
                correctIndex: 1,
                explanation: "VAR can only intervene on four types of decisions: goals, penalty decisions, direct red cards, and mistaken identity. Regular yellow cards cannot be reviewed by VAR.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        default:
            return QuizQuestion(
                id: UUID(),
                question: "How many substitutions are teams typically allowed in a match?",
                options: ["3", "4", "5", "Unlimited"],
                correctIndex: 2,
                explanation: "Since 2022, FIFA permanently adopted the rule allowing 5 substitutions per team per match, using a maximum of 3 substitution windows (plus half-time).",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        }
    }
    
    private func knowledgeTopic(for event: MatchEvent) -> KnowledgeTopic {
        switch event.type {
        case .goalDisallowed, .offside:
            return .offside
        case .varCheck, .varDecision:
            return .var_
        case .redCard, .secondYellow, .yellowCard:
            return .fouls
        default:
            return .offside
        }
    }
    
    deinit {
        simulationTask?.cancel()
    }
}
