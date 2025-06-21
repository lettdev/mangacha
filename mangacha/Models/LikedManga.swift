//
//  LikedManga.swift
//  mangacha
//
//  Created by Tung Le on 21/06/25.
//

import Foundation
import SwiftData

@Model
class LikedManga: Identifiable {
    @Attribute(.unique) var id: Int
    var titleEnglish: String
    var titleJapanese: String?
    var imageUrl: String
    var synopsis: String
    var likedDate: Date

    var stars: Int
    var rarity: String
    var quality: String
    var rank: Int?
    var popularity: Int?

    init(from card: MangachaCard) {
        self.id = card.id
        self.titleEnglish = card.titleEnglish
        self.titleJapanese = card.titleJapanese
        self.imageUrl = card.imageUrl
        self.synopsis = card.synopsis
        self.stars = card.stars
        self.rarity = card.rarity.rawValue
        self.quality = card.quality.rawValue
        self.rank = card.rank
        self.popularity = card.popularity
        self.likedDate = Date()
    }
    
    // Computed property to get Rarity enum from string
    var rarityEnum: Rarity {
        return Rarity(rawValue: rarity) ?? .common
    }
    
    // Computed property to get Quality enum from string
    var qualityEnum: Quality {
        return Quality(rawValue: quality) ?? .normal
    }
}
