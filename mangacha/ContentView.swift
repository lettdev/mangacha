//
//  ContentView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        TabView() {
            Tab("Discover", systemImage: "book") {
                DiscoverView()
            }
            Tab("Collection", systemImage: "square.grid.2x2") {
                CollectionView()
            }
            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView()
            }
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    ContentView()
}
