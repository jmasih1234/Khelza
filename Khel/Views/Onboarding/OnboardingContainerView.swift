import SwiftUI

struct OnboardingContainerView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = OnboardingViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                    Rectangle()
                        .fill(.green)
                        .frame(width: geo.size.width * viewModel.progress)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
                }
            }
            .frame(height: 4)
            
            // Content
            TabView(selection: Binding(
                get: { viewModel.currentStep },
                set: { viewModel.currentStep = $0 }
            )) {
                WelcomeView(userName: $viewModel.userName)
                    .tag(OnboardingViewModel.OnboardingStep.welcome)
                
                KnowledgeLevelView(selectedLevel: $viewModel.selectedLevel)
                    .tag(OnboardingViewModel.OnboardingStep.knowledgeLevel)
                
                LeagueSelectionView(
                    selectedLeagueIDs: $viewModel.selectedLeagueIDs,
                    toggleLeague: viewModel.toggleLeague
                )
                .tag(OnboardingViewModel.OnboardingStep.leagues)
                
                ClubSelectionView(
                    clubs: viewModel.availableClubs,
                    selectedClubIDs: $viewModel.selectedClubIDs,
                    toggleClub: viewModel.toggleClub
                )
                .tag(OnboardingViewModel.OnboardingStep.clubs)
                
                PlayerSelectionView(
                    players: viewModel.availablePlayers,
                    selectedPlayerIDs: $viewModel.selectedPlayerIDs,
                    togglePlayer: viewModel.togglePlayer
                )
                .tag(OnboardingViewModel.OnboardingStep.players)
                
                OnboardingCompleteView(profile: viewModel.buildProfile())
                    .tag(OnboardingViewModel.OnboardingStep.complete)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
            
            // Bottom buttons
            HStack {
                if viewModel.currentStep != .welcome {
                    Button {
                        viewModel.previousStep()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button {
                    if viewModel.currentStep == .complete {
                        let profile = viewModel.buildProfile()
                        appState.completeOnboarding(with: profile)
                    } else {
                        viewModel.nextStep()
                    }
                } label: {
                    HStack {
                        Text(viewModel.currentStep == .complete ? "Get Started" : "Continue")
                        if viewModel.currentStep != .complete {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(viewModel.canProceed ? .green : .gray)
                    .clipShape(Capsule())
                }
                .disabled(!viewModel.canProceed)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingContainerView()
        .environment(AppState())
}
