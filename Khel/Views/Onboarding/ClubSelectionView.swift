import SwiftUI

struct ClubSelectionView: View {
    let clubs: [Club]
    @Binding var selectedClubIDs: Set<String>
    var toggleClub: (String) -> Void
    
    @State private var searchText = ""
    
    var filteredClubs: [Club] {
        if searchText.isEmpty { return clubs }
        return clubs.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var clubsByLeague: [(String, [Club])] {
        let grouped = Dictionary(grouping: filteredClubs) { $0.leagueID }
        return grouped.sorted { pair1, pair2 in
            let name1 = MockDataService.league(byID: pair1.key)?.name ?? ""
            let name2 = MockDataService.league(byID: pair2.key)?.name ?? ""
            return name1 < name2
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Pick your clubs")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Select the clubs you want to follow")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
            
            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search clubs...", text: $searchText)
            }
            .padding(10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 20, pinnedViews: .sectionHeaders) {
                    ForEach(clubsByLeague, id: \.0) { leagueID, leagueClubs in
                        Section {
                            let columns = [GridItem(.flexible()), GridItem(.flexible())]
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(leagueClubs) { club in
                                    let isSelected = selectedClubIDs.contains(club.id)
                                    
                                    Button {
                                        withAnimation(.spring(response: 0.3)) {
                                            toggleClub(club.id)
                                        }
                                    } label: {
                                        VStack(spacing: 8) {
                                            Circle()
                                                .fill(club.primaryColor)
                                                .frame(width: 44, height: 44)
                                                .overlay(
                                                    Text(club.shortName)
                                                        .font(.caption2)
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(.white)
                                                )
                                            
                                            Text(club.name)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundStyle(.primary)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.8)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(isSelected ? club.primaryColor.opacity(0.1) : Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isSelected ? club.primaryColor : .clear, lineWidth: 2)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        } header: {
                            let league = MockDataService.league(byID: leagueID)
                            HStack {
                                Text(league?.flagEmoji ?? "")
                                Text(league?.name ?? leagueID)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ClubSelectionView(
        clubs: MockDataService.allClubs,
        selectedClubIDs: .constant(["arsenal"]),
        toggleClub: { _ in }
    )
}
