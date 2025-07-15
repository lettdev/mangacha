//
//  SettingsManager.swift
//  mangacha
//
//  Created by Tung Le on 23/06/25.
//

import SwiftUI
import Foundation

enum ThemeMode: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var themeMode: ThemeMode {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: "themeMode")
        }
    }
    
    @Published var isSFWEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSFWEnabled, forKey: "isSFWEnabled")
        }
    }
    
    private init() {
        // Load theme mode
        let themeModeString = UserDefaults.standard.string(forKey: "themeMode") ?? ThemeMode.system.rawValue
        self.themeMode = ThemeMode(rawValue: themeModeString) ?? .system
        
        // Load SFW setting (default to true for safe content)
        self.isSFWEnabled = UserDefaults.standard.object(forKey: "isSFWEnabled") as? Bool ?? true
    }
}
