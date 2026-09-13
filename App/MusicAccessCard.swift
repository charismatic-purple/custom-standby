import MediaPlayer
import SwiftUI
import WidgetKit

@MainActor
final class MusicAccessModel: ObservableObject {
    @Published private(set) var authorizationStatus = MPMediaLibrary.authorizationStatus()
    @Published private(set) var songTitle: String?
    @Published private(set) var artistName: String?
    @Published private(set) var isPlaying = false

    var isAuthorized: Bool {
        authorizationStatus == .authorized
    }

    func requestAccess() {
        MPMediaLibrary.requestAuthorization { [weak self] status in
            Task { @MainActor in
                self?.authorizationStatus = status
                self?.refresh()
            }
        }
    }

    func refresh() {
        authorizationStatus = MPMediaLibrary.authorizationStatus()

        guard isAuthorized else {
            songTitle = nil
            artistName = nil
            isPlaying = false
            return
        }

        let player = MPMusicPlayerController.systemMusicPlayer
        songTitle = player.nowPlayingItem?.title
        artistName = player.nowPlayingItem?.artist
        isPlaying = player.playbackState == .playing
        WidgetCenter.shared.reloadTimelines(ofKind: "NowPlayingWidget")
    }
}

struct MusicAccessCard: View {
    @ObservedObject var model: MusicAccessModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Apple Music access", systemImage: "music.note")
                .font(.title2.bold())

            switch model.authorizationStatus {
            case .authorized:
                authorizedContent
            case .denied, .restricted:
                Text("Music Library access is disabled. Enable it in Settings to let the widget read the Music app's current track.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            case .notDetermined:
                Text("Allow access so Now Playing can show the current track from the Music app on this iPhone.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button("Allow Music Access", action: model.requestAccess)
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
            @unknown default:
                Text("Music access is unavailable.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.background, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    @ViewBuilder
    private var authorizedContent: some View {
        if let songTitle = model.songTitle {
            HStack(spacing: 12) {
                Image(systemName: model.isPlaying ? "play.circle.fill" : "pause.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.pink)

                VStack(alignment: .leading, spacing: 2) {
                    Text(songTitle)
                        .font(.headline)
                        .lineLimit(1)
                    Text(model.artistName ?? "Unknown Artist")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        } else {
            Label("Ready—play something in Music", systemImage: "checkmark.circle.fill")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
    }
}
