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
                .foregroundColor(.orange)
            
            VStack(spacing: 8) {
                Text("Swipe Limit Reached!")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text("You've used all 16 swipes for this session")
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
                    .foregroundColor(.orange)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Progress bar
            VStack(spacing: 8) {
                ProgressView(value: 1.0 - (discoverModel.cooldownTimeRemaining / (5 * 60)))
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(height: 8)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .clipShape(Capsule())
                
                Text("Session resets automatically")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
