//
//  CardsOutOfStock.swift
//  mangacha
//
//  Created by Tung Le on 20/06/25.
//

import SwiftUI

struct CardsOutOfStock: View {
    let reloadAction: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "square.slash")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            Text("You're out of cards!")
            Button("Reload") {
                reloadAction()
            }
            .padding(.top)
        }
    }
}

#Preview {
    CardsOutOfStock(reloadAction: {})
}
