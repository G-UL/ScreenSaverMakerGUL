# CLAUDE.md — ScreenSaverMakerGUL (maker app)

SwiftUI macOS app that generates custom screensavers. Single main source file:
`ScreenSaverMakerGUL/ContentView.swift` (UI + generation logic + helpers).
Embedded engine template: `ScreenSaverMakerGUL/ScreenSaverGUL.saver` (pre-built, from the ScreenSaverGUL repo).

## Build & run

- ⌘B / ⌘R in Xcode. Install as a real app by copying
  `Build/Products/Debug/ScreenSaverMakerGUL.app` → `/Applications`.
- The app icon lives in `Assets.xcassets/AppIcon` (All-Sizes grid — every slot must be filled; the App Store slot alone is not enough for Finder/Dock display).

## The generation pipeline (`createScreensaver()`)

Order matters. On Create, the app:
1. Locates the embedded engine template via `Bundle.main`
2. `NSSavePanel` → user picks name + location (default suggested)
3. Removes any existing file at the destination (replace wholesale)
4. Copies the template
5. Rewrites `CFBundleName`/`CFBundleDisplayName` in the copy's `Info.plist` (display name ≠ filename)
6. Creates `Contents/Resources/` (the clean template has **no** Resources folder)
7. Copies videos in, named `001_…`, `002_…` (preserves order + avoids name collisions), each set to permissions `0o644`
8. Clears all extended attributes natively (`listxattr`/`removexattr` in-process)
9. Re-signs ad-hoc via `Process`: `codesign --force --deep --sign -`
10. Strips quarantine via `Process`: `xattr -dr com.apple.quarantine`
11. Remembers the output for the Install button; reveals it in Finder

`installScreensaver()` copies the output into `~/Library/Screen Savers/` (replace wholesale).

## Critical constraints (do not "fix" these)

- **The app is intentionally NOT sandboxed.** The sandbox forbids: removing quarantine flags (by design — Gatekeeper), effective xattr manipulation, and it gives injected files owner-only permissions the screensaver host can't read. Re-enabling the sandbox breaks generation. Verify state with:
  `codesign -d --entitlements - <built .app>` — `com.apple.security.app-sandbox` must be absent.
- **Permissions step (7) is required**: without world-readable videos, AVFoundation in the host fails with `err=-17913` → black screen.
- **Steps 8–9 are required**: modifying the bundle invalidates its signature; macOS refuses to load code from an invalid bundle (silent black screen, no logs).
- **Step 10 is required**: quarantined output triggers Gatekeeper "Move to Trash" dialogs on install.
- The signature check for generated output: `codesign -v -vvv <saver>` should print "valid on disk".

## Engine sync

The embedded `ScreenSaverGUL.saver` is a frozen copy. After engine changes, re-sync (command in the root `CLAUDE.md`) and rebuild this app.

## Testing a generated saver end-to-end

```bash
cp -R <output>.saver ~/Library/"Screen Savers"/
defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName "<Name>" path "$HOME/Library/Screen Savers/<Name>.saver" type 0
killall legacyScreenSaver 2>/dev/null; killall ScreenSaverEngine 2>/dev/null
open -a ScreenSaverEngine
```

Never `killall cfprefsd` (resets the selection). System Settings' screensaver pane caches its display — quit (⌘Q) and reopen to refresh.
