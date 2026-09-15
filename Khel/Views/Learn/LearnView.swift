import SwiftUI

struct LearnView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = LearnViewModel()
    @State private var selectedLesson: Lesson?
    
    var completedIDs: Set<String> {
        Set(appState.userProfile.completedLessonIDs)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Topic filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        TagChip(title: "All", isSelected: viewModel.selectedTopic == nil, color: .blue) {
                            viewModel.selectedTopic = nil
                        }
                        
                        ForEach(LessonTopic.allCases) { topic in
                            TagChip(title: topic.rawValue, isSelected: viewModel.selectedTopic == topic, color: topic.color) {
                                viewModel.selectedTopic = viewModel.selectedTopic == topic ? nil : topic
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Overall progress
                HStack {
                    let overall = LessonEngine.overallProgress(
                        allTracks: MockDataService.lessonTracks,
                        completedIDs: completedIDs
                    )
                    ProgressRing(progress: overall, lineWidth: 4, size: 32, gradientColors: [.blue, .purple])
                    
                    VStack(alignment: .leading) {
                        Text("Overall Progress")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(Int(overall * 100))% complete • \(completedIDs.count) lessons done")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Track list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredTracks) { track in
                            let progress = viewModel.trackProgress(track: track, completedIDs: completedIDs)
                            let completedCount = track.lessons.filter { completedIDs.contains($0.id) }.count
                            
                            NavigationLink {
                                LessonListView(track: track, selectedLesson: $selectedLesson)
                                    .environment(appState)
                            } label: {
                                LessonTrackRow(track: track, progress: progress, completedCount: completedCount)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Learn")
            .navigationDestination(item: $selectedLesson) { lesson in
                LessonDetailView(lesson: lesson) {
                    selectedLesson = nil
                }
                .environment(appState)
            }
            .onAppear {
                viewModel.loadTracks(for: appState.userProfile)
            }
        }
    }
}

#Preview {
    LearnView()
        .environment(AppState())
}
