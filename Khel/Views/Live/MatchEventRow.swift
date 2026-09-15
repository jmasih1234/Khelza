import SwiftUI

struct MatchEventRow: View {
    let event: MatchEvent
    @State private var isExpanded: Bool = false
    
    var club: Club? { MockDataService.club(byID: event.clubID) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Minute
                Text("\(event.minute)'")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .frame(width: 30)
                
                // Event icon
                Image(systemName: event.icon)
                    .font(.body)
                    .foregroundStyle(Color(hex: event.type.accentColorHex))
                    .frame(width: 24)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.description)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if !event.playerName.isEmpty {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(club?.primaryColor ?? .gray)
                                .frame(width: 12, height: 12)
                            Text(club?.shortName ?? "")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // Expand button
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundStyle(isExpanded ? .yellow : .gray)
                        .padding(6)
                        .background(isExpanded ? .yellow.opacity(0.15) : Color(.systemGray5))
                        .clipShape(Circle())
                }
            }
            
            // Educational note
            if isExpanded {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    
                    Text(event.educationalNote)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineSpacing(2)
                }
                .padding(12)
                .background(.yellow.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 66)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 4)
    }
}
