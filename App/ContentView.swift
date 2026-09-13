import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    hero
                    widgetCatalog
                    setupGuide
                    compatibilityNote
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("StandBy Studio")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: "rectangle.split.2x1.fill")
                .font(.system(size: 38, weight: .semibold))
                .symbolRenderingMode(.hierarchical)

            Text("Make StandBy yours")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))

            Text("Three focused widgets designed to stay readable across the room, adapt to Night Mode, and feel at home on iOS.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.indigo, .purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .accessibilityElement(children: .combine)
    }

    private var widgetCatalog: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Included widgets")
                .font(.title2.bold())

            ForEach(StandByWidgetDescriptor.catalog) { widget in
                HStack(spacing: 16) {
                    Image(systemName: widget.symbol)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 52, height: 52)
                        .background {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: widget.colors,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(widget.name)
                            .font(.headline)
                        Text(widget.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 0)
                }
                .padding(16)
                .background(.background, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
        }
    }

    private var setupGuide: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Add one to StandBy", systemImage: "plus.square.on.square")
                .font(.title2.bold())

            instruction(1, "Connect your iPhone to power and turn it sideways.")
            instruction(2, "Press and hold a StandBy widget, then tap the plus button.")
            instruction(3, "Search for StandBy Studio and choose a widget.")
            instruction(4, "Press and hold the widget again to customize it.")
        }
        .padding(20)
        .background(.background, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var compatibilityNote: some View {
        Label {
            Text("Built for iOS 17 and later, including iOS 26.6.1. StandBy is available while a supported iPhone is charging in landscape orientation.")
        } icon: {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.green)
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .padding(.bottom, 12)
    }

    private func instruction(_ number: Int, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(.indigo, in: Circle())

            Text(text)
                .font(.subheadline)
                .padding(.top, 2)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ContentView()
}
