import SwiftUI

struct CardActionButton: View {
    let systemImage: String
    let color: Color
    let highlighted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 24))
                .padding()
                .foregroundColor(highlighted ? .white : color)
        }
        .modifier(ButtonGlassStyleIfAvailable(highlighted: highlighted, color: color))
        .clipShape(Circle())
    }
}

#Preview {
    CardActionButton(systemImage: "heart.fill", color: .red, highlighted: false) {
        print("Tapped")
    }
    .padding()
}

private struct ButtonGlassStyleIfAvailable: ViewModifier {
    let highlighted: Bool
    let color: Color
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(highlighted ? .regular.tint(color) : .regular)
        } else {
            content
        }
    }
}
