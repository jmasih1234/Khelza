import SwiftUI

struct KnowledgeLevelView: View {
    @Binding var selectedLevel: KnowledgeLevel
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("How well do you know soccer?")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("This helps us personalize your experience")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
            
            VStack(spacing: 16) {
                ForEach(KnowledgeLevel.allCases) { level in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedLevel = level
                        }
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: level.icon)
                                .font(.title2)
                                .foregroundStyle(selectedLevel == level ? .white : levelColor(level))
                                .frame(width: 44, height: 44)
                                .background(selectedLevel == level ? levelColor(level) : levelColor(level).opacity(0.15))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(level.rawValue)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                
                                Text(level.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            if selectedLevel == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(levelColor(level))
                            }
                        }
                        .padding()
                        .background(selectedLevel == level ? levelColor(level).opacity(0.08) : Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedLevel == level ? levelColor(level) : .clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private func levelColor(_ level: KnowledgeLevel) -> Color {
        switch level {
        case .beginner: .green
        case .intermediate: .orange
        case .advanced: .red
        }
    }
}

#Preview {
    KnowledgeLevelView(selectedLevel: .constant(.beginner))
}
