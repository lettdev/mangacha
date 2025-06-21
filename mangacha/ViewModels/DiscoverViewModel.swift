//
//  DiscoverViewModel.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI
import Foundation
import SwiftData

enum SwipeDirection {
    case like
    case dislike
    case undo
}

@MainActor
class DiscoverViewModel: ObservableObject {
    // Remove @Environment - this doesn't work in ObservableObject classes
    private var modelContext: ModelContext?

    @Published var swipeQueue: [MangachaCard] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var undoCount: Int = 3
    private var swipeHistory: [(MangachaCard, SwipeDirection)] = []
    private var lastUndoDate: Date?
    
    let maxCardsPerSession = 10
    
    private var seenIds: Set<Int> = []
    
    init(swipeQueue: [MangachaCard] = [], modelContext: ModelContext? = nil) {
        self.swipeQueue = swipeQueue
        self.modelContext = modelContext
    }
    
    // Add method to set model context
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func preloadCards() async {
        isLoading = true
        swipeQueue = []
        seenIds = []
        errorMessage = nil
        
        var loadedCards: [MangachaCard] = []
        
        while loadedCards.count < maxCardsPerSession {
            do {
                let card = try await JikanAPIService.shared.fetchRandomMangaCard()
                
                guard !seenIds.contains(card.id) else { continue }
                
                seenIds.insert(card.id)
                loadedCards.append(card)
                
                try await Task.sleep(nanoseconds: 200_000_000)
            } catch {
                errorMessage = "Failed to fetch: \(error.localizedDescription)"
                print("Error: \(error)")
                break
            }
        }
        
        swipeQueue = loadedCards
        isLoading = false
    }
    
    func swipeCard(_ direction: SwipeDirection) {
        guard !swipeQueue.isEmpty else { return }
        
        let card = swipeQueue.removeFirst()
        swipeHistory.append((card, direction))
        
        switch direction {
        case .like:
            print("Liked: \(card.titleEnglish)")
            let saved = LikedManga(from: card)
            
            // Use the modelContext to save
            if let context = modelContext {
                context.insert(saved)
                do {
                    try context.save()
                    print("Successfully saved: \(card.titleEnglish)")
                } catch {
                    print("Failed to save: \(error)")
                }
            } else {
                print("ModelContext is nil - cannot save")
            }
        case .dislike:
            print("Disliked: \(card.titleEnglish)")
        case .undo:
            break
        }
    }
    
    func undoLastSwipe() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = lastUndoDate, Calendar.current.isDate(lastDate, inSameDayAs: today) == false {
            undoCount = 3
        }
        
        guard undoCount > 0 else {
            print("Undo limit reached")
            return
        }
        
        guard let (card, direction) = swipeHistory.popLast() else {
            print("No swipes to undo")
            return
        }
        
        // If we're undoing a like, remove it from the database
        if direction == .like, let context = modelContext {
            let fetchDescriptor = FetchDescriptor<LikedManga>(
                predicate: #Predicate { $0.id == card.id }
            )
            do {
                let results = try context.fetch(fetchDescriptor)
                if let mangaToDelete = results.first {
                    context.delete(mangaToDelete)
                    try context.save()
                    print("Removed from collection: \(card.titleEnglish)")
                }
            } catch {
                print("Failed to remove from collection: \(error)")
            }
        }
        
        swipeQueue.insert(card, at: 0)
        undoCount -= 1
        lastUndoDate = today
    }
}
