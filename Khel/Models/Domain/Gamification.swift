import Foundation

struct XPRecord: Codable {
    var totalXP: Int = 0
    var level: Int = 1
    var currentLevelXP: Int = 0
    var xpToNextLevel: Int = 100
}

struct Streak: Codable {
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastActivityDate: Date?
    var streakDates: [Date] = []
}

struct Badge: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let iconName: String
    let category: BadgeCategory
    let requiredValue: Int
    var isEarned: Bool = false
    var earnedDate: Date?
    
    var iconColor: String {
        category.colorHex
    }
}

enum BadgeCategory: String, Codable, CaseIterable, Identifiable {
    case learning
    case streak
    case quiz
    case prediction
    case milestone
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .learning: "Learning"
        case .streak: "Streaks"
        case .quiz: "Quizzes"
        case .prediction: "Predictions"
        case .milestone: "Milestones"
        }
    }
    
    var colorHex: String {
        switch self {
        case .learning: "007AFF"
        case .streak: "FF9500"
        case .quiz: "34C759"
        case .prediction: "AF52DE"
        case .milestone: "FFD700"
        }
    }
}

struct LeaderboardEntry: Identifiable, Codable {
    let id: UUID
    let userName: String
    let xp: Int
    let level: Int
    let rank: Int
    let avatarEmoji: String
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let xpEarned: Int
    let timestamp: Date
}
