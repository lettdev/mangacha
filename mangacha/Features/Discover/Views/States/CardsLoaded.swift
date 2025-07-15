//
//  CardsLoaded.swift
//  mangacha
//
//  Created by Tung Le on 20/06/25.
//

import SwiftUI

struct CardsLoaded: View {
    @ObservedObject var discoverModel: DiscoverViewModel
    @State private var highlightedAction: SwipeDirection? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            // Cards stack
            ZStack {
                let visibleCards = discoverModel.swipeQueue.prefix(3)
                ForEach(Array(visibleCards.reversed().enumerated()), id: \.1.id) { index, card in
                    let isTopCard = index == visibleCards.count - 1
                    SwipeableCardView(
                        card: card,
                        onSwipe: { direction in
                            discoverModel.swipeCard(direction)
                            highlightedAction = nil
                        },
                        onDragUpdate: { drag in
                            if drag > 40 { highlightedAction = .like }
                            else if drag < -40 { highlightedAction = .dislike }
                            else { highlightedAction = nil }
                        },
                        onDragEnd: { highlightedAction = nil }
                    )
                    .scaleEffect(isTopCard ? 1 : 0.95)
                    .zIndex(Double(index))
                }
            }
            .padding(.bottom, 32)

            // Action buttons
            HStack(spacing: 20) {
                CardActionButton(
                    systemImage: "arrow.uturn.backward.circle.fill",
                    color: .blue,
                    highlighted: false,
                    action: { discoverModel.undoLastSwipe() }
                )
                .disabled(discoverModel.undoCount == 0)
                .opacity(discoverModel.undoCount == 0 ? 0.3 : 1.0)
                
                CardActionButton(
                    systemImage: "trash.fill",
                    color: .red,
                    highlighted: highlightedAction == .dislike,
                    action: { discoverModel.swipeCard(.dislike) }
                )
                .disabled(!discoverModel.canSwipe)
                .opacity(!discoverModel.canSwipe ? 0.3 : 1.0)
                
                CardActionButton(
                    systemImage: "heart.fill",
                    color: .green,
                    highlighted: highlightedAction == .like,
                    action: { discoverModel.swipeCard(.like) }
                )
                .disabled(!discoverModel.canSwipe)
                .opacity(!discoverModel.canSwipe ? 0.3 : 1.0)
                
                CardActionButton(
                    systemImage: "info.bubble.fill",
                    color: .yellow,
                    highlighted: false,
                    action: {}
                )
            }
            .padding()
        }
    }
}
