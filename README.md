# G-UL Screensaver Maker

A macOS app that turns your own videos into an installable screensaver — no coding, no Terminal.

Add videos, drag them into the order you want, click **Create Screensaver**, and get a ready-to-use `.saver` file. Built with SwiftUI.

<!-- TODO: add a screenshot of the app window here -->
<!-- ![Screensaver Maker](docs/screenshot.png) -->

## Features

- **Add any Apple-native video** — `.mov`, `.mp4`, `.m4v`
- **Drag to reorder** — the list order is the play order
- **One-click Create** — choose a name and location; the app builds a complete, signed `.saver`
- **One-click Install** — copies the screensaver into `~/Library/Screen Savers/`
- Generated screensavers play your videos full-screen, muted, in your chosen order, looping forever — leak-free

## How to use

1. Click **Add Videos** and choose your video files
2. Drag rows up or down to set the play order (trash icon removes one)
3. Click **Create Screensaver** and choose a name and location
4. Click **Install to Screen Savers**
5. Open **System Settings → Wallpaper → Screen Saver…** and select your screensaver

## Download & first launch

Grab the latest build from [Releases](../../releases) (or build from source, below).

**First-launch note:** this app is not notarized with Apple (no paid developer
certificate), so macOS will block it on first open:

1. Double-click the app — macOS shows "Not Opened". Click **Done** (not Move to Trash!).
2. Open **System Settings → Privacy & Security**, scroll to the Security section.
3. Click **"Open Anyway"** next to the message about ScreenSaverMakerGUL, then confirm.

This is needed once. Alternatively, in Terminal:
`xattr -dr com.apple.quarantine /path/to/ScreenSaverMakerGUL.app`

## Building from source

Requirements: Xcode 16+ on macOS.

1. Clone this repo and open `ScreenSaverMakerGUL.xcodeproj`
2. Press ⌘B to build, ⌘R to run
3. To install the app: copy `Build/Products/Debug/ScreenSaverMakerGUL.app` to `/Applications`

The app embeds a pre-built copy of the screensaver engine (`ScreenSaverGUL.saver`). If you change the engine, rebuild it in the [ScreenSaverGUL](https://github.com/G-UL/ScreenSaverGUL) repo and re-sync the copy — see `CLAUDE.md` for the exact command.

## How it works

The app never compiles code at runtime. It ships a clean, pre-built screensaver **engine** as a template, and on Create it:

1. Copies the template to your chosen location
2. Renames it in the bundle's `Info.plist`
3. Injects your videos into `Contents/Resources/`, numbered to preserve your order (`001_…`, `002_…`)
4. Sets readable permissions, clears extended attributes, re-signs the bundle ad-hoc, and strips the quarantine flag

The engine lives in its own repo: [ScreenSaverGUL](https://github.com/G-UL/ScreenSaverGUL).

> **Note:** the app is intentionally **not sandboxed**. Generating a screensaver requires modifying and re-signing a bundle and clearing quarantine flags — operations the App Sandbox forbids by design. The app only touches files you explicitly choose.

## Roadmap

- Video thumbnails in the list (auto-generated frames)
- Optional photo-slideshow mode
- Developer ID signing / notarization for friction-free distribution

## Credits

Inspired by [Brooklyn](https://github.com/pedrommcarrasco/Brooklyn) by Pedro Carrasco.
Made by [SeungHwan (G-UL) Um](https://g-ul.me) — [GitHub](https://github.com/G-UL) · [LinkedIn](https://www.linkedin.com/in/g-ul/)

## License

[MIT](LICENSE)
