//
//  CollectionView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query(sort: [SortDescriptor(\LikedManga.likedDate, order: .reverse)])
    var likedManga: [LikedManga]
    
    @State private var searchText = ""
    @State private var selectedRarity: Rarity?
    
    var filteredManga: [LikedManga] {
        var filtered = likedManga
        
        if !searchText.isEmpty {
            filtered = filtered.filter { manga in
                manga.titleEnglish.localizedCaseInsensitiveContains(searchText) ||
                manga.titleJapanese?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        if let rarity = selectedRarity {
            filtered = filtered.filter { $0.rarityEnum == rarity }
        }
        
        return filtered
    }

    var body: some View {
        NavigationStack {
            Group {
                if likedManga.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No liked manga yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Start discovering manga to build your collection!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(spacing: 0) {
                        // Filter section
                        VStack {
                            HStack {
                                Text("Total: \(likedManga.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                if filteredManga.count != likedManga.count {
                                    Text("Showing: \(filteredManga.count)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Rarity filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    Button("All") {
                                        selectedRarity = nil
                                    }
                                    .buttonStyle(FilterButtonStyle(isSelected: selectedRarity == nil))
                                    
                                    ForEach(Rarity.allCases, id: \.self) { rarity in
                                        Button(rarity.rawValue.capitalized) {
                                            selectedRarity = selectedRarity == rarity ? nil : rarity
                                        }
                                        .buttonStyle(FilterButtonStyle(isSelected: selectedRarity == rarity))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 8)
                        .background(Color(.systemGroupedBackground))
                        
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 160), spacing: 12)
                            ], spacing: 16) {
                                ForEach(filteredManga) { item in
                                    CollectionCardView(item: item)
                                }
                            }
                            .padding()
                        }
                        .background(Color(.systemGroupedBackground))
                    }
                    .searchable(text: $searchText, prompt: "Search manga...")
                }
            }
            .navigationTitle("Collection")
        }
    }
}

struct FilterButtonStyle: ButtonStyle {
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.accentColor : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    CollectionView()
        .modelContainer(for: [LikedManga.self])
}
