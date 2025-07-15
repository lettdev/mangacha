//
//  MangachaCard.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import Foundation

struct MangachaCard: Identifiable, Codable {
    let id: Int
    let titleEnglish: String
    let titleJapanese: String?
    let imageUrl: String
    let synopsis: String
    
    let genres: [String]
    let explicitGenres: [String]
    let themes: [String]
    let demographics: [String]
    
    let rank: Int?
    let popularity: Int?
    let status: String?
    
    let stars: Int
    let rarity: Rarity
    let quality: Quality
}

enum Rarity: String, CaseIterable, Codable {
    case common, uncommon, rare, epic, legendary
}

enum Quality: String, CaseIterable, Codable {
    case normal, noir, prismatic, golden, glitch
}
