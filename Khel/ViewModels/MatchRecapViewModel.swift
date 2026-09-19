import Foundation

@Observable
class MatchRecapViewModel {
    var match: Match?
    var recapQuiz: [QuizQuestion] = []
    var quizAnswers: [Int] = []
    var quizResult: QuizResult?
    var showingQuiz: Bool = false
    
    func loadRecap(leagueID: String = "premier-league") {
        match = MockDataService.generateFinishedMatch(leagueID: leagueID)
        generateRecapQuiz()
    }
    
    var keyMoments: [MatchEvent] {
        guard let match else { return [] }
        return match.events.filter { event in
            let keyTypes: Set<MatchEventType> = [.goal, .redCard, .penaltyAwarded, .varCheck, .varDecision, .goalDisallowed, .tacticalChange]
            return keyTypes.contains(event.type)
        }
    }
    
    private func generateRecapQuiz() {
        guard let match else { return }
        var questions: [QuizQuestion] = []
        
        let homeClub = MockDataService.club(byID: match.homeClubID)
        let awayClub = MockDataService.club(byID: match.awayClubID)
        let homeName = homeClub?.name ?? "Home"
        let awayName = awayClub?.name ?? "Away"
        
        questions.append(QuizQuestion(
            id: UUID(),
            question: "What was the final score of \(homeName) vs \(awayName)?",
            options: [
                "\(match.homeScore)-\(match.awayScore)",
                "\(match.homeScore + 1)-\(match.awayScore)",
                "\(match.awayScore)-\(match.homeScore)",
                "\(match.homeScore)-\(match.awayScore + 1)"
            ],
            correctIndex: 0,
            explanation: "The final score was \(homeName) \(match.homeScore) - \(match.awayScore) \(awayName).",
            xpValue: 10
        ))
        
        if match.stats.possessionHome > match.stats.possessionAway {
            questions.append(QuizQuestion(
                id: UUID(),
                question: "Which team had more possession?",
                options: [homeName, awayName, "Equal", "Not tracked"],
                correctIndex: 0,
                explanation: "\(homeName) had \(match.stats.possessionHome)% possession compared to \(awayName)'s \(match.stats.possessionAway)%.",
                xpValue: 10
            ))
        }
        
        recapQuiz = questions
    }
    
    func answerRecapQuiz(_ answer: Int) {
        quizAnswers.append(answer)
        if quizAnswers.count >= recapQuiz.count {
            quizResult = QuizEngine.scoreQuiz(answers: quizAnswers, questions: recapQuiz)
        }
    }
    
    func startQuiz() {
        showingQuiz = true
        quizAnswers = []
        quizResult = nil
    }
}
