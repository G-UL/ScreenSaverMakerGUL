# The Full Manual Test Sequence

1. Strip quarantine from the generated file (Gatekeeper)
xattr -dr com.apple.quarantine ~/Desktop/TestFive.saver

2. Install it into the Screen Savers folder
cp -R ~/Desktop/TestFive.saver ~/Library/"Screen Savers"/

3. Make the videos readable (sandboxed app copies them owner-only)
chmod -R a+r ~/Library/"Screen Savers"/TestFive.saver

4. Clear ALL extended attributes (codesign refuses "detritus")
xattr -cr ~/Library/"Screen Savers"/TestFive.saver

5. Re-sign ad-hoc (bundle was modified, signature must be refreshed)
codesign --force --deep --sign - ~/Library/"Screen Savers"/TestFive.saver

6. Verify the signature is valid
codesign -v -vvv ~/Library/"Screen Savers"/TestFive.saver

7. Select TestFive as the active screensaver
defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName "TestFive" path "$HOME/Library/Screen Savers/TestFive.saver" type 0

8. Kill any stale screensaver host processes (the zombie-process lesson!)
killall legacyScreenSaver 2>/dev/null
killall legacyScreenSaver-x86_64 2>/dev/null
killall ScreenSaverEngine 2>/dev/null

9. Run it
open -a ScreenSaverEngine
