//
//  SwipableCardView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI

struct SwipeableCardView: View {
    let card: MangachaCard
    let onSwipe: (SwipeDirection) -> Void
    let onDragUpdate: ((CGFloat) -> Void)?
    let onDragEnd: (() -> Void)?
    
    @State private var offset = CGSize.zero
    @GestureState private var isDragging = false
    
    var body: some View {
        CardView(card: card)
            .offset(offset)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .gesture(
                DragGesture()
                    .updating($isDragging) { _, state, _ in state = true }
                    .onChanged { drag in
                        offset = drag.translation
                        onDragUpdate?(offset.width)
                    }
                    .onEnded { gesture in
                        if abs(gesture.translation.width) > 120 {
                            let direction: SwipeDirection = gesture.translation.width > 0 ? .like : .dislike
                            withAnimation(.easeOut) {
                                offset.width = gesture.translation.width > 0 ? 1000 : -1000
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onSwipe(direction)
                                offset = .zero
                                onDragEnd?()
                            }
                        } else {
                            withAnimation {
                                offset = .zero
                            }
                            onDragEnd?()
                        }
                    }
            )
            .animation(.spring(), value: offset)
    }
}

#Preview {
    SwipeableCardView(
        card: MangachaCard(
            id: 24680,
            titleEnglish: "Berserk",
            titleJapanese: "ベルセルク",
            imageUrl: "https://cdn.myanimelist.net/images/manga/1/157897.jpg",
            synopsis: "A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts. A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts. A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts. A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts. A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts. A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts.",
            genres: ["Action", "Horror", "Fantasy"],
            explicitGenres: [],
            themes: [],
            demographics: [],
            stars: 8,
            rarity: .legendary,
            quality: .noir,
            rank: 10,
            popularity: 15,
            status: "Hiatus"
        ),
        onSwipe: { _ in },
        onDragUpdate: nil,
        onDragEnd: nil
    )
}
