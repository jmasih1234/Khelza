import Foundation

/// Mock implementation of KnowledgeRepository backed by AppState/UserDefaults.
/// Eventually replaced by calls to the Khelza backend.
final class MockKnowledgeRepository: KnowledgeRepository {
    
    private var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func recordCorrectAnswer(for topic: KnowledgeTopic) async {
        appState.userProfile.knowledgeProfile.recordCorrectAnswer(for: topic)
        appState.saveToDefaults()
    }
    
    func recordIncorrectAnswer(for topic: KnowledgeTopic) async {
        appState.userProfile.knowledgeProfile.recordIncorrectAnswer(for: topic)
        appState.saveToDefaults()
    }
    
    func knowledgeProfile() async -> UserKnowledgeProfile {
        appState.userProfile.knowledgeProfile
    }
    
    func topicProgress(for topic: KnowledgeTopic) async -> TopicProgress {
        appState.userProfile.knowledgeProfile.progress(for: topic)
    }
}
