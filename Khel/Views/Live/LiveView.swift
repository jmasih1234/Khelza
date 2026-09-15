import SwiftUI

struct LiveView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = LiveViewModel()
    @State private var showingCompanion = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.availableMatches.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "antenna.radiowaves.left.and.right",
                        title: "No Live Matches",
                        message: "There are no live matches right now. Start a simulated match to see the live companion in action!",
                        buttonTitle: "Simulate Match"
                    ) {
                        let match = MockDataService.generateLiveMatch()
                        viewModel.startMatch(match)
                        showingCompanion = true
                    }
                    Spacer()
                } else {
                    List {
                        Section {
                            Text("Tap a match to open the live companion and learn while you watch!")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .listRowBackground(Color.clear)
                        }
                        
                        Section("Live Matches") {
                            ForEach(viewModel.availableMatches) { match in
                                Button {
                                    viewModel.startMatch(match)
                                    showingCompanion = true
                                } label: {
                                    UpcomingMatchCard(match: match)
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Live")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let match = MockDataService.generateLiveMatch()
                        viewModel.startMatch(match)
                        showingCompanion = true
                    } label: {
                        Image(systemName: "play.fill")
                    }
                }
            }
            .navigationDestination(isPresented: $showingCompanion) {
                LiveMatchCompanionView(viewModel: viewModel)
                    .environment(appState)
            }
            .onAppear {
                viewModel.loadAvailableMatches(for: appState.userProfile)
            }
        }
    }
}

#Preview {
    LiveView()
        .environment(AppState())
}
