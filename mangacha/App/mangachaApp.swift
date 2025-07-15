//
//  mangachaApp.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI
import SwiftData

@main
struct mangachaApp: App {
    @StateObject private var settings = SettingsManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(settings.themeMode.colorScheme)
        }
        .modelContainer(for: [LikedManga.self])
    }
}
