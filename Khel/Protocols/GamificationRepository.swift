import Foundation

/// Abstraction for gamification operations — eventually server-authoritative.
/// During development, backed by local UserDefaults. In production, calls Khelza backend.
protocol GamificationRepository {
    
    /// Award XP for a specific reason. Returns the transaction record.
    @discardableResult
    func awardXP(amount: Int, reason: XPReason, metadata: [String: String]?) async -> XPTransaction
    
    /// Get the user's current XP and level
    func currentProgress() async -> XPRecord
    
    /// Get recent XP transactions
    func recentTransactions(limit: Int) async -> [XPTransaction]
    
    /// Update streak status
    func updateStreak() async
    
    /// Check if a badge should be awarded
    func checkBadges() async -> [Badge]
}

extension GamificationRepository {
    @discardableResult
    func awardXP(amount: Int, reason: XPReason) async -> XPTransaction {
        await awardXP(amount: amount, reason: reason, metadata: nil)
    }
}
