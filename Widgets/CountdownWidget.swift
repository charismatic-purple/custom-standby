import AppIntents
import SwiftUI
import WidgetKit

struct CountdownIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Countdown"
    static var description = IntentDescription("Count down to a date that matters.")

    @Parameter(title: "Event name")
    var eventName: String

    @Parameter(title: "Target date")
    var targetDate: Date

    @Parameter(title: "Theme")
    var theme: WidgetTheme

    init() {
        eventName = "Big day"
        targetDate = Calendar.current.date(byAdding: .day, value: 30, to: .now) ?? .now
        theme = .sunset
    }
}

struct CountdownEntry: TimelineEntry {
    let date: Date
    let configuration: CountdownIntent

    var daysRemaining: Int {
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: date)
        let end = calendar.startOfDay(for: configuration.targetDate)
        return max(0, calendar.dateComponents([.day], from: start, to: end).day ?? 0)
    }

    var isComplete: Bool {
        date >= configuration.targetDate
    }
}

struct CountdownProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: .now, configuration: CountdownIntent())
    }

    func snapshot(for configuration: CountdownIntent, in context: Context) async -> CountdownEntry {
        CountdownEntry(date: .now, configuration: configuration)
    }

    func timeline(for configuration: CountdownIntent, in context: Context) async -> Timeline<CountdownEntry> {
        let now = Date.now
        let entry = CountdownEntry(date: now, configuration: configuration)
        let tomorrow = Calendar.autoupdatingCurrent.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        ) ?? now.addingTimeInterval(3_600)
        return Timeline(entries: [entry], policy: .after(tomorrow))
    }
}

struct CountdownWidgetView: View {
    let entry: CountdownEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(entry.configuration.eventName, systemImage: entry.isComplete ? "checkmark.circle.fill" : "hourglass")
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .widgetAccentable()

            Spacer(minLength: 2)

            if entry.isComplete {
                Text("Today")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.7)
            } else {
                Text("\(entry.daysRemaining)")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .contentTransition(.numericText())
                Text(entry.daysRemaining == 1 ? "day to go" : "days to go")
                    .font(.caption)
                    .opacity(0.82)
            }
        }
        .foregroundStyle(.white)
        .containerBackground(for: .widget) {
            ThemeBackground(theme: entry.configuration.theme)
        }
    }
}

struct CountdownWidget: Widget {
    let kind = "CountdownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: CountdownIntent.self, provider: CountdownProvider()) { entry in
            CountdownWidgetView(entry: entry)
        }
        .configurationDisplayName("Countdown")
        .description("See the days remaining until an important date.")
        .supportedFamilies([.systemSmall])
    }
}
