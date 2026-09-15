import Foundation

@Observable
class GamesViewModel {
    var triviaQuestions: [QuizQuestion] = []
    var currentQuestionIndex: Int = 0
    var triviaAnswers: [Int] = []
    var triviaResult: QuizResult?
    var showingTriviaResult: Bool = false
    var selectedTopic: LessonTopic?
    
    var predictions: [Prediction] = []
    var upcomingMatchesForPrediction: [Match] = []
    var leaderboard: [LeaderboardEntry] = []
    var dailyChallenge: DailyChallenge?
    
    var isTriviaActive: Bool = false
    
    func loadData(for profile: UserProfile) {
        let leagueIDs = profile.favoriteLeagueIDs.isEmpty
            ? MockDataService.leagues.map(\.id)
            : profile.favoriteLeagueIDs
        
        upcomingMatchesForPrediction = MockDataService.generateUpcomingMatches(for: leagueIDs, count: 6)
        leaderboard = MockDataService.mockLeaderboard
        dailyChallenge = MockDataService.generateDailyChallenge()
    }
    
    func startTrivia(topic: LessonTopic? = nil) {
        selectedTopic = topic
        currentQuestionIndex = 0
        triviaAnswers = []
        triviaResult = nil
        showingTriviaResult = false
        
        // Gather questions from all tracks or filtered by topic
        var questions: [QuizQuestion] = []
        for track in MockDataService.lessonTracks {
            if let topic, track.topic != topic { continue }
            for lesson in track.lessons {
                questions.append(contentsOf: lesson.quiz)
            }
        }
        
        // Also add daily challenge questions if available
        if let challenge = dailyChallenge, let challengeQuestions = challenge.quizQuestions {
            questions.append(contentsOf: challengeQuestions)
        }
        
        triviaQuestions = Array(questions.shuffled().prefix(10))
        isTriviaActive = !triviaQuestions.isEmpty
    }
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < triviaQuestions.count else { return nil }
        return triviaQuestions[currentQuestionIndex]
    }
    
    func answerTrivia(_ optionIndex: Int) -> Bool {
        guard let question = currentQuestion else { return false }
        triviaAnswers.append(optionIndex)
        let correct = optionIndex == question.correctIndex
        
        if currentQuestionIndex < triviaQuestions.count - 1 {
            currentQuestionIndex += 1
        } else {
            triviaResult = QuizEngine.scoreQuiz(answers: triviaAnswers, questions: triviaQuestions)
            showingTriviaResult = true
            isTriviaActive = false
        }
        
        return correct
    }
    
    func submitPrediction(matchID: UUID, home: Int, away: Int) {
        let prediction = Prediction(
            id: UUID(),
            matchID: matchID,
            predictedHomeScore: home,
            predictedAwayScore: away,
            createdAt: Date()
        )
        predictions.append(prediction)
    }
    
    func hasPrediction(for matchID: UUID) -> Bool {
        predictions.contains { $0.matchID == matchID }
    }
    
    func resetTrivia() {
        triviaQuestions = []
        currentQuestionIndex = 0
        triviaAnswers = []
        triviaResult = nil
        showingTriviaResult = false
        isTriviaActive = false
    }
}
