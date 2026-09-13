import SwiftUI
import WidgetKit

struct ClockEntry: TimelineEntry {
    let date: Date
}

struct ClockProvider: TimelineProvider {
    func placeholder(in context: Context) -> ClockEntry {
        ClockEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (ClockEntry) -> Void) {
        completion(ClockEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ClockEntry>) -> Void) {
        let start = Calendar.autoupdatingCurrent.dateInterval(of: .minute, for: .now)?.start ?? .now
        let entries = (0..<60).compactMap { offset -> ClockEntry? in
            guard let date = Calendar.autoupdatingCurrent.date(byAdding: .minute, value: offset, to: start) else {
                return nil
            }
            return ClockEntry(date: date)
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct ClockWidgetView: View {
    let entry: ClockEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.date, format: .dateTime.weekday(.wide))
                .font(.caption.weight(.semibold))
                .textCase(.uppercase)
                .widgetAccentable()

            Spacer(minLength: 0)

            Text(entry.date, format: .dateTime.hour().minute())
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.68)
                .lineLimit(1)

            Text(entry.date, format: .dateTime.month(.wide).day())
                .font(.subheadline.weight(.medium))
                .opacity(0.82)
        }
        .foregroundStyle(.white)
        .containerBackground(for: .widget) {
            ThemeBackground(theme: .midnight)
        }
    }
}

struct ClockWidget: Widget {
    let kind = "ClockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            ClockWidgetView(entry: entry)
        }
        .configurationDisplayName("Clock & Date")
        .description("A clean clock designed to be read from across the room.")
        .supportedFamilies([.systemSmall])
    }
}
