import SwiftUI

struct UpcomingMatchCard: View {
    let match: Match
    
    var homeClub: Club? { MockDataService.club(byID: match.homeClubID) }
    var awayClub: Club? { MockDataService.club(byID: match.awayClubID) }
    var league: League? { MockDataService.league(byID: match.leagueID) }
    
    var body: some View {
        VStack(spacing: 12) {
            // League header
            HStack {
                Text(league?.flagEmoji ?? "")
                Text(league?.name ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Matchday \(match.matchDay)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            // Teams and score/time
            HStack {
                // Home team
                VStack(spacing: 6) {
                    Circle()
                        .fill(homeClub?.primaryColor ?? .gray)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(homeClub?.shortName ?? "")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )
                    Text(homeClub?.shortName ?? "HOME")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                
                // Score or time
                VStack(spacing: 4) {
                    if match.status == .scheduled {
                        Text(match.kickoffDate, format: .dateTime.hour().minute())
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(match.kickoffDate, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    } else {
                        HStack(spacing: 8) {
                            Text("\(match.homeScore)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("-")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            Text("\(match.awayScore)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        if match.status.isActive {
                            Text("\(match.currentMinute)'")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        } else {
                            Text(match.status.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // Away team
                VStack(spacing: 6) {
                    Circle()
                        .fill(awayClub?.primaryColor ?? .gray)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(awayClub?.shortName ?? "")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        )
                    Text(awayClub?.shortName ?? "AWAY")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
