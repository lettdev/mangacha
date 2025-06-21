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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [LikedManga.self])
    }
}
