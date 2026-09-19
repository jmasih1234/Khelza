import Foundation

/// Mock implementation of SportsDataProvider using hardcoded data and deterministic match simulation.
/// Replace with ProductionSportsDataProvider when connecting to real APIs.
final class MockSportsDataProvider: SportsDataProvider {
    
    // MARK: - Deterministic Test Match
    
    /// The scripted Arsenal vs Liverpool test match for the vertical slice
    private(set) var testMatch: Match
    private let scriptedEvents: [MatchEvent]
    
    init() {
        let arsenalID = "arsenal"
        let liverpoolID = "liverpool"
        let matchID = UUID()
        
        // Pre-generate event IDs so relatedEventID references work
        let goalEventID = UUID()
        
        let events: [MatchEvent] = [
            MatchEvent(
                minute: 12,
                type: .goal,
                playerName: "Bukayo Saka",
                clubID: arsenalID,
                description: "GOAL! Saka cuts inside and curls into the far corner.",
                educationalNote: "A goal is scored when the ball fully crosses the goal line between the posts and under the crossbar."
            ),
            MatchEvent(
                minute: 29,
                type: .yellowCard,
                playerName: "Virgil van Dijk",
                clubID: liverpoolID,
                description: "Van Dijk is booked for a late challenge on Saka.",
                educationalNote: "A yellow card is a caution. Two yellows in one match result in a red card and the player must leave the field."
            ),
            MatchEvent(
                minute: 45,
                type: .halfTime,
                playerName: "",
                clubID: "",
                description: "Half Time. Arsenal 1 - 0 Liverpool."
            ),
            MatchEvent(
                minute: 45,
                type: .secondHalfStart,
                playerName: "",
                clubID: "",
                description: "The second half is underway."
            ),
            MatchEvent(
                minute: 58,
                type: .substitution,
                playerName: "Diogo Jota",
                clubID: liverpoolID,
                description: "Substitution: Jota comes on for Gakpo.",
                educationalNote: "Managers make substitutions to change tactics, bring in fresh legs, or respond to injuries. Each team is typically allowed 5 substitutions per match."
            ),
            MatchEvent(
                minute: 67,
                type: .goal,
                playerName: "Mohamed Salah",
                clubID: liverpoolID,
                description: "GOAL! Salah equalizes with a clinical finish from the edge of the box.",
                educationalNote: "An equalizer brings the scores level. Momentum in a match can shift dramatically after an equalizer."
            ),
            MatchEvent(
                id: goalEventID,
                minute: 72,
                type: .goal,
                playerName: "Martin Ødegaard",
                clubID: arsenalID,
                description: "GOAL! Ødegaard fires Arsenal back in front!",
                educationalNote: "Taking the lead again after conceding an equalizer shows mental resilience — a key quality in top teams.",
                status: .confirmed  // Will be overturned by VAR
            ),
            MatchEvent(
                minute: 73,
                type: .varCheck,
                playerName: "",
                clubID: "",
                description: "VAR is checking the goal for a possible offside.",
                educationalNote: "VAR (Video Assistant Referee) reviews four types of decisions: goals, penalties, direct red cards, and mistaken identity. The process typically takes 1-3 minutes.",
                status: .confirmed,
                relatedEventID: goalEventID
            ),
            MatchEvent(
                minute: 74,
                type: .goalDisallowed,
                playerName: "Martin Ødegaard",
                clubID: arsenalID,
                description: "GOAL DISALLOWED! Ødegaard was offside by millimeters. The score remains 1-1.",
                educationalNote: "A player is in an offside position if they are nearer to the opponent's goal line than both the ball and the second-last opponent when the ball is played to them. Even a fraction offside means the goal doesn't count.",
                status: .confirmed,
                relatedEventID: goalEventID
            ),
            MatchEvent(
                minute: 81,
                type: .redCard,
                playerName: "Declan Rice",
                clubID: arsenalID,
                description: "RED CARD! Rice receives a straight red for a dangerous tackle.",
                educationalNote: "A red card means the player must leave the field immediately. The team plays with 10 players for the rest of the match. This is a major advantage for the opposing team."
            ),
            MatchEvent(
                minute: 90,
                type: .fullTime,
                playerName: "",
                clubID: "",
                description: "Full Time. Arsenal 1 - 1 Liverpool."
            ),
        ]
        
        self.scriptedEvents = events
        self.testMatch = Match(
            id: matchID,
            homeClubID: arsenalID,
            awayClubID: liverpoolID,
            leagueID: "premier-league",
            status: .live,
            homeScore: 0,
            awayScore: 0,
            kickoffDate: Date(),
            matchDay: 12,
            currentMinute: 0,
            events: [],
            stats: .empty
        )
    }
    
    // MARK: - SportsDataProvider conformance
    
    func leagues() async throws -> [League] {
        MockDataService.leagues
    }
    
    func clubs(forLeague leagueID: String) async throws -> [Club] {
        MockDataService.clubs(forLeague: leagueID)
    }
    
    func club(byID id: String) async throws -> Club? {
        MockDataService.club(byID: id)
    }
    
    func player(byID id: String) async throws -> Player? {
        MockDataService.player(byID: id)
    }
    
    func upcomingMatches(leagueIDs: [String], limit: Int) async throws -> [Match] {
        MockDataService.generateUpcomingMatches(for: leagueIDs, count: limit)
    }
    
    func liveMatches(leagueIDs: [String]) async throws -> [Match] {
        [testMatch]
    }
    
    func finishedMatches(leagueIDs: [String], limit: Int) async throws -> [Match] {
        (0..<limit).map { _ in
            MockDataService.generateFinishedMatch(leagueID: leagueIDs.randomElement() ?? "premier-league")
        }
    }
    
    /// Streams scripted events with realistic pacing
    func liveEventStream(for matchID: UUID) -> AsyncStream<MatchEvent> {
        let events = scriptedEvents
        
        return AsyncStream { continuation in
            Task {
                for event in events {
                    // Simulate time between events (2-5 seconds for demo pacing)
                    try? await Task.sleep(for: .seconds(Double.random(in: 2.5...5.0)))
                    
                    if Task.isCancelled { break }
                    continuation.yield(event)
                }
                continuation.finish()
            }
        }
    }
    
    func matchState(for matchID: UUID) async throws -> Match? {
        if matchID == testMatch.id {
            return testMatch
        }
        return nil
    }
}
