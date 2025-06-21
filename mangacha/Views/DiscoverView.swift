//
//  DiscoverView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var discoverModel = DiscoverViewModel()
//    @ObservedObject var discoverModel: DiscoverViewModel
    
    var body: some View {
        if discoverModel.isLoading {
            CardsLoading()
        } else if let error = discoverModel.errorMessage {
            CardsError(error: error) {
                Task {
                    await discoverModel.preloadCards()
                }
            }
        } else if discoverModel.swipeQueue.isEmpty {
            CardsOutOfStock {
                Task {
                    await discoverModel.preloadCards()
                }
            }
        } else {
           CardsLoaded(discoverModel: discoverModel)
        }
    }
}

//#Preview {
//    DiscoverView(
//        discoverModel: DiscoverViewModel(
//            swipeQueue: [
//                MangachaCard(
//                    id: 24680,
//                    titleEnglish: "Berserk",
//                    titleJapanese: "ベルセルク",
//                    imageUrl: "https://cdn.myanimelist.net/images/manga/1/157897.jpg",
//                    synopsis: "A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts.",
//                    genres: ["Action", "Horror", "Fantasy"],
//                    explicitGenres: [],
//                    themes: [],
//                    demographics: [],
//                    stars: 8,
//                    rarity: .legendary,
//                    quality: .noir,
//                    rank: 10,
//                    popularity: 15,
//                    status: "Finished"
//                )
//            ]
//        )
//    )
//}

