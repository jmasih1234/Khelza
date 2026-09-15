import SwiftUI

struct MatchCalendarView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = CalendarViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DatePicker(
                    "Select Date",
                    selection: $viewModel.selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding(.horizontal)
                
                Divider()
                
                // Matches for selected date
                let matches = viewModel.matchesForSelectedDate
                
                if matches.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "calendar.badge.exclamationmark",
                        title: "No Matches",
                        message: "No matches scheduled for this date"
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(matches) { match in
                            UpcomingMatchCard(match: match)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                viewModel.loadMatches(for: appState.userProfile)
            }
        }
    }
}

#Preview {
    MatchCalendarView()
        .environment(AppState())
}
