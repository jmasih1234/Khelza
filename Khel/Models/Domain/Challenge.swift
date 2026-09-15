import Foundation

struct DailyChallenge: Identifiable, Codable {
    let id: UUID
    let date: Date
    let title: String
    let description: String
    let type: ChallengeType
    let xpReward: Int
    var isCompleted: Bool = false
    let quizQuestions: [QuizQuestion]?
}

enum ChallengeType: String, Codable, CaseIterable, Identifiable {
    case trivia = "Trivia"
    case prediction = "Prediction"
    case lesson = "Lesson"
    case streak = "Streak"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .trivia: "questionmark.circle.fill"
        case .prediction: "crystal.ball"
        case .lesson: "book.fill"
        case .streak: "flame.fill"
        }
    }
    
    var colorHex: String {
        switch self {
        case .trivia: "FF9500"
        case .prediction: "AF52DE"
        case .lesson: "007AFF"
        case .streak: "FF2D55"
        }
    }
}

struct Prediction: Identifiable, Codable {
    let id: UUID
    let matchID: UUID
    var predictedHomeScore: Int
    var predictedAwayScore: Int
    var isCorrect: Bool?
    var isExactScore: Bool?
    var xpEarned: Int = 0
    let createdAt: Date
}
