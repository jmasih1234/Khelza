import SwiftUI

struct MatchEventRow: View {
    let event: MatchEvent
    var onExplainThis: (() -> Void)?
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
                    .opacity(event.isOverturned ? 0.5 : 1.0)
                    .frame(width: 30)
                
                // Event icon
                ZStack {
                    Image(systemName: event.icon)
                        .font(.body)
                        .foregroundStyle(iconColor)
                    
                    // Strikethrough overlay for overturned events
                    if event.isOverturned {
                        Image(systemName: "line.diagonal")
                            .font(.title3)
                            .foregroundStyle(.red.opacity(0.8))
                    }
                }
                .frame(width: 24)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.description)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .strikethrough(event.isOverturned, color: .red.opacity(0.6))
                        .foregroundStyle(event.isOverturned ? .secondary : .primary)
                    
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
                    
                    // Overturned badge
                    if event.isOverturned {
                        Text("OVERTURNED")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.red.opacity(0.7))
                            .clipShape(Capsule())
                    }
                    
                    // VAR Review badge
                    if event.type == .varCheck {
                        HStack(spacing: 4) {
                            ProgressView()
                                .controlSize(.mini)
                            Text("VAR REVIEWING...")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.purple)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(.purple.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
                
                Spacer()
                
                // Buttons
                HStack(spacing: 4) {
                    // Explain This button (for eligible events)
                    if event.type.hasExplanation, let onExplain = onExplainThis {
                        Button {
                            onExplain()
                        } label: {
                            Text("Explain")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.blue.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                    
                    // Educational note toggle
                    if !event.educationalNote.isEmpty {
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
        .opacity(event.isOverturned ? 0.65 : 1.0)
    }
    
    private var iconColor: Color {
        if event.isOverturned {
            return .gray
        }
        return Color(hex: event.type.accentColorHex)
    }
}
