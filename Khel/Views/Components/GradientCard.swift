import SwiftUI

struct GradientCard<Content: View>: View {
    let colors: [Color]
    let cornerRadius: CGFloat
    @ViewBuilder var content: () -> Content
    
    init(colors: [Color] = [.blue, .purple], cornerRadius: CGFloat = 16, @ViewBuilder content: @escaping () -> Content) {
        self.colors = colors
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    var body: some View {
        content()
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    GradientCard(colors: [.orange, .red]) {
        VStack(alignment: .leading) {
            Text("Daily Challenge")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Test your knowledge")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    .padding()
}
