import Foundation

struct Match: Identifiable, Codable, Hashable {
    let id: UUID
    let homeClubID: String
    let awayClubID: String
    let leagueID: String
    var status: MatchStatus
    var homeScore: Int
    var awayScore: Int
    var kickoffDate: Date
    var matchDay: Int
    var currentMinute: Int
    var events: [MatchEvent]
    var stats: MatchStats
    
    static func == (lhs: Match, rhs: Match) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum MatchStatus: String, Codable, CaseIterable {
    case scheduled = "Scheduled"
    case live = "Live"
    case halftime = "Half Time"
    case finished = "Full Time"
    
    var isActive: Bool {
        self == .live || self == .halftime
    }
}

struct MatchEvent: Identifiable, Codable {
    let id: UUID
    let minute: Int
    let type: MatchEventType
    let playerName: String
    let clubID: String
    let description: String
    let educationalNote: String
    var status: EventStatus
    var relatedEventID: UUID?
    
    var icon: String {
        type.icon
    }
    
    /// Whether this event has been overturned by a subsequent decision
    var isOverturned: Bool {
        status == .overturned
    }
    
    /// Whether this event contributes to the score
    var countsForScore: Bool {
        type.isGoal && status == .confirmed
    }
    
    init(
        id: UUID = UUID(),
        minute: Int,
        type: MatchEventType,
        playerName: String,
        clubID: String,
        description: String,
        educationalNote: String = "",
        status: EventStatus = .confirmed,
        relatedEventID: UUID? = nil
    ) {
        self.id = id
        self.minute = minute
        self.type = type
        self.playerName = playerName
        self.clubID = clubID
        self.description = description
        self.educationalNote = educationalNote
        self.status = status
        self.relatedEventID = relatedEventID
    }
}

/// Status of a match event — events can be overturned by VAR or corrected post-match
enum EventStatus: String, Codable, CaseIterable {
    case pending = "pending"
    case confirmed = "confirmed"
    case overturned = "overturned"
    case corrected = "corrected"
}

enum MatchEventType: String, Codable, CaseIterable {
    // Scoring
    case goal
    case ownGoal
    case penaltyGoal
    case missedPenalty
    case goalDisallowed
    
    // Discipline
    case yellowCard
    case secondYellow
    case redCard
    
    // Substitutions & Tactics
    case substitution
    case tacticalChange
    
    // Set pieces & fouls
    case penaltyAwarded
    case penaltyOverturned
    
    // VAR
    case varCheck
    case varDecision
    
    // Match flow
    case kickoff
    case halfTime
    case secondHalfStart
    case fullTime
    case extraTime
    case penaltyShootout
    
    // Other
    case offside
    case injury
    case assist
    
    /// Whether this event type represents a goal (used for score calculation)
    var isGoal: Bool {
        switch self {
        case .goal, .ownGoal, .penaltyGoal: return true
        default: return false
        }
    }
    
    /// Whether this event type has an "Explain This" educational opportunity
    var hasExplanation: Bool {
        switch self {
        case .goalDisallowed, .redCard, .secondYellow, .varCheck, .varDecision,
             .penaltyAwarded, .penaltyOverturned, .offside, .tacticalChange, .substitution:
            return true
        default:
            return false
        }
    }
    
    var icon: String {
        switch self {
        case .goal, .penaltyGoal: "soccerball"
        case .ownGoal: "soccerball"
        case .goalDisallowed: "xmark.circle.fill"
        case .assist: "arrow.up.right"
        case .yellowCard: "rectangle.portrait.fill"
        case .secondYellow: "rectangle.portrait.fill"
        case .redCard: "rectangle.portrait.fill"
        case .substitution: "arrow.left.arrow.right"
        case .penaltyAwarded: "exclamationmark.circle.fill"
        case .penaltyOverturned: "arrow.uturn.backward.circle.fill"
        case .missedPenalty: "xmark.circle.fill"
        case .varCheck: "tv.fill"
        case .varDecision: "tv.fill"
        case .tacticalChange: "arrow.triangle.swap"
        case .offside: "flag.fill"
        case .injury: "cross.case.fill"
        case .kickoff: "play.fill"
        case .halfTime: "pause.fill"
        case .secondHalfStart: "play.fill"
        case .fullTime: "stop.fill"
        case .extraTime: "clock.badge.exclamationmark"
        case .penaltyShootout: "target"
        }
    }
    
    var accentColorHex: String {
        switch self {
        case .goal, .penaltyGoal: "34C759"
        case .ownGoal: "FF9500"
        case .goalDisallowed: "FF3B30"
        case .yellowCard, .secondYellow: "FFD60A"
        case .redCard: "FF3B30"
        case .substitution: "007AFF"
        case .penaltyAwarded, .missedPenalty: "FF9500"
        case .penaltyOverturned: "FF9500"
        case .varCheck, .varDecision: "AF52DE"
        case .tacticalChange: "5AC8FA"
        case .offside: "FF9500"
        case .injury: "FF3B30"
        default: "8E8E93"
        }
    }
}

struct MatchStats: Codable {
    var possessionHome: Int
    var possessionAway: Int
    var shotsHome: Int
    var shotsAway: Int
    var shotsOnTargetHome: Int
    var shotsOnTargetAway: Int
    var cornersHome: Int
    var cornersAway: Int
    var foulsHome: Int
    var foulsAway: Int
    var passAccuracyHome: Int
    var passAccuracyAway: Int
    
    static var empty: MatchStats {
        MatchStats(
            possessionHome: 50, possessionAway: 50,
            shotsHome: 0, shotsAway: 0,
            shotsOnTargetHome: 0, shotsOnTargetAway: 0,
            cornersHome: 0, cornersAway: 0,
            foulsHome: 0, foulsAway: 0,
            passAccuracyHome: 85, passAccuracyAway: 85
        )
    }
}
