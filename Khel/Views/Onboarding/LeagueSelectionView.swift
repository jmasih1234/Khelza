import SwiftUI

struct LeagueSelectionView: View {
    @Binding var selectedLeagueIDs: Set<String>
    var toggleLeague: (String) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Choose your leagues")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Select at least one league to follow")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
            
            VStack(spacing: 12) {
                ForEach(MockDataService.leagues) { league in
                    let isSelected = selectedLeagueIDs.contains(league.id)
                    
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            toggleLeague(league.id)
                        }
                    } label: {
                        HStack(spacing: 16) {
                            Text(league.flagEmoji)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(league.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                
                                Text(league.country)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(league.clubs.count) clubs")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                                .foregroundStyle(isSelected ? league.primaryColor : .gray)
                        }
                        .padding()
                        .background(isSelected ? league.primaryColor.opacity(0.08) : Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? league.primaryColor : .clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    LeagueSelectionView(selectedLeagueIDs: .constant(["premier-league"])) { _ in }
}
