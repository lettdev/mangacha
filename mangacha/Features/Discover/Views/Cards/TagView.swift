//
//  TagView.swift
//  mangacha
//
//  Created by Tung Le on 18/06/25.
//

import SwiftUI

struct TagView: View {
    let text: String
    var backgroundColor: Color = Color.gray.opacity(0.8)
    var textColor: Color = .primary
    var font: Font = .caption2

    var body: some View {
        if #available(iOS 26.0, *) {
            Text(text)
                .font(font)
                .foregroundColor(textColor)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(backgroundColor)
                .clipShape(Capsule())
                .glassEffect()
        } else {
            Text(text)
                .font(font)
                .foregroundColor(textColor)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
    }
}
