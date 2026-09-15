import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var buttonTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            if let buttonTitle, let action {
                Button(action: action) {
                    Text(buttonTitle)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(
        icon: "sportscourt",
        title: "No Live Matches",
        message: "There are no live matches right now. Check back during match times!",
        buttonTitle: "View Schedule"
    ) {}
}
