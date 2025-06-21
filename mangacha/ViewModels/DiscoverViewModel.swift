//
//  DiscoverViewModel.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//
import SwiftUI
import Foundation

enum SwipeDirection {
    case like
    case dislike
    case undo
}

@MainActor
class DiscoverViewModel: ObservableObject {
    @Environment(\.modelContext) private var modelContext

    @Published var swipeQueue: [MangachaCard] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var undoCount: Int = 3
    private var swipeHistory: [(MangachaCard, SwipeDirection)] = []
    private var lastUndoDate: Date?
    
    let maxCardsPerSession = 10
    
    private var seenIds: Set<Int> = []
    
    init(swipeQueue: [MangachaCard] = []) {
        self.swipeQueue = swipeQueue
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
            modelContext.insert(saved)
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
        
        guard let (card, _) = swipeHistory.popLast() else {
            print("No swipes to undo")
            return
        }
        
        swipeQueue.insert(card, at: 0)
        undoCount -= 1
        lastUndoDate = today
    }
}
