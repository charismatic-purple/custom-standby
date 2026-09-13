# Architecture

StandBy Studio intentionally has no backend, analytics, account, or shared app-group storage. Message and Countdown are configured with `WidgetConfigurationIntent`, so WidgetKit owns each widget instance's settings. This keeps signing and privacy requirements small while still allowing multiple differently configured copies of a widget.

## Targets

- `StandByStudio` is the companion app. It presents the catalog and setup instructions.
- `StandByWidgets` contains three `systemSmall` widgets.
- `StandByStudioTests` validates catalog metadata.

## Timeline strategy

- Message refreshes every six hours; its content is configuration-driven and normally static.
- Countdown refreshes after local midnight so the remaining-day value changes on time.
- Clock publishes one entry per minute for the next hour, then WidgetKit requests a new timeline.

WidgetKit decides when to request and render timelines. Code must not assume exact background execution times.

## StandBy rendering

Each widget declares a removable background with `containerBackground(for: .widget)`. In normal Home Screen use, the selected gradient is visible. In StandBy, iOS can remove that background; in low light, iOS applies its monochromatic red treatment. Essential meaning is therefore carried by text and SF Symbols rather than color.
