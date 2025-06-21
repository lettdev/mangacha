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
            AsyncImage(url: URL(string: item.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle().fill(Color.gray.opacity(0.2))
            }
            .frame(height: 200)
            .clipped()
            .cornerRadius(12)

            Text(item.titleEnglish)
                .font(.headline)

            if let jp = item.titleJapanese {
                Text(jp)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Text(item.synopsis)
                .font(.footnote)
                .lineLimit(3)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}
