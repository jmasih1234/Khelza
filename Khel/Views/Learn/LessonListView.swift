import SwiftUI

struct LessonListView: View {
    @Environment(AppState.self) private var appState
    let track: LessonTrack
    @Binding var selectedLesson: Lesson?
    
    var completedIDs: Set<String> {
        Set(appState.userProfile.completedLessonIDs)
    }
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    Image(systemName: track.topic.icon)
                        .font(.largeTitle)
                        .foregroundStyle(track.topic.color)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(track.title)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(track.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowBackground(Color.clear)
            }
            
            Section("Lessons") {
                ForEach(track.lessons) { lesson in
                    let isCompleted = completedIDs.contains(lesson.id)
                    
                    Button {
                        selectedLesson = lesson
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(isCompleted ? .green : .gray)
                                .font(.title3)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(lesson.title)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)
                                
                                Text(lesson.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                HStack(spacing: 2) {
                                    Image(systemName: "clock")
                                        .font(.caption2)
                                    Text("\(lesson.estimatedMinutes)m")
                                        .font(.caption2)
                                }
                                .foregroundStyle(.secondary)
                                
                                Text("+\(lesson.xpReward) XP")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(track.topic.rawValue)
    }
}
