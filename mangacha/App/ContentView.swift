//
//  ContentView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI
import SwiftData

enum Tabs: Equatable, Hashable {
    case discover
    case collection
    case profile
    case search
}

struct ContentView: View {
    @State private var selection: Tabs = .discover
    @State private var searchText: String = ""
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Discover", systemImage: "book", value: .discover) {
                DiscoverView()
            }
            Tab("Collection", systemImage: "square.grid.2x2", value: .collection) {
                CollectionView()
            }
            Tab("Profile", systemImage: "person.crop.circle", value: .profile) {
                ProfileView()
            }
            Tab(value: .search, role: .search) {
                // ...
            }
        }
        .searchable(text: $searchText, placement: .toolbar, prompt: Text("Search..."))
    }
}

#Preview {
    ContentView()
}
