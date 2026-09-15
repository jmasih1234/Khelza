import Foundation

@Observable
class LearnViewModel {
    var tracks: [LessonTrack] = []
    var selectedTopic: LessonTopic?
    var currentLesson: Lesson?
    var currentCardIndex: Int = 0
    var quizAnswers: [Int] = []
    var quizResult: QuizResult?
    var showingQuiz: Bool = false
    var showingResult: Bool = false
    
    func loadTracks(for profile: UserProfile) {
        tracks = LessonEngine.personalizedTracks(
            for: profile,
            allTracks: MockDataService.lessonTracks
        )
    }
    
    var filteredTracks: [LessonTrack] {
        guard let topic = selectedTopic else { return tracks }
        return tracks.filter { $0.topic == topic }
    }
    
    func trackProgress(track: LessonTrack, completedIDs: Set<String>) -> Double {
        LessonEngine.trackProgress(track: track, completedIDs: completedIDs)
    }
    
    func startLesson(_ lesson: Lesson) {
        currentLesson = lesson
        currentCardIndex = 0
        quizAnswers = []
        quizResult = nil
        showingQuiz = false
        showingResult = false
    }
    
    func advanceCard() {
        guard let lesson = currentLesson else { return }
        if currentCardIndex < lesson.cards.count - 1 {
            currentCardIndex += 1
        } else {
            showingQuiz = true
        }
    }
    
    func previousCard() {
        if currentCardIndex > 0 {
            currentCardIndex -= 1
        }
    }
    
    var cardProgress: Double {
        guard let lesson = currentLesson, !lesson.cards.isEmpty else { return 0 }
        return Double(currentCardIndex + 1) / Double(lesson.cards.count)
    }
    
    func submitQuizAnswer(_ answer: Int) {
        quizAnswers.append(answer)
    }
    
    func finishQuiz() -> QuizResult {
        guard let lesson = currentLesson else {
            return QuizResult(correctCount: 0, totalCount: 0, xpEarned: 0, percentage: 0, isPerfect: false)
        }
        let result = QuizEngine.scoreQuiz(answers: quizAnswers, questions: lesson.quiz)
        quizResult = result
        showingResult = true
        return result
    }
    
    func resetLesson() {
        currentLesson = nil
        currentCardIndex = 0
        quizAnswers = []
        quizResult = nil
        showingQuiz = false
        showingResult = false
    }
}
