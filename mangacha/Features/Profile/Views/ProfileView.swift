//
//  ProfileView.swift
//  mangacha
//
//  Created by Tung Le on 17/06/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var settings = SettingsManager.shared
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    HStack {
                        Image(systemName: "paintbrush.fill")
                            .foregroundColor(.blue)
                            .frame(width: 20)
                        
                        Picker("Theme", selection: $settings.themeMode) {
                            ForEach(ThemeMode.allCases, id: \.self) { mode in
                                Text(mode.displayName).tag(mode)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                Section("Content") {
                    HStack {
                        Image(systemName: settings.isSFWEnabled ? "shield.fill" : "shield.slash.fill")
                            .foregroundColor(settings.isSFWEnabled ? .green : .red)
                            .frame(width: 20)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Safe for Work")
                            Text("Filter explicit content")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $settings.isSFWEnabled)
                    }
                }
                
                Section("About") {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mangacha")
                            Text(" Discover manga like trading cards.\n An app by Krad.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
