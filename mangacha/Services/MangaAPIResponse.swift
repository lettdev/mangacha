//
//  MangaAPIResponse.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import Foundation

struct MangaAPIResponse: Codable {
    let malId: Int
    let title: String?
    let titleEnglish: String?
    let titleJapanese: String?
    let images: ImageWrapper?
    let synopsis: String?
    let rank: Int?
    let popularity: Int?
    let genres: [Genre]
    let explicitGenres: [Genre]
    let themes: [Genre]
    let demographics: [Genre]
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case title, titleEnglish = "title_english", titleJapanese = "title_japanese"
        case images, synopsis, rank, popularity, genres, explicitGenres = "explicit_genres", themes, demographics, status
    }
}

struct ImageWrapper: Codable {
    let jpg: ImageSet?
}

struct ImageSet: Codable {
    let largeImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case largeImageUrl = "large_image_url"
    }
}

struct Genre: Codable {
    let name: String
}
