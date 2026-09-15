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
    
    var icon: String {
        type.icon
    }
}

enum MatchEventType: String, Codable, CaseIterable {
    case goal
    case assist
    case yellowCard
    case redCard
    case substitution
    case penaltyAwarded
    case penaltyMissed
    case varReview
    case tacticalChange
    case injury
    case kickoff
    case halfTime
    case fullTime
    
    var icon: String {
        switch self {
        case .goal: "soccerball"
        case .assist: "arrow.up.right"
        case .yellowCard: "rectangle.portrait.fill"
        case .redCard: "rectangle.portrait.fill"
        case .substitution: "arrow.left.arrow.right"
        case .penaltyAwarded: "exclamationmark.circle.fill"
        case .penaltyMissed: "xmark.circle.fill"
        case .varReview: "tv.fill"
        case .tacticalChange: "arrow.triangle.swap"
        case .injury: "cross.case.fill"
        case .kickoff: "play.fill"
        case .halfTime: "pause.fill"
        case .fullTime: "stop.fill"
        }
    }
    
    var accentColorHex: String {
        switch self {
        case .goal: "34C759"
        case .yellowCard: "FFD60A"
        case .redCard: "FF3B30"
        case .substitution: "007AFF"
        case .penaltyAwarded, .penaltyMissed: "FF9500"
        case .varReview: "AF52DE"
        case .tacticalChange: "5AC8FA"
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
