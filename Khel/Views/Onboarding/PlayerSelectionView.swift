import SwiftUI

struct PlayerSelectionView: View {
    let players: [Player]
    @Binding var selectedPlayerIDs: Set<String>
    var togglePlayer: (String) -> Void
    
    var playersByClub: [(String, [Player])] {
        let grouped = Dictionary(grouping: players) { $0.clubID }
        return grouped.sorted { pair1, pair2 in
            let name1 = MockDataService.club(byID: pair1.key)?.name ?? ""
            let name2 = MockDataService.club(byID: pair2.key)?.name ?? ""
            return name1 < name2
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Follow your favorite players")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Optional — you can skip this step")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
            
            if players.isEmpty {
                Spacer()
                EmptyStateView(
                    icon: "person.3.fill",
                    title: "No Players Available",
                    message: "Select some clubs first to see their players"
                )
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(playersByClub, id: \.0) { clubID, clubPlayers in
                            let club = MockDataService.club(byID: clubID)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Circle()
                                        .fill(club?.primaryColor ?? .gray)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Text(club?.shortName ?? "")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundStyle(.white)
                                        )
                                    Text(club?.name ?? clubID)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                
                                ForEach(clubPlayers) { player in
                                    let isSelected = selectedPlayerIDs.contains(player.id)
                                    
                                    Button {
                                        withAnimation(.spring(response: 0.3)) {
                                            togglePlayer(player.id)
                                        }
                                    } label: {
                                        HStack {
                                            Text("#\(player.shirtNumber)")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.secondary)
                                                .frame(width: 30)
                                            
                                            Text(player.name)
                                                .font(.subheadline)
                                                .foregroundStyle(.primary)
                                            
                                            Text(player.position.rawValue)
                                                .font(.caption2)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color(.systemGray5))
                                                .clipShape(Capsule())
                                            
                                            Spacer()
                                            
                                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                                .foregroundStyle(isSelected ? .green : .gray)
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(isSelected ? Color.green.opacity(0.08) : Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    PlayerSelectionView(
        players: MockDataService.premierLeague.clubs[0].players,
        selectedPlayerIDs: .constant(["saka"]),
        togglePlayer: { _ in }
    )
}
