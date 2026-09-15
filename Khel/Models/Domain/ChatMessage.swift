import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    let category: FreddyCategory?
    
    init(id: UUID = UUID(), content: String, isUser: Bool, timestamp: Date = Date(), category: FreddyCategory? = nil) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
        self.category = category
    }
}

enum FreddyCategory: String, Codable, CaseIterable {
    case rules = "Rules & Calls"
    case tactics = "Tactics"
    case postGame = "Post-Game Calls"
    case history = "History"
    case transfers = "Transfers"
    case competitions = "Competitions"
    case players = "Players"
    case general = "General"
    
    var icon: String {
        switch self {
        case .rules: return "flag.fill"
        case .tactics: return "sportscourt.fill"
        case .postGame: return "exclamationmark.triangle.fill"
        case .history: return "clock.fill"
        case .transfers: return "arrow.left.arrow.right"
        case .competitions: return "trophy.fill"
        case .players: return "person.fill"
        case .general: return "soccerball"
        }
    }
    
    var color: String {
        switch self {
        case .rules: return "red"
        case .tactics: return "blue"
        case .postGame: return "orange"
        case .history: return "purple"
        case .transfers: return "green"
        case .competitions: return "yellow"
        case .players: return "cyan"
        case .general: return "gray"
        }
    }
}

struct SuggestedQuestion: Identifiable {
    let id = UUID()
    let text: String
    let icon: String
    let category: String
}

struct PostGameAlert: Identifiable {
    let id: UUID
    let matchDescription: String
    let callType: PostGameCallType
    let headline: String
    let detail: String
    let timestamp: Date
    
    init(id: UUID = UUID(), matchDescription: String, callType: PostGameCallType, headline: String, detail: String, timestamp: Date = Date()) {
        self.id = id
        self.matchDescription = matchDescription
        self.callType = callType
        self.headline = headline
        self.detail = detail
        self.timestamp = timestamp
    }
}

enum PostGameCallType: String, CaseIterable {
    case disallowedGoal = "Disallowed Goal"
    case penaltyOverturned = "Penalty Overturned"
    case redCardRescinded = "Red Card Rescinded"
    case varControversy = "VAR Controversy"
    case offsideCall = "Offside Call"
    case handsball = "Handball Decision"
    
    var icon: String {
        switch self {
        case .disallowedGoal: return "xmark.circle.fill"
        case .penaltyOverturned: return "arrow.uturn.backward.circle.fill"
        case .redCardRescinded: return "rectangle.portrait.fill"
        case .varControversy: return "tv.fill"
        case .offsideCall: return "flag.fill"
        case .handsball: return "hand.raised.fill"
        }
    }
}
