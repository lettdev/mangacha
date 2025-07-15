//
//  CardView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI

extension Rarity {
    var borderColor: Color {
        switch self {
        case .common: return .gray
        case .uncommon: return .blue
        case .rare: return .yellow
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
}

struct CardView: View {
    let card: MangachaCard

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background Image
            Color.clear
            .background(
                AsyncImage(url: URL(string: card.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.9))
                    }
                }
            )
            .clipped()
            
            // Info overlay
            VStack(alignment: .leading, spacing: 4) {
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.9), .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 240)
                .offset(y: -8)
                
                Spacer()
                
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.9)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 320)
                .offset(y: 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Info text
            VStack(alignment: .leading, spacing: 4) {
                Text(card.titleEnglish)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .shadow(radius: 4)

                if let jp = card.titleJapanese {
                    Text(jp)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(radius: 4)
                }
                
                HStack(spacing: 2) {
                    ForEach(1...card.stars, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .shadow(radius: 2)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .shadow(radius: 4)
                
                Spacer()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        if !card.genres.isEmpty {
                            ForEach(card.genres, id: \.self) { tag in
                                TagView(text: tag)
                            }
                        }
                        if !card.explicitGenres.isEmpty {
                            ForEach(card.explicitGenres, id: \.self) { tag in
                                TagView(text: tag, backgroundColor: .black)
                            }
                        }
                        if !card.themes.isEmpty {
                            ForEach(card.themes, id: \.self) { tag in
                                TagView(text: tag, backgroundColor: .blue)
                            }
                        }
                        if !card.demographics.isEmpty {
                            ForEach(card.demographics, id: \.self) { tag in
                                TagView(text: tag, backgroundColor: .pink)
                            }
                        }
                    }
                }
                
                Text(card.synopsis)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .padding(.bottom, 32)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(24)
        .clipped()
        .background(
            RoundedRectangle(cornerRadius: 24)
                    .stroke(card.rarity.borderColor, lineWidth: 16)
                    .background(Color.clear)
        )
        .padding(16)
        .shadow(radius: 8)
    }
}

#Preview {
    CardView(
        card: MockData.randomMangachaCard()
    )
}
