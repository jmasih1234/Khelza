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

// MARK: - XP Transactions (platform-compatible audit trail)

/// Represents a single XP-earning event. Eventually server-authoritative.
struct XPTransaction: Identifiable, Codable {
    let id: UUID
    let amount: Int
    let reason: XPReason
    let timestamp: Date
    let metadata: [String: String]?
    
    init(
        id: UUID = UUID(),
        amount: Int,
        reason: XPReason,
        timestamp: Date = Date(),
        metadata: [String: String]? = nil
    ) {
        self.id = id
        self.amount = amount
        self.reason = reason
        self.timestamp = timestamp
        self.metadata = metadata
    }
}

enum XPReason: String, Codable, CaseIterable {
    case lessonCardViewed
    case lessonCompleted
    case quizCorrectAnswer
    case quizPerfectBonus
    case liveQuizCorrect
    case contextualQuizCorrect
    case dailyChallenge
    case predictionCorrect
    case predictionExactScore
    case streakDaily
    case streakWeekBonus
    case onboardingBonus
}

// MARK: - Knowledge Profile (per-topic learning progress)

/// Tracks the user's knowledge across sports topics. Eventually server-authoritative.
struct UserKnowledgeProfile: Codable {
    var topicProgress: [String: TopicProgress]
    
    init(topicProgress: [String: TopicProgress] = [:]) {
        self.topicProgress = topicProgress
    }
    
    /// Get progress for a specific topic, creating a default entry if absent
    func progress(for topic: KnowledgeTopic) -> TopicProgress {
        topicProgress[topic.id] ?? TopicProgress()
    }
    
    /// Record a correct answer for a topic
    mutating func recordCorrectAnswer(for topic: KnowledgeTopic) {
        var p = progress(for: topic)
        p.correctAnswers += 1
        p.totalAnswers += 1
        p.lastActivityDate = Date()
        topicProgress[topic.id] = p
    }
    
    /// Record an incorrect answer for a topic
    mutating func recordIncorrectAnswer(for topic: KnowledgeTopic) {
        var p = progress(for: topic)
        p.totalAnswers += 1
        p.lastActivityDate = Date()
        topicProgress[topic.id] = p
    }
}

struct TopicProgress: Codable {
    var correctAnswers: Int = 0
    var totalAnswers: Int = 0
    var lastActivityDate: Date?
    
    /// Mastery percentage (0.0 - 1.0)
    var mastery: Double {
        guard totalAnswers > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAnswers)
    }
}

/// Stable identifiers for knowledge topics — shared across platforms
struct KnowledgeTopic: Identifiable, Codable, Hashable {
    let id: String
    let displayName: String
    let parentTopicID: String?
    let icon: String
    
    init(id: String, displayName: String, parentTopicID: String? = nil, icon: String = "book.fill") {
        self.id = id
        self.displayName = displayName
        self.parentTopicID = parentTopicID
        self.icon = icon
    }
}

/// Well-known knowledge topics
extension KnowledgeTopic {
    static let offside = KnowledgeTopic(id: "rules.offside", displayName: "Offside", parentTopicID: "rules", icon: "flag.fill")
    static let fouls = KnowledgeTopic(id: "rules.fouls", displayName: "Fouls & Free Kicks", parentTopicID: "rules", icon: "exclamationmark.triangle.fill")
    static let var_ = KnowledgeTopic(id: "rules.var", displayName: "VAR", parentTopicID: "rules", icon: "tv.fill")
    static let handball = KnowledgeTopic(id: "rules.handball", displayName: "Handball", parentTopicID: "rules", icon: "hand.raised.fill")
    static let formations = KnowledgeTopic(id: "tactics.formations", displayName: "Formations", parentTopicID: "tactics", icon: "rectangle.3.group")
    static let pressing = KnowledgeTopic(id: "tactics.pressing", displayName: "Pressing", parentTopicID: "tactics", icon: "sportscourt.fill")
    static let positions = KnowledgeTopic(id: "players.positions", displayName: "Positions", parentTopicID: "players", icon: "person.3.fill")
    static let competitions = KnowledgeTopic(id: "competitions", displayName: "Competitions", icon: "trophy.fill")
}
