import SwiftUI

enum LessonTopic: String, Codable, CaseIterable, Identifiable {
    case rules = "Rules"
    case tactics = "Tactics"
    case history = "History"
    case players = "Players"
    case stats = "Stats"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .rules: "book.closed.fill"
        case .tactics: "sportscourt.fill"
        case .history: "clock.fill"
        case .players: "person.3.fill"
        case .stats: "chart.bar.fill"
        }
    }
    
    var colorHex: String {
        switch self {
        case .rules: "007AFF"
        case .tactics: "34C759"
        case .history: "FF9500"
        case .players: "AF52DE"
        case .stats: "FF2D55"
        }
    }
    
    var color: Color {
        Color(hex: colorHex)
    }
    
    var subtitle: String {
        switch self {
        case .rules: "Learn how the game works"
        case .tactics: "Understand strategies & formations"
        case .history: "Discover the beautiful game's story"
        case .players: "Know the stars and legends"
        case .stats: "Decode the numbers"
        }
    }
}

struct LessonTrack: Identifiable, Codable {
    let id: String
    let topic: LessonTopic
    let title: String
    let description: String
    let lessons: [Lesson]
    let difficulty: KnowledgeLevel
}

struct Lesson: Identifiable, Codable, Hashable {
    let id: String
    let trackID: String
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let xpReward: Int
    let cards: [LessonCard]
    let quiz: [QuizQuestion]
    let difficulty: KnowledgeLevel
    let relatedLeagueIDs: [String]
    let relatedClubIDs: [String]
    
    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct LessonCard: Identifiable, Codable {
    let id: UUID
    let title: String
    let content: String
    let highlightFact: String?
    let iconName: String?
}

struct QuizQuestion: Identifiable, Codable {
    let id: UUID
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    let xpValue: Int
}
