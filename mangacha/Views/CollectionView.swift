//
//  CollectionView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query(sort: \LikedManga.titleEnglish) var likedManga: [LikedManga]

    var body: some View {
        NavigationStack {
            if likedManga.isEmpty {
                VStack {
                    Image(systemName: "tray")
                        .font(.system(size: 48))
                        .padding(.bottom, 8)
                    Text("No liked manga yet.")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(likedManga) { item in
                            CollectionCardView(item: item)
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle("My Collection")
            }
        }
    }
}

