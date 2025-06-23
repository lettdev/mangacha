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
            Image(systemName: "xmark.circle")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            Text("\(error)")
            Button("Retry") {
                retryAction()
            }
            .padding(.top)
        }
    }
}

#Preview {
    CardsError(error: "Error", retryAction: {})
}
