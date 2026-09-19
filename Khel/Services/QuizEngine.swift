import Foundation

struct QuizResult {
    let correctCount: Int
    let totalCount: Int
    let xpEarned: Int
    let percentage: Double
    let isPerfect: Bool
}

struct QuizEngine {
    
    static func scoreQuiz(answers: [Int], questions: [QuizQuestion]) -> QuizResult {
        var correct = 0
        var xp = 0
        
        for (index, answer) in answers.enumerated() {
            guard index < questions.count else { break }
            if answer == questions[index].correctIndex {
                correct += 1
                xp += questions[index].xpValue
            }
        }
        
        let isPerfect = correct == questions.count && questions.count > 0
        if isPerfect {
            xp += XPEngine.quizPerfectBonusXP
        }
        
        let percentage = questions.isEmpty ? 0 : Double(correct) / Double(questions.count) * 100
        
        return QuizResult(
            correctCount: correct,
            totalCount: questions.count,
            xpEarned: xp,
            percentage: percentage,
            isPerfect: isPerfect
        )
    }
    
    static func generateLiveQuiz(for event: MatchEvent) -> QuizQuestion? {
        switch event.type {
        case .goal:
            return QuizQuestion(
                id: UUID(),
                question: "What is the most common way goals are scored in soccer?",
                options: ["Headers", "Open play shots", "Free kicks", "Penalties"],
                correctIndex: 1,
                explanation: "The majority of goals come from open play situations where the attacking team creates chances through passing and movement.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        case .yellowCard:
            return QuizQuestion(
                id: UUID(),
                question: "How many yellow cards does a player need to receive a suspension in most leagues?",
                options: ["3 yellows", "5 yellows", "2 yellows", "It varies by competition"],
                correctIndex: 3,
                explanation: "Yellow card accumulation rules vary: the Premier League suspends after 5 yellows (first 19 matches), while the Champions League suspends after 3.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        case .redCard:
            return QuizQuestion(
                id: UUID(),
                question: "What happens when a player receives a red card?",
                options: [
                    "They sit out 10 minutes",
                    "They're sent off and their team plays with 10",
                    "They can be replaced by a substitute",
                    "The team gets a free kick"
                ],
                correctIndex: 1,
                explanation: "A red card means immediate expulsion. The team must continue with one fewer player and cannot replace the sent-off player.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        case .substitution:
            return QuizQuestion(
                id: UUID(),
                question: "How many substitutions are typically allowed in a standard match?",
                options: ["3 substitutions", "5 substitutions", "Unlimited", "4 substitutions"],
                correctIndex: 1,
                explanation: "Since 2020, most major competitions allow 5 substitutions per match, though they must be made in a maximum of 3 windows (plus halftime).",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        case .tacticalChange:
            return QuizQuestion(
                id: UUID(),
                question: "What does it mean when a team changes formation during a match?",
                options: [
                    "They change their kit",
                    "They rearrange player positions to adapt tactically",
                    "They make a substitution",
                    "The referee mandates it"
                ],
                correctIndex: 1,
                explanation: "A tactical change rearranges how players are positioned on the pitch. Teams often switch formations to respond to the opponent's strategy or game situation.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        case .varCheck:
            return QuizQuestion(
                id: UUID(),
                question: "What does VAR stand for?",
                options: [
                    "Visual Analysis Review",
                    "Video Assistant Referee",
                    "Virtual Automated Replay",
                    "Video Assessment Review"
                ],
                correctIndex: 1,
                explanation: "VAR (Video Assistant Referee) uses video replay technology to help referees make decisions on goals, penalties, red cards, and mistaken identity.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        case .penaltyAwarded:
            return QuizQuestion(
                id: UUID(),
                question: "From how far away is a penalty kick taken?",
                options: ["10 yards (9.15m)", "12 yards (11m)", "15 yards (13.7m)", "8 yards (7.3m)"],
                correctIndex: 1,
                explanation: "Penalties are taken from the penalty spot, which is 12 yards (11 meters) from the goal line, directly centered.",
                xpValue: XPEngine.liveQuizCorrectXP
            )
        default:
            return nil
        }
    }
}
