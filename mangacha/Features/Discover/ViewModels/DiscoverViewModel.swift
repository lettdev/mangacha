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
    private var modelContext: ModelContext?

    @Published var swipeQueue: [MangachaCard] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var undoCount: Int = 3
    @Published var cardsThisSession: Int = 0
    @Published var isInCooldown: Bool = false
    @Published var cooldownTimeRemaining: TimeInterval = 0
    
    private var swipeHistory: [(MangachaCard, SwipeDirection)] = []
    private var cooldownTimer: Timer?
    private var cooldownStartTime: Date?
    
    let maxCardsPerSession = 16
    let cooldownDuration: TimeInterval = 5 * 60 // 5 minutes
    
    private var seenIds: Set<Int> = []
    
    // UserDefaults keys
    private let undoCountKey = "undoCount"
    private let lastUndoResetDateKey = "lastUndoResetDate"
    private let sessionStartTimeKey = "sessionStartTime"
    private let cardsCountKey = "cardsThisSession"
    private let cooldownStartTimeKey = "cooldownStartTime"
    
    init(swipeQueue: [MangachaCard] = [], modelContext: ModelContext? = nil) {
        self.swipeQueue = swipeQueue
        self.modelContext = modelContext
        loadPersistentData()
        checkCooldownStatus()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func loadPersistentData() {
        // Load undo count and check if it needs to be reset
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastResetDate = UserDefaults.standard.object(forKey: lastUndoResetDateKey) as? Date {
            if !Calendar.current.isDate(lastResetDate, inSameDayAs: today) {
                // New day, reset undo count
                undoCount = 3
                UserDefaults.standard.set(today, forKey: lastUndoResetDateKey)
                UserDefaults.standard.set(3, forKey: undoCountKey)
            } else {
                // Same day, load saved count
                undoCount = UserDefaults.standard.integer(forKey: undoCountKey)
                if undoCount == 0 { undoCount = 3 } // Handle first time setup
            }
        } else {
            // First time setup
            undoCount = 3
            UserDefaults.standard.set(today, forKey: lastUndoResetDateKey)
            UserDefaults.standard.set(3, forKey: undoCountKey)
        }
        
        // Load session data
        cardsThisSession = UserDefaults.standard.integer(forKey: cardsCountKey)
        
        if let savedCooldownStart = UserDefaults.standard.object(forKey: cooldownStartTimeKey) as? Date {
            cooldownStartTime = savedCooldownStart
        }
    }
    
    private func savePersistentData() {
        UserDefaults.standard.set(undoCount, forKey: undoCountKey)
        UserDefaults.standard.set(cardsThisSession, forKey: cardsCountKey)
        
        if let cooldownStart = cooldownStartTime {
            UserDefaults.standard.set(cooldownStart, forKey: cooldownStartTimeKey)
        } else {
            UserDefaults.standard.removeObject(forKey: cooldownStartTimeKey)
        }
    }
    
    private func checkCooldownStatus() {
        guard let cooldownStart = cooldownStartTime else {
            isInCooldown = false
            return
        }
        
        let timeElapsed = Date().timeIntervalSince(cooldownStart)
        
        if timeElapsed >= cooldownDuration {
            // Cooldown is over
            endCooldown()
        } else {
            // Still in cooldown
            isInCooldown = true
            cooldownTimeRemaining = cooldownDuration - timeElapsed
            startCooldownTimer()
        }
    }
    
    private func startCooldown() {
        isInCooldown = true
        cooldownStartTime = Date()
        cooldownTimeRemaining = cooldownDuration
        savePersistentData()
        startCooldownTimer()
    }
    
    private func startCooldownTimer() {
        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            Task { @MainActor in
                if let cooldownStart = self.cooldownStartTime {
                    let timeElapsed = Date().timeIntervalSince(cooldownStart)
                    let remaining = self.cooldownDuration - timeElapsed
                    
                    if remaining <= 0 {
                        self.endCooldown()
                    } else {
                        self.cooldownTimeRemaining = remaining
                    }
                }
            }
        }
    }
    
    private func endCooldown() {
        isInCooldown = false
        cooldownTimeRemaining = 0
        cooldownStartTime = nil
        cardsThisSession = 0
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        savePersistentData()
    }
    
    var cooldownTimeString: String {
        let minutes = Int(cooldownTimeRemaining) / 60
        let seconds = Int(cooldownTimeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var canSwipe: Bool {
        return !isInCooldown && cardsThisSession < maxCardsPerSession
    }
    
    func preloadCards() async {
        guard canSwipe else { return }
        
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
        guard canSwipe else { return }
        guard !swipeQueue.isEmpty else { return }
        
        let card = swipeQueue.removeFirst()
        swipeHistory.append((card, direction))
        
        // Increment swipe count
        cardsThisSession += 1
        savePersistentData()
        
        // Check if we've reached the limit
        if cardsThisSession >= maxCardsPerSession {
            startCooldown()
        }
        
        switch direction {
        case .like:
            print("Liked: \(card.titleEnglish)")
            let saved = LikedManga(from: card)
            
            if let context = modelContext {
                context.insert(saved)
                do {
                    try context.save()
                    print("Successfully saved: \(card.titleEnglish)")
                    
                    // Force context to process changes and notify observers
                    try context.save()
                    
                    // Trigger UI update by sending objectWillChange
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
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
        
        // Decrease swipe count since we're undoing
        if cardsThisSession > 0 {
            cardsThisSession -= 1
        }
        
        // If we were in cooldown due to swipe limit, check if we should exit cooldown
        if isInCooldown && cardsThisSession < maxCardsPerSession {
            // Only exit cooldown if it was due to swipe limit, not time-based
            if let cooldownStart = cooldownStartTime {
                let timeElapsed = Date().timeIntervalSince(cooldownStart)
                if timeElapsed < 60 { // If cooldown just started (less than 1 minute ago)
                    endCooldown()
                }
            }
        }
        
        savePersistentData()
    }
    
    deinit {
        cooldownTimer?.invalidate()
    }
}
