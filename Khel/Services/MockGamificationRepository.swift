import Foundation

/// Mock implementation of GamificationRepository backed by AppState/UserDefaults.
/// Eventually replaced by calls to the Khelza backend.
@Observable
final class MockGamificationRepository: GamificationRepository {
    
    private var appState: AppState
    private var transactions: [XPTransaction] = []
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    @discardableResult
    func awardXP(amount: Int, reason: XPReason, metadata: [String: String]?) async -> XPTransaction {
        let transaction = XPTransaction(
            amount: amount,
            reason: reason,
            metadata: metadata
        )
        transactions.append(transaction)
        
        // Update the local profile (eventually this is server-side)
        appState.awardXP(amount)
        
        return transaction
    }
    
    func currentProgress() async -> XPRecord {
        let profile = appState.userProfile
        let (current, needed) = XPEngine.xpProgressInCurrentLevel(totalXP: profile.totalXP)
        return XPRecord(
            totalXP: profile.totalXP,
            level: profile.level,
            currentLevelXP: current,
            xpToNextLevel: needed
        )
    }
    
    func recentTransactions(limit: Int) async -> [XPTransaction] {
        Array(transactions.suffix(limit))
    }
    
    func updateStreak() async {
        XPEngine.updateStreak(profile: &appState.userProfile)
        appState.saveToDefaults()
    }
    
    func checkBadges() async -> [Badge] {
        // Simplified badge checking — eventually server-side
        MockDataService.allBadges.filter { badge in
            !appState.userProfile.earnedBadgeIDs.contains(badge.id)
        }
    }
}
