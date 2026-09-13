import MediaPlayer
import SwiftUI
import WidgetKit

enum NowPlayingState: Equatable {
    case needsAuthorization
    case idle
    case paused
    case playing
}

struct NowPlayingEntry: TimelineEntry {
    let date: Date
    let state: NowPlayingState
    let title: String
    let artist: String
    let album: String?
    let artwork: UIImage?
    let playbackProgress: Double
}

@MainActor
enum NowPlayingReader {
    static func currentEntry(at date: Date = .now) -> NowPlayingEntry {
        guard MPMediaLibrary.authorizationStatus() == .authorized else {
            return NowPlayingEntry(
                date: date,
                state: .needsAuthorization,
                title: "Open StandBy Studio",
                artist: "Allow Apple Music access",
                album: nil,
                artwork: nil,
                playbackProgress: 0
            )
        }

        let player = MPMusicPlayerController.systemMusicPlayer
        guard let item = player.nowPlayingItem else {
            return NowPlayingEntry(
                date: date,
                state: .idle,
                title: "Nothing Playing",
                artist: "Start a song in Music",
                album: nil,
                artwork: nil,
                playbackProgress: 0
            )
        }

        let duration = item.playbackDuration
        let progress = duration > 0 ? min(max(player.currentPlaybackTime / duration, 0), 1) : 0
        let state: NowPlayingState = player.playbackState == .playing ? .playing : .paused

        return NowPlayingEntry(
            date: date,
            state: state,
            title: item.title ?? "Unknown Title",
            artist: item.artist ?? "Unknown Artist",
            album: item.albumTitle,
            artwork: item.artwork?.image(at: CGSize(width: 512, height: 512)),
            playbackProgress: progress
        )
    }
}

struct NowPlayingProvider: TimelineProvider {
    func placeholder(in context: Context) -> NowPlayingEntry {
        NowPlayingEntry(
            date: .now,
            state: .playing,
            title: "Now Playing",
            artist: "Your favorite artist",
            album: "StandBy Mix",
            artwork: nil,
            playbackProgress: 0.42
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (NowPlayingEntry) -> Void) {
        guard !context.isPreview else {
            completion(placeholder(in: context))
            return
        }

        Task { @MainActor in
            completion(NowPlayingReader.currentEntry())
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NowPlayingEntry>) -> Void) {
        Task { @MainActor in
            let entry = NowPlayingReader.currentEntry()
            let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: entry.date)
                ?? entry.date.addingTimeInterval(300)
            completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
        }
    }
}

struct NowPlayingWidgetView: View {
    @Environment(\.widgetRenderingMode) private var renderingMode
    let entry: NowPlayingEntry

    var body: some View {
        ZStack {
            if renderingMode == .fullColor, let artwork = entry.artwork {
                Image(uiImage: artwork)
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        LinearGradient(
                            colors: [.black.opacity(0.05), .black.opacity(0.86)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    Image(systemName: stateSymbol)
                    Text(stateLabel)
                }
                .font(.caption2.weight(.semibold))
                .textCase(.uppercase)
                .widgetAccentable()

                Spacer(minLength: 0)

                Text(entry.title)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                Text(entry.artist)
                    .font(.caption)
                    .lineLimit(1)
                    .opacity(0.82)

                if entry.state == .playing || entry.state == .paused {
                    ProgressView(value: entry.playbackProgress)
                        .tint(.white)
                }
            }
            .padding(2)
        }
        .foregroundStyle(.white)
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [.pink, .purple, .indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var stateSymbol: String {
        switch entry.state {
        case .playing:
            return "waveform"
        case .paused:
            return "pause.fill"
        case .needsAuthorization:
            return "lock.fill"
        case .idle:
            return "music.note"
        }
    }

    private var stateLabel: String {
        switch entry.state {
        case .playing:
            return "Playing"
        case .paused:
            return "Paused"
        case .needsAuthorization:
            return "Access needed"
        case .idle:
            return "Apple Music"
        }
    }
}

struct NowPlayingWidget: Widget {
    let kind = "NowPlayingWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NowPlayingProvider()) { entry in
            NowPlayingWidgetView(entry: entry)
        }
        .configurationDisplayName("Now Playing")
        .description("Show the current track from the Music app in StandBy.")
        .supportedFamilies([.systemSmall])
    }
}
