import SwiftUI

struct StreakFlame: View {
    let count: Int
    var size: CGFloat = 24
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: count > 0 ? "flame.fill" : "flame")
                .font(.system(size: size))
                .foregroundStyle(count > 0 ? .orange : .gray)
                .symbolEffect(.bounce, value: count)
            
            Text("\(count)")
                .font(.system(size: size * 0.7, weight: .bold))
                .foregroundStyle(count > 0 ? .orange : .gray)
        }
    }
}

#Preview {
    VStack {
        StreakFlame(count: 7)
        StreakFlame(count: 0)
    }
}
