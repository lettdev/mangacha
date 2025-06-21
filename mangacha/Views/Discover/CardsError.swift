//
//  CardsError.swift
//  mangacha
//
//  Created by Tung Le on 20/06/25.
//

import SwiftUI

struct CardsError: View {
    let error: String
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Text("⚠️ \(error)")
            Button("Retry") {
                retryAction()
            }
            .padding(.top)
        }
    }
}
