import SwiftUI

struct League: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let country: String
    let flagEmoji: String
    let primaryColorHex: String
    let clubs: [Club]
    
    var primaryColor: Color {
        Color(hex: primaryColorHex)
    }
}

struct Club: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let shortName: String
    let leagueID: String
    let primaryColorHex: String
    let secondaryColorHex: String
    let stadium: String
    let founded: Int
    let city: String
    let players: [Player]
    
    var primaryColor: Color {
        Color(hex: primaryColorHex)
    }
    
    var secondaryColor: Color {
        Color(hex: secondaryColorHex)
    }
}

struct Player: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let position: PlayerPosition
    let nationality: String
    let clubID: String
    let shirtNumber: Int
}

enum PlayerPosition: String, Codable, CaseIterable, Identifiable {
    case goalkeeper = "GK"
    case defender = "DEF"
    case midfielder = "MID"
    case forward = "FWD"
    
    var id: String { rawValue }
    
    var fullName: String {
        switch self {
        case .goalkeeper: "Goalkeeper"
        case .defender: "Defender"
        case .midfielder: "Midfielder"
        case .forward: "Forward"
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
