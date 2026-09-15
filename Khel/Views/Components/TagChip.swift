import SwiftUI

struct TagChip: View {
    let title: String
    let isSelected: Bool
    var color: Color = .blue
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? color.opacity(0.15) : Color(.systemGray6))
                .foregroundStyle(isSelected ? color : .secondary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? color : Color.clear, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        TagChip(title: "Premier League", isSelected: true, color: .purple) {}
        TagChip(title: "La Liga", isSelected: false) {}
    }
}
