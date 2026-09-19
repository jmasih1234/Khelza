import Foundation

/// Abstraction for knowledge/learning progress — eventually server-authoritative.
protocol KnowledgeRepository {
    
    /// Record that the user answered a question correctly for a given topic
    func recordCorrectAnswer(for topic: KnowledgeTopic) async
    
    /// Record that the user answered incorrectly for a given topic
    func recordIncorrectAnswer(for topic: KnowledgeTopic) async
    
    /// Get the user's current knowledge profile
    func knowledgeProfile() async -> UserKnowledgeProfile
    
    /// Get progress for a specific topic
    func topicProgress(for topic: KnowledgeTopic) async -> TopicProgress
}
