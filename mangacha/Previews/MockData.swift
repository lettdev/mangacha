//
//  MockData.swift
//  mangacha
//
//  Created by Tung Le on 11/07/25.
//

import Foundation

struct MockData {
    static let mangaOptions: [MangaAPIResponse] = [
        MangaAPIResponse(
            malId: 24680,
            title: "Berserk",
            titleEnglish: "Berserk",
            titleJapanese: "ベルセルク",
            images: ImageWrapper(jpg: ImageSet(largeImageUrl: "https://cdn.myanimelist.net/images/manga/1/157897.jpg")),
            synopsis: "A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts.",
            rank: 10,
            popularity: 15,
            genres: [Genre(name: "Action"), Genre(name: "Horror"), Genre(name: "Fantasy")],
            explicitGenres: [Genre(name: "Gore")],
            themes: [],
            demographics: [],
            status: "Hiatus"
        ),
        MangaAPIResponse(
            malId: 1,
            title: "One Piece",
            titleEnglish: "One Piece",
            titleJapanese: "ワンピース",
            images: ImageWrapper(jpg: ImageSet(largeImageUrl: "https://cdn.myanimelist.net/images/manga/2/253146.jpg")),
            synopsis: "The story follows the adventures of Monkey D. Luffy...",
            rank: 1,
            popularity: 1,
            genres: [Genre(name: "Action"), Genre(name: "Adventure"), Genre(name: "Comedy")],
            explicitGenres: [],
            themes: [],
            demographics: [],
            status: "Ongoing"
        ),
        MangaAPIResponse(
            malId: 2,
            title: "Attack on Titan",
            titleEnglish: "Attack on Titan",
            titleJapanese: "進撃の巨人",
            images: ImageWrapper(jpg: ImageSet(largeImageUrl: "https://cdn.myanimelist.net/images/manga/2/37846.jpg")),
            synopsis: "Centuries ago, mankind was slaughtered to near extinction by monstrous humanoid creatures called titans...",
            rank: 25,
            popularity: 30,
            genres: [Genre(name: "Action"), Genre(name: "Drama"), Genre(name: "Fantasy")],
            explicitGenres: [Genre(name: "Gore")],
            themes: [],
            demographics: [],
            status: "Finished"
        ),
        MangaAPIResponse(
            malId: 3,
            title: "Death Note",
            titleEnglish: "Death Note",
            titleJapanese: "デスノート",
            images: ImageWrapper(jpg: ImageSet(largeImageUrl: "https://cdn.myanimelist.net/images/anime/1079/138100.jpg")),
            synopsis: "A high school student discovers a supernatural notebook that allows him to kill anyone by writing the victim's name...",
            rank: 15,
            popularity: 20,
            genres: [Genre(name: "Mystery"), Genre(name: "Psychological"), Genre(name: "Supernatural")],
            explicitGenres: [],
            themes: [],
            demographics: [],
            status: "Finished"
        ),
        MangaAPIResponse(
            malId: 4,
            title: "Demon Slayer",
            titleEnglish: "Demon Slayer: Kimetsu no Yaiba",
            titleJapanese: "鬼滅の刃",
            images: ImageWrapper(jpg: ImageSet(largeImageUrl: "https://cdn.myanimelist.net/images/anime/1565/142711.jpg")),
            synopsis: "A family is attacked by demons and only two members survive...",
            rank: 5,
            popularity: 5,
            genres: [Genre(name: "Action"), Genre(name: "Fantasy"), Genre(name: "Historical")],
            explicitGenres: [Genre(name: "Gore")],
            themes: [],
            demographics: [],
            status: "Finished"
        )
    ]
    
    static func randomMangaAPIResponse() -> MangaAPIResponse {
        return mangaOptions.randomElement()!
    }
    
    static func randomMangachaCard() -> MangachaCard {
        let response = randomMangaAPIResponse()
        return CardGenerator.generateCard(from: response) ?? sampleMangachaCard
    }
    
    static func randomLikedManga() -> LikedManga {
        let card = randomMangachaCard()
        return LikedManga(
            from: MangachaCard(
                id: card.id,
                titleEnglish: card.titleEnglish,
                titleJapanese: card.titleJapanese,
                imageUrl: card.imageUrl,
                synopsis: card.synopsis,
                genres: card.genres,
                explicitGenres: card.explicitGenres,
                themes: card.themes,
                demographics: card.demographics,
                rank: card.rank,
                popularity: card.popularity,
                status: card.status,
                stars: card.stars,
                rarity: card.rarity,
                quality: card.quality
            )
        )
    }
    
    static func generateMultipleCards(count: Int) -> [MangachaCard] {
        return (0..<count).map { _ in randomMangachaCard() }
    }
    
    static func generateMultipleLikedManga(count: Int) -> [LikedManga] {
        return (0..<count).map { _ in randomLikedManga() }
    }
    
    static let sampleMangachaCard = MangachaCard(
        id: 24680,
        titleEnglish: "Berserk",
        titleJapanese: "ベルセルク",
        imageUrl: "https://cdn.myanimelist.net/images/manga/1/157897.jpg",
        synopsis: "A dark fantasy saga of revenge, demonic forces, and the cursed warrior Guts.",
        genres: ["Action", "Horror", "Fantasy"],
        explicitGenres: ["Gore"],
        themes: [],
        demographics: [],
        rank: 10,
        popularity: 15,
        status: "Hiatus",
        stars: 8,
        rarity: .legendary,
        quality: .noir
    )
}
