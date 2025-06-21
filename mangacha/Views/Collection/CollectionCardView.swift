//
//  CollectionCardView.swift
//  mangacha
//
//  Created by Tung Le on 21/06/25.
//

import SwiftUI

struct CollectionCardView: View {
    let item: LikedManga
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: item.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.8)
                        )
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(item.rarityEnum.borderColor, lineWidth: 2)
                )
                
                // Stars rating overlay
                HStack(spacing: 1) {
                    ForEach(1...item.stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.titleEnglish)
                    .font(.subheadline.bold())
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                if let jp = item.titleJapanese {
                    Text(jp)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // Rarity badge
                Text(item.rarityEnum.rawValue.capitalized)
                    .font(.caption2.bold())
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(item.rarityEnum.borderColor.opacity(0.2))
                    .foregroundColor(item.rarityEnum.borderColor)
                    .clipShape(Capsule())

                Text(item.synopsis)
                    .font(.caption)
                    .lineLimit(3)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 4)
        .contextMenu {
            Button(role: .destructive) {
                // TODO: Add delete functionality
            } label: {
                Label("Remove from Collection", systemImage: "trash")
            }
        }
    }
}

#Preview {
    let sampleManga = LikedManga(from: MangachaCard(
        id: 1,
        titleEnglish: "One Piece",
        titleJapanese: "ワンピース",
        imageUrl: "https://cdn.myanimelist.net/images/manga/2/253146.jpg",
        synopsis: "Monkey D. Luffy refuses to let anyone or anything stand in the way of his quest to become the king of all pirates.",
        genres: ["Action", "Adventure"],
        explicitGenres: [],
        themes: [],
        demographics: [],
        stars: 9,
        rarity: .legendary,
        quality: .prismatic,
        rank: 1,
        popularity: 1,
        status: "Publishing"
    ))
    
    CollectionCardView(item: sampleManga)
        .frame(width: 160)
        .padding()
}
