import AppIntents
import SwiftUI

enum WidgetTheme: String, AppEnum, CaseIterable {
    case ocean
    case sunset
    case forest
    case midnight

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Theme")

    static var caseDisplayRepresentations: [WidgetTheme: DisplayRepresentation] = [
        .ocean: "Ocean",
        .sunset: "Sunset",
        .forest: "Forest",
        .midnight: "Midnight"
    ]

    var colors: [Color] {
        switch self {
        case .ocean:
            return [.blue, .cyan]
        case .sunset:
            return [.orange, .pink]
        case .forest:
            return [.green, Color(red: 0.04, green: 0.32, blue: 0.24)]
        case .midnight:
            return [.indigo, .purple]
        }
    }
}

struct ThemeBackground: View {
    let theme: WidgetTheme

    var body: some View {
        LinearGradient(
            colors: theme.colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
