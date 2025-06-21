//
//  CardGenerator.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

struct CardGenerator {
    
    static func generateStars(from rank: Int?) -> Int {
        guard let rank = rank else { return 1 }
        switch rank {
        case 1...50: return 10
        case 51...100: return 9
        case 101...250: return 8
        case 251...500: return 7
        case 501...1000: return 6
        case 1001...2000: return 5
        case 2001...4000: return 4
        case 4001...8000: return 3
        case 8001...16000: return 2
        default: return 1
        }
    }
    
    static func generateRarity(from popularity: Int?) -> Rarity {
        guard let popularity = popularity else { return .common }
        switch popularity {
        case 1...50: return .legendary
        case 51...200: return .epic
        case 201...1000: return .rare
        case 1001...3000: return .uncommon
        default: return .common
        }
    }
    
    static func generateRandomQuality(weights: [Quality: Int] = [
        .normal: 60,
        .noir: 15,
        .prismatic: 12,
        .golden: 8,
        .glitch: 5
    ]) -> Quality {
        let total = weights.values.reduce(0, +)
        let random = Int.random(in: 0..<total)
        
        var cumulative = 0
        for (quality, weight) in weights {
            cumulative += weight
            if random < cumulative {
                return quality
            }
        }
        
        return .normal
    }
    
    static func generateCard(from api: MangaAPIResponse) -> MangachaCard? {
        guard let imageUrl = api.images?.jpg?.largeImageUrl,
              let title = api.title else {
            return nil
        }

        let genres = api.genres.map { $0.name }
        let explicitGenres = api.explicitGenres.map { $0.name }
        let themes = api.themes.map { $0.name }
        let demographics = api.demographics.map { $0.name }

        return MangachaCard(
            id: api.malId,
            titleEnglish: api.titleEnglish ?? title,
            titleJapanese: api.titleJapanese,
            imageUrl: imageUrl,
            synopsis: api.synopsis ?? "No synopsis available.",
            genres: genres,
            explicitGenres: explicitGenres,
            themes: themes,
            demographics: demographics,
            stars: generateStars(from: api.rank),
            rarity: generateRarity(from: api.popularity),
            quality: generateRandomQuality(),
            rank: api.rank,
            popularity: api.popularity,
            status: api.status
        )
    }
}
