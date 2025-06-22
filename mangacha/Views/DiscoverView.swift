//
//  DiscoverView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI
import SwiftData

struct DiscoverView: View {
    @StateObject private var discoverModel = DiscoverViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Group {
                if discoverModel.isInCooldown {
                    CardsCooldown(discoverModel: discoverModel)
                } else if discoverModel.isLoading {
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
            .navigationTitle("Discover")
            .onAppear {
                // Set the model context when the view appears
                discoverModel.setModelContext(modelContext)
                
                // Load cards if queue is empty and not in cooldown
                if discoverModel.swipeQueue.isEmpty && discoverModel.canSwipe {
                    Task {
                        await discoverModel.preloadCards()
                    }
                }
            }
        }
    }
}

#Preview {
    DiscoverView()
        .modelContainer(for: [LikedManga.self])
}
