# StandBy Studio

StandBy Studio is a small SwiftUI app with three WidgetKit widgets designed for iPhone StandBy:

- **Message** — a configurable headline, note, SF Symbol, and color theme.
- **Countdown** — a configurable event, date, and color theme.
- **Clock & Date** — a large, distance-friendly time and date display.

The app targets iOS 17 and later, including iOS 26.6.1. StandBy uses the `systemSmall` widget family, displays two widgets side by side, and removes widget backgrounds. Each widget is designed around those constraints and supports the system's low-light rendering.

## Requirements

- macOS with Xcode 16 or later; use Xcode 26.5 or later to deploy directly to an iPhone running iOS 26.6.1
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)
- An Apple developer account for installation on a physical iPhone

## Run it

```sh
brew install xcodegen
xcodegen generate
open StandByStudio.xcodeproj
```

In Xcode, select the `StandByStudio` target, choose your development team, and run on an iPhone or simulator. If Xcode asks, use a unique bundle identifier for both the app and widget extension.

## Add a widget to StandBy

1. Install and launch StandBy Studio once.
2. Connect the iPhone to power, place it on its side, and wake it.
3. Press and hold either StandBy widget stack and tap the plus button.
4. Search for **StandBy Studio** and add one of its widgets.
5. Press and hold Message or Countdown and choose **Edit Widget** to customize it.

## Important platform limits

Apple doesn't provide a third-party API to replace StandBy, create a full-screen custom StandBy clock face, force StandBy to launch, or programmatically place a widget. Apps provide standard WidgetKit widgets; the user chooses where to place them. Widget refresh timing is also managed by iOS.

## Project layout

```text
App/       SwiftUI companion app and setup guide
Widgets/   WidgetKit extension, intents, timelines, and views
Tests/     App unit tests
project.yml  XcodeGen project definition
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for implementation notes.

## Before App Store submission

- Replace the placeholder AppIcon asset with final 1024×1024 artwork.
- Change the `com.charismaticpurple` bundle identifiers to identifiers owned by your team.
- Add screenshots, privacy details, support URL, and App Store metadata.
- Test full-color, StandBy, Night Mode, accessibility text, and both 12/24-hour time settings on real hardware.

## License

MIT
