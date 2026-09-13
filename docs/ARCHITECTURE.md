# Architecture

StandBy Studio intentionally has no backend, analytics, account, or shared app-group storage. Message and Countdown are configured with `WidgetConfigurationIntent`, so WidgetKit owns each widget instance's settings. This keeps signing and privacy requirements small while still allowing multiple differently configured copies of a widget.

Now Playing uses the local `MPMusicPlayerController.systemMusicPlayer` after the user grants Music Library permission in the containing app. The widget reads a snapshot directly when WidgetKit requests its timeline. No listening information is transmitted or persisted.

## Targets

- `StandByStudio` is the companion app. It presents the catalog and setup instructions.
- `StandByWidgets` contains four `systemSmall` widgets.
- `StandByStudioTests` validates catalog metadata.

## Timeline strategy

- Message refreshes every six hours; its content is configuration-driven and normally static.
- Countdown refreshes after local midnight so the remaining-day value changes on time.
- Clock publishes one entry per minute for the next hour, then WidgetKit requests a new timeline.
- Now Playing requests another snapshot after five minutes. Opening the app also requests a timeline reload.

WidgetKit decides when to request and render timelines. Code must not assume exact background execution times.

## Music playback boundaries

The system music player reflects the Music app's playback state on the iPhone. If that iPhone is streaming to a HomePod over AirPlay, the same session may remain visible. A playback session started independently by a HomePod is not available through a public, live Apple account API. Recently played Apple Music history is intentionally not used as a current-playback fallback because it doesn't report whether or where playback is active.

## StandBy rendering

Each widget declares a removable background with `containerBackground(for: .widget)`. In normal Home Screen use, the selected gradient is visible. In StandBy, iOS can remove that background; in low light, iOS applies its monochromatic red treatment. Essential meaning is therefore carried by text and SF Symbols rather than color.
