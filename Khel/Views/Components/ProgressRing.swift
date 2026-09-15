import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let lineWidth: CGFloat
    let size: CGFloat
    var gradientColors: [Color] = [.blue, .purple]
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: gradientColors),
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    ProgressRing(progress: 0.65, lineWidth: 8, size: 80)
}
