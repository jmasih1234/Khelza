import Foundation

enum KnowledgeLevel: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .beginner: "I'm new to soccer and want to learn the basics"
        case .intermediate: "I follow soccer but want to understand it better"
        case .advanced: "I'm a dedicated fan looking for deeper tactical knowledge"
        }
    }
    
    var icon: String {
        switch self {
        case .beginner: "leaf.fill"
        case .intermediate: "flame.fill"
        case .advanced: "star.fill"
        }
    }
}

struct UserProfile: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String = ""
    var knowledgeLevel: KnowledgeLevel = .beginner
    var favoriteLeagueIDs: [String] = []
    var favoriteClubIDs: [String] = []
    var favoritePlayerIDs: [String] = []
    var hasCompletedOnboarding: Bool = false
    var createdAt: Date = Date()
    
    // Gamification
    var totalXP: Int = 0
    var level: Int = 1
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastActivityDate: Date?
    var completedLessonIDs: [String] = []
    var earnedBadgeIDs: [String] = []
    var quizzesTaken: Int = 0
    var perfectQuizzes: Int = 0
    var correctPredictions: Int = 0
    var exactPredictions: Int = 0
    
    // Knowledge profile — per-topic learning progress
    var knowledgeProfile: UserKnowledgeProfile = UserKnowledgeProfile()
}
