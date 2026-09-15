import SwiftUI

struct LiveMatchBanner: View {
    let match: Match
    var onTap: () -> Void
    
    var homeClub: Club? { MockDataService.club(byID: match.homeClubID) }
    var awayClub: Club? { MockDataService.club(byID: match.awayClubID) }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Live indicator
                HStack(spacing: 4) {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                    Text("LIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                }
                
                // Home
                HStack(spacing: 6) {
                    Circle()
                        .fill(homeClub?.primaryColor ?? .gray)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Text(homeClub?.shortName ?? "")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.white)
                        )
                    Text(homeClub?.shortName ?? "")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                // Score
                Text("\(match.homeScore) - \(match.awayScore)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .monospacedDigit()
                
                // Away
                HStack(spacing: 6) {
                    Text(awayClub?.shortName ?? "")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Circle()
                        .fill(awayClub?.primaryColor ?? .gray)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Text(awayClub?.shortName ?? "")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.white)
                        )
                }
                
                // Minute
                Text("\(match.currentMinute)'")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.red.opacity(0.1), .orange.opacity(0.05)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.red.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
