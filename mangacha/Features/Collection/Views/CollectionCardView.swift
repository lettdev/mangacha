//
//  CollectionCardView.swift
//  mangacha
//
//  Created by Tung Le on 21/06/25.
//

import SwiftUI

struct CollectionCardView: View {
    let item: LikedManga
    let onDelete: () -> Void
    
    var body: some View {
        VStack() {
            // Stars rating
            HStack(spacing: 1) {
                ForEach(1...item.stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
            .padding(8)
            
            // Cover image
            AsyncImage(url: URL(string: item.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_):
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                Text("Failed to load \(item.imageUrl)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        )
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.8)
                        )
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
            }
            .frame(width: 150, height: 150)
            .clipped()
            
            // Title
            Text(item.titleEnglish)
                .font(.subheadline.bold())
                .foregroundColor(item.rarityEnum.borderColor)
                .lineLimit(2)

            if let jp = item.titleJapanese {
                Text(jp)
                    .font(.caption)
                    .foregroundColor(.gray)
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
        }
        .frame(maxWidth: .infinity)
        .padding(6)
        .padding(.bottom, 6)
        .background(.black)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(item.rarityEnum.borderColor, lineWidth: 6)
        )
        .contextMenu {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Remove from Collection", systemImage: "trash")
            }
        }
    }
}

#Preview {
    let sampleManga = MockData.randomLikedManga()
    
    CollectionCardView(item: sampleManga, onDelete: {})
        .frame(width: 160)
        .padding()
}
