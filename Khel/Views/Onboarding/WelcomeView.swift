import SwiftUI

struct WelcomeView: View {
    @Binding var userName: String
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "soccerball")
                .font(.system(size: 80))
                .foregroundStyle(.green)
                .symbolEffect(.pulse)
            
            VStack(spacing: 12) {
                Text("Welcome to Khel")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your personal sports learning companion")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "book.fill")
                        .foregroundStyle(.blue)
                        .frame(width: 30)
                    Text("Learn the game through interactive lessons")
                        .font(.subheadline)
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .foregroundStyle(.red)
                        .frame(width: 30)
                    Text("Follow live matches with real-time insights")
                        .font(.subheadline)
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "gamecontroller.fill")
                        .foregroundStyle(.purple)
                        .frame(width: 30)
                    Text("Test your knowledge with quizzes & challenges")
                        .font(.subheadline)
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .frame(width: 30)
                    Text("Earn XP, badges, and climb the leaderboard")
                        .font(.subheadline)
                    Spacer()
                }
            }
            .padding(.horizontal, 32)
            
            TextField("What's your name?", text: $userName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    WelcomeView(userName: .constant(""))
}
