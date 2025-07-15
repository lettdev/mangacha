//
//  JikanAPIService.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import Foundation

enum JikanAPIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknown
}

class JikanAPIService {
    static let shared = JikanAPIService()
    
    private var baseUrl: String {
        let isSFWEnabled = SettingsManager.shared.isSFWEnabled
        return isSFWEnabled ? "https://api.jikan.moe/v4/random/manga?sfw" : "https://api.jikan.moe/v4/random/manga"
    }
    
    func fetchRandomMangaCard() async throws -> MangachaCard {
        guard let url = URL(string: baseUrl) else {
            throw JikanAPIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200 else {
            throw JikanAPIError.invalidResponse
        }
        
        let decoded = try JSONDecoder().decode(RandomMangaRaw.self, from: data)
        
        guard let card = CardGenerator.generateCard(from: decoded.data) else {
            throw JikanAPIError.decodingError
        }
        
        return card
    }
}
