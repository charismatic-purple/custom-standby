import SwiftUI
import WidgetKit

@main
struct StandByWidgetBundle: WidgetBundle {
    var body: some Widget {
        NowPlayingWidget()
        MessageWidget()
        CountdownWidget()
        ClockWidget()
    }
}
