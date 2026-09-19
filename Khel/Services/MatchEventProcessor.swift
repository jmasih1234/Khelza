import Foundation

/// Processes match events and derives the authoritative match state.
/// Handles event overturning, score reconciliation, and related event chains.
///
/// This logic is platform-level — it must produce identical results on iOS and web.
/// During development it runs locally; eventually it runs on the Khelza backend.
struct MatchEventProcessor {
    
    /// Process a new event arriving for a match. Returns the updated match.
    /// Handles: appending new events, overturning related events, recalculating score.
    static func processEvent(_ event: MatchEvent, in match: inout Match) {
        // If this event overturns a previous event, mark the original as overturned
        if let relatedID = event.relatedEventID {
            switch event.type {
            case .goalDisallowed:
                overturnEvent(id: relatedID, in: &match)
            case .penaltyOverturned:
                overturnEvent(id: relatedID, in: &match)
            case .varDecision:
                // VAR decisions can confirm or overturn — we handle overturn via goalDisallowed
                break
            default:
                break
            }
        }
        
        // Append the new event
        match.events.append(event)
        
        // Update match status based on event type
        updateMatchStatus(for: event, in: &match)
        
        // Recalculate the score from confirmed events only
        match.homeScore = calculateScore(for: match.homeClubID, events: match.events)
        match.awayScore = calculateScore(for: match.awayClubID, events: match.events)
        
        // Update match minute
        if event.minute > match.currentMinute {
            match.currentMinute = event.minute
        }
    }
    
    /// Calculate the score for a team based only on confirmed goal events
    static func calculateScore(for clubID: String, events: [MatchEvent]) -> Int {
        events.filter { event in
            event.clubID == clubID && event.countsForScore
        }.count
    }
    
    /// Mark an event as overturned
    private static func overturnEvent(id: UUID, in match: inout Match) {
        if let index = match.events.firstIndex(where: { $0.id == id }) {
            match.events[index].status = .overturned
        }
    }
    
    /// Update match status based on the event type
    private static func updateMatchStatus(for event: MatchEvent, in match: inout Match) {
        switch event.type {
        case .kickoff, .secondHalfStart:
            match.status = .live
        case .halfTime:
            match.status = .halftime
        case .fullTime:
            match.status = .finished
        default:
            break
        }
    }
    
    // MARK: - Query helpers
    
    /// Get events related to a specific event (e.g., VAR check + decision for a goal)
    static func relatedEvents(for eventID: UUID, in match: Match) -> [MatchEvent] {
        match.events.filter { $0.relatedEventID == eventID }
    }
    
    /// Check if an event is currently under VAR review (has a VAR_CHECK but no VAR_DECISION or GOAL_DISALLOWED yet)
    static func isUnderReview(eventID: UUID, in match: Match) -> Bool {
        let related = relatedEvents(for: eventID, in: match)
        let hasVARCheck = related.contains { $0.type == .varCheck }
        let hasResolution = related.contains { $0.type == .varDecision || $0.type == .goalDisallowed || $0.type == .penaltyOverturned }
        return hasVARCheck && !hasResolution
    }
    
    /// Get all events that have "Explain This" content available
    static func explainableEvents(in match: Match) -> [MatchEvent] {
        match.events.filter { $0.type.hasExplanation }
    }
    
    /// Get the latest event that is eligible for an "Explain This" prompt
    static func latestExplainableEvent(in match: Match) -> MatchEvent? {
        match.events.last { $0.type.hasExplanation }
    }
}
