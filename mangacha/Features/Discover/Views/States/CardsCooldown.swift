//
//  CardsCooldown.swift
//  mangacha
//
//  Created by Tung Le on 22/06/25.
//

import SwiftUI

struct CardsCooldown: View {
    @ObservedObject var discoverModel: DiscoverViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Cooldown icon
            Image(systemName: "clock.fill")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("Swipe Limit Reached!")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text("You've discovered all cards for this session")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Countdown timer
            VStack(spacing: 4) {
                Text("Come back in")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(discoverModel.cooldownTimeString)
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
