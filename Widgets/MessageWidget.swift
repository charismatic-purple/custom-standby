import AppIntents
import SwiftUI
import WidgetKit

struct MessageIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Message"
    static var description = IntentDescription("Choose the words shown in your widget.")

    @Parameter(title: "Headline")
    var headline: String

    @Parameter(title: "Message")
    var message: String

    @Parameter(title: "Symbol name")
    var symbol: String

    @Parameter(title: "Theme")
    var theme: WidgetTheme

    init() {
        headline = "Stay curious"
        message = "Make a little progress every day."
        symbol = "sparkles"
        theme = .ocean
    }
}

struct MessageEntry: TimelineEntry {
    let date: Date
    let configuration: MessageIntent
}

struct MessageProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MessageEntry {
        MessageEntry(date: .now, configuration: MessageIntent())
    }

    func snapshot(for configuration: MessageIntent, in context: Context) async -> MessageEntry {
        MessageEntry(date: .now, configuration: configuration)
    }

    func timeline(for configuration: MessageIntent, in context: Context) async -> Timeline<MessageEntry> {
        let entry = MessageEntry(date: .now, configuration: configuration)
        let nextRefresh = Calendar.current.date(byAdding: .hour, value: 6, to: .now) ?? .now.addingTimeInterval(21_600)
        return Timeline(entries: [entry], policy: .after(nextRefresh))
    }
}

struct MessageWidgetView: View {
    let entry: MessageEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: entry.configuration.symbol.isEmpty ? "sparkles" : entry.configuration.symbol)
                    .font(.title2.weight(.semibold))
                    .widgetAccentable()
                Spacer()
            }

            Spacer(minLength: 0)

            Text(entry.configuration.headline)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .lineLimit(2)
                .minimumScaleFactor(0.72)

            Text(entry.configuration.message)
                .font(.caption)
                .lineLimit(2)
                .opacity(0.82)
        }
        .foregroundStyle(.white)
        .containerBackground(for: .widget) {
            ThemeBackground(theme: entry.configuration.theme)
        }
    }
}

struct MessageWidget: Widget {
    let kind = "MessageWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: MessageIntent.self, provider: MessageProvider()) { entry in
            MessageWidgetView(entry: entry)
        }
        .configurationDisplayName("Message")
        .description("Keep a personal note or mantra visible in StandBy.")
        .supportedFamilies([.systemSmall])
    }
}
