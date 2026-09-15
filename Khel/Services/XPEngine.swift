import Foundation

struct LevelUpResult {
    let previousLevel: Int
    let newLevel: Int
    let xpAwarded: Int
    let totalXP: Int
}

struct XPEngine {
    
    // XP thresholds per action
    static let lessonCardXP = 5
    static let lessonCompleteXP = 25
    static let quizCorrectXP = 10
    static let quizPerfectBonusXP = 25
    static let dailyChallengeXP = 50
    static let predictionCorrectXP = 30
    static let predictionExactXP = 100
    static let liveQuizCorrectXP = 15
    static let streakDailyXP = 10
    static let streakWeekBonusXP = 50
    
    static func xpRequiredForLevel(_ level: Int) -> Int {
        guard level > 1 else { return 0 }
        return 50 * level * (level + 1) / 2
    }
    
    static func calculateLevel(for totalXP: Int) -> Int {
        var level = 1
        while xpRequiredForLevel(level + 1) <= totalXP {
            level += 1
        }
        return level
    }
    
    static func xpProgressInCurrentLevel(totalXP: Int) -> (current: Int, needed: Int) {
        let level = calculateLevel(for: totalXP)
        let currentLevelStart = xpRequiredForLevel(level)
        let nextLevelStart = xpRequiredForLevel(level + 1)
        return (totalXP - currentLevelStart, nextLevelStart - currentLevelStart)
    }
    
    static func awardXP(_ amount: Int, to profile: inout UserProfile) -> LevelUpResult? {
        let previousLevel = profile.level
        profile.totalXP += amount
        let newLevel = calculateLevel(for: profile.totalXP)
        profile.level = newLevel
        
        if newLevel > previousLevel {
            return LevelUpResult(
                previousLevel: previousLevel,
                newLevel: newLevel,
                xpAwarded: amount,
                totalXP: profile.totalXP
            )
        }
        return nil
    }
    
    static func shouldContinueStreak(lastDate: Date?) -> Bool {
        guard let lastDate else { return false }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastDay = calendar.startOfDay(for: lastDate)
        let daysBetween = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
        return daysBetween <= 1
    }
    
    static func updateStreak(profile: inout UserProfile) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastDate = profile.lastActivityDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let daysBetween = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            
            if daysBetween == 0 {
                // Already active today
                return
            } else if daysBetween == 1 {
                // Consecutive day
                profile.currentStreak += 1
                if profile.currentStreak > profile.longestStreak {
                    profile.longestStreak = profile.currentStreak
                }
                // Award streak XP
                _ = awardXP(streakDailyXP, to: &profile)
                if profile.currentStreak % 7 == 0 {
                    _ = awardXP(streakWeekBonusXP, to: &profile)
                }
            } else {
                // Streak broken
                profile.currentStreak = 1
            }
        } else {
            profile.currentStreak = 1
        }
        
        profile.lastActivityDate = today
    }
}
