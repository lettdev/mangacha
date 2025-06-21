//
//  ContentView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI
import SwiftData

enum Tabs {
    case discover, collection, profile
}

struct ContentView: View {
    @State var selectedTab: Tabs = .discover
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                DiscoverView()
                    .tabItem{
                        Label("Discover", systemImage: "book")
                    }
                    .tag(Tabs.discover)
                CollectionView()
                    .tabItem{
                        Label("Collection", systemImage: "square.grid.2x2")
                    }
                    .tag(Tabs.collection)
                ProfileView()
                    .tabItem{
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(Tabs.profile)
            }
            .navigationTitle(title(for: selectedTab))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func title(for tab: Tabs) -> String {
        switch tab {
        case .discover: return "Discover"
        case .collection: return "Collection"
        case .profile: return "Profile"
        }
    }
}

#Preview {
    ContentView()
}
