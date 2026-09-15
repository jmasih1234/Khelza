import SwiftUI

@Observable
class AppState {
    var userProfile: UserProfile = UserProfile()
    var hasCompletedOnboarding: Bool = false
    var selectedTab: AppTab = .home
    
    init() {
        loadFromDefaults()
    }
    
    func loadFromDefaults() {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = profile
            self.hasCompletedOnboarding = profile.hasCompletedOnboarding
        }
    }
    
    func saveToDefaults() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
    }
    
    func completeOnboarding(with profile: UserProfile) {
        var updatedProfile = profile
        updatedProfile.hasCompletedOnboarding = true
        updatedProfile.earnedBadgeIDs.append("welcome")
        updatedProfile.totalXP += 50
        self.userProfile = updatedProfile
        self.hasCompletedOnboarding = true
        saveToDefaults()
    }
    
    func awardXP(_ amount: Int) {
        _ = XPEngine.awardXP(amount, to: &userProfile)
        saveToDefaults()
    }
    
    func completeLesson(_ lessonID: String, xp: Int) {
        if !userProfile.completedLessonIDs.contains(lessonID) {
            userProfile.completedLessonIDs.append(lessonID)
        }
        awardXP(xp)
        XPEngine.updateStreak(profile: &userProfile)
        saveToDefaults()
    }
    
    func recordQuizCompletion(isPerfect: Bool) {
        userProfile.quizzesTaken += 1
        if isPerfect {
            userProfile.perfectQuizzes += 1
        }
        saveToDefaults()
    }
    
    func resetOnboarding() {
        userProfile = UserProfile()
        hasCompletedOnboarding = false
        UserDefaults.standard.removeObject(forKey: "userProfile")
    }
}

enum AppTab: Int, CaseIterable, Identifiable {
    case home, learn, live, games, profile
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .home: "Home"
        case .learn: "Learn"
        case .live: "Live"
        case .games: "Games"
        case .profile: "Profile"
        }
    }
    
    var systemImage: String {
        switch self {
        case .home: "house.fill"
        case .learn: "book.fill"
        case .live: "antenna.radiowaves.left.and.right"
        case .games: "gamecontroller.fill"
        case .profile: "person.fill"
        }
    }
}
