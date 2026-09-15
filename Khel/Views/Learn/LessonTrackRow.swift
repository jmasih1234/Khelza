import SwiftUI

struct LessonTrackRow: View {
    let track: LessonTrack
    let progress: Double
    let completedCount: Int
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                ProgressRing(
                    progress: progress,
                    lineWidth: 4,
                    size: 52,
                    gradientColors: [track.topic.color, track.topic.color.opacity(0.6)]
                )
                
                Image(systemName: track.topic.icon)
                    .font(.title3)
                    .foregroundStyle(track.topic.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.headline)
                
                Text(track.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text("\(completedCount)/\(track.lessons.count) lessons")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    if progress >= 1.0 {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(track.difficulty.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(difficultyColor.opacity(0.15))
                    .foregroundStyle(difficultyColor)
                    .clipShape(Capsule())
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(track.topic.color)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var difficultyColor: Color {
        switch track.difficulty {
        case .beginner: .green
        case .intermediate: .orange
        case .advanced: .red
        }
    }
}
