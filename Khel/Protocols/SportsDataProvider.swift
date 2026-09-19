import Foundation

/// Abstraction for sports data — can be backed by mock data, API-Football, or the Khelza backend.
/// The iOS app consumes Khelza domain models, never raw API responses.
protocol SportsDataProvider {
    
    // MARK: - Reference Data
    
    func leagues() async throws -> [League]
    func clubs(forLeague leagueID: String) async throws -> [Club]
    func club(byID id: String) async throws -> Club?
    func player(byID id: String) async throws -> Player?
    
    // MARK: - Fixtures
    
    func upcomingMatches(leagueIDs: [String], limit: Int) async throws -> [Match]
    func liveMatches(leagueIDs: [String]) async throws -> [Match]
    func finishedMatches(leagueIDs: [String], limit: Int) async throws -> [Match]
    
    // MARK: - Live Match
    
    /// Returns an async stream of match events for a live match.
    /// The provider controls the pace (real-time from API, or simulated).
    func liveEventStream(for matchID: UUID) -> AsyncStream<MatchEvent>
    
    /// Get the current full state of a match (for reconnection / initial load)
    func matchState(for matchID: UUID) async throws -> Match?
}
