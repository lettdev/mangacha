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
    @State private var isDragging = false
    
    private var rotationAngle: Double {
        Double(offset.width / 20)
    }
    
    var body: some View {
        CardView(card: card)
            .offset(offset)
            .rotationEffect(.degrees(rotationAngle))
            .scaleEffect(isDragging ? 1.05 : 1.0)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        isDragging = true
                        offset = gesture.translation
                        onDragUpdate?(offset.width)
                    }
                    .onEnded { gesture in
                        isDragging = false
                        
                        if abs(gesture.translation.width) > 120 {
                            let direction: SwipeDirection = gesture.translation.width > 0 ? .like : .dislike
                            
                            // Animate the card off screen
                            withAnimation(.easeOut(duration: 0.3)) {
                                offset = CGSize(
                                    width: gesture.translation.width > 0 ? 1000 : -1000,
                                    height: gesture.translation.height
                                )
                            }
                            
                            // Call the swipe action after animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onSwipe(direction)
                                offset = .zero
                                onDragEnd?()
                            }
                        } else {
                            // Snap back to center
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                offset = .zero
                            }
                            onDragEnd?()
                        }
                    }
            )
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
