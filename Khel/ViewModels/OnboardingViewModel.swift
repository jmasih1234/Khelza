import SwiftUI

@Observable
class OnboardingViewModel {
    var currentStep: OnboardingStep = .welcome
    var selectedLevel: KnowledgeLevel = .beginner
    var selectedLeagueIDs: Set<String> = []
    var selectedClubIDs: Set<String> = []
    var selectedPlayerIDs: Set<String> = []
    var userName: String = ""
    
    enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case knowledgeLevel = 1
        case leagues = 2
        case clubs = 3
        case players = 4
        case complete = 5
        
        var title: String {
            switch self {
            case .welcome: "Welcome"
            case .knowledgeLevel: "Experience Level"
            case .leagues: "Pick Your Leagues"
            case .clubs: "Pick Your Clubs"
            case .players: "Pick Your Players"
            case .complete: "You're All Set!"
            }
        }
    }
    
    var availableClubs: [Club] {
        MockDataService.allClubs.filter { selectedLeagueIDs.contains($0.leagueID) }
    }
    
    var availablePlayers: [Player] {
        availableClubs
            .filter { selectedClubIDs.contains($0.id) }
            .flatMap(\.players)
    }
    
    var canProceed: Bool {
        switch currentStep {
        case .welcome: true
        case .knowledgeLevel: true
        case .leagues: !selectedLeagueIDs.isEmpty
        case .clubs: !selectedClubIDs.isEmpty
        case .players: true
        case .complete: true
        }
    }
    
    var progress: Double {
        Double(currentStep.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }
    
    func nextStep() {
        guard let next = OnboardingStep(rawValue: currentStep.rawValue + 1) else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = next
        }
    }
    
    func previousStep() {
        guard let prev = OnboardingStep(rawValue: currentStep.rawValue - 1) else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep = prev
        }
    }
    
    func toggleLeague(_ id: String) {
        if selectedLeagueIDs.contains(id) {
            selectedLeagueIDs.remove(id)
            // Remove clubs from deselected leagues
            let clubsToRemove = MockDataService.clubs(forLeague: id).map(\.id)
            selectedClubIDs.subtract(clubsToRemove)
        } else {
            selectedLeagueIDs.insert(id)
        }
    }
    
    func toggleClub(_ id: String) {
        if selectedClubIDs.contains(id) {
            selectedClubIDs.remove(id)
        } else {
            selectedClubIDs.insert(id)
        }
    }
    
    func togglePlayer(_ id: String) {
        if selectedPlayerIDs.contains(id) {
            selectedPlayerIDs.remove(id)
        } else {
            selectedPlayerIDs.insert(id)
        }
    }
    
    func buildProfile() -> UserProfile {
        var profile = UserProfile()
        profile.name = userName.isEmpty ? "Fan" : userName
        profile.knowledgeLevel = selectedLevel
        profile.favoriteLeagueIDs = Array(selectedLeagueIDs)
        profile.favoriteClubIDs = Array(selectedClubIDs)
        profile.favoritePlayerIDs = Array(selectedPlayerIDs)
        return profile
    }
}
