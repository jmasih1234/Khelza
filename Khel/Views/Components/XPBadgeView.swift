import SwiftUI

struct XPBadgeView: View {
    let xp: Int
    var animated: Bool = false
    
    @State private var showAnimation = false
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundStyle(.yellow)
            
            Text("+\(xp) XP")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.yellow)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .scaleEffect(showAnimation ? 1.2 : 1.0)
        .onAppear {
            if animated {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    showAnimation = true
                }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5).delay(0.2)) {
                    showAnimation = false
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        XPBadgeView(xp: 25, animated: true)
    }
}
