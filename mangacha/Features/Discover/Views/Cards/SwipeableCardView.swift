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
        card: MockData.randomMangachaCard(),
        onSwipe: { _ in },
        onDragUpdate: nil,
        onDragEnd: nil
    )
}
