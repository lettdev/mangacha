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
            Text("You're out of cards!")
            Button("Reload") {
                reloadAction()
            }
            .padding(.top)
        }
    }
}
