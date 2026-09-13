import SwiftUI

struct StandByWidgetDescriptor: Identifiable, Equatable {
    let id: String
    let name: String
    let summary: String
    let symbol: String
    let colors: [Color]

    static let catalog: [StandByWidgetDescriptor] = [
        .init(
            id: "now-playing",
            name: "Now Playing",
            summary: "Artwork and track details from the Music app.",
            symbol: "music.note",
            colors: [.pink, .purple]
        ),
        .init(
            id: "message",
            name: "Message",
            summary: "A personal headline, note, or mantra.",
            symbol: "text.quote",
            colors: [.indigo, .cyan]
        ),
        .init(
            id: "countdown",
            name: "Countdown",
            summary: "Keep an important date in sight.",
            symbol: "hourglass",
            colors: [.orange, .pink]
        ),
        .init(
            id: "clock",
            name: "Clock & Date",
            summary: "A quiet, distance-friendly time display.",
            symbol: "clock.fill",
            colors: [.purple, .blue]
        )
    ]
}
