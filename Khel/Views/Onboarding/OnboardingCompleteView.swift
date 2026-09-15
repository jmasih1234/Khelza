import SwiftUI

struct OnboardingCompleteView: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)
                .symbolEffect(.bounce)
            
            VStack(spacing: 12) {
                Text("You're all set, \(profile.name.isEmpty ? "Fan" : profile.name)!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Your personalized soccer journey begins now")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                summaryRow(icon: "star.fill", color: .yellow,
                           text: "\(profile.knowledgeLevel.rawValue) level")
                summaryRow(icon: "flag.fill", color: .blue,
                           text: "\(profile.favoriteLeagueIDs.count) league\(profile.favoriteLeagueIDs.count == 1 ? "" : "s")")
                summaryRow(icon: "shield.fill", color: .purple,
                           text: "\(profile.favoriteClubIDs.count) club\(profile.favoriteClubIDs.count == 1 ? "" : "s")")
                summaryRow(icon: "person.fill", color: .green,
                           text: "\(profile.favoritePlayerIDs.count) player\(profile.favoritePlayerIDs.count == 1 ? "" : "s")")
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 32)
            
            XPBadgeView(xp: 50, animated: true)
                .scaleEffect(1.3)
            
            Text("Welcome bonus earned!")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
    }
    
    private func summaryRow(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

#Preview {
    OnboardingCompleteView(profile: UserProfile(
        name: "Joshua",
        favoriteLeagueIDs: ["premier-league", "la-liga"],
        favoriteClubIDs: ["arsenal", "real-madrid"],
        favoritePlayerIDs: ["saka"]
    ))
}
