//
//  ContentView.swift
//  ScreenSaverMakerGUL
//
//  Created by SeungHwan Um on 2026-07-04.
//

import SwiftUI
// for identifying video file types
import UniformTypeIdentifiers
// for NSSavePanel
// It's the standard save dialog: the user navigates,
// types a filename, hits Save, and we get back the URL they chose.
import AppKit


struct ContentView: View
{
    @State private var showingHelp = false
    @State private var videos: [VideoItem] = []      // the videos the user added
    @State private var showingFilePicker = false     // controls the file picker
    @State private var statusMessage = ""            // feedback for the user
    
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            // ---- BLACK HEADER BAR ----
            HStack
            {
                // The crown logo will go here later; for now, a placeholder
                // text so we can see the header taking shape.
                Link(destination: URL(string: "https://g-ul.me/hello/")!)
                {
                    Image("G-UL-Logo-Big")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 32)
                }
                
                Text("Screensaver Maker")
                    .font(.title3)
                    .foregroundStyle(.white)
                
                Spacer()   // pushes the nav items to the right edge
                
                Button("Help") {
                    showingHelp = true
                }
                .foregroundStyle(.white)
            }
            .padding(.horizontal,
                     20)
            .padding(.vertical,
                     14)
            .background(Color.black)
            
            // ---- MAIN WORKSPACE (empty for now) ----
            VStack(spacing: 16)
            {
                // "Add Videos" button
                // The first block is what happens on click (open the picker)
                Button
                {
                    showingFilePicker = true
                }
                // the label: block is what it looks like
                // (a "+" icon with "Add Videos" text)
            label:
                {
                    // Label pairs text with an icon. plus.circle.fill is
                    // a built-in SF Symbol (a filled plus-in-circle).
                    // This is where SF Symbols do shine — generic UI
                    // icons like plus, gear, trash are all there
                    // (it's only brand logos they lack).
                    Label("Add Videos",
                          systemImage: "plus.circle.fill")
                    .font(.title3)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.top,
                         20)
                
                Button
                {
                    createScreensaver()
                }
            label:
                {
                    Label("Create Screensaver",
                          systemImage: "wand.and.stars")
                    .font(.title3)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .disabled(videos.isEmpty)      // can't create with no videos
                
                // Feedback line
                if !statusMessage.isEmpty
                {
                    Text(statusMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                // Show the added videos as a list, or a hint if empty.
                if videos.isEmpty
                {
                    Spacer()
                    Text("No videos yet. Click \"Add Videos\" to begin.")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                else
                {
                    // List is the scrollable container;
                    // ForEach walks through each url in your array and
                    // builds a row for it. id: \.self tells it to
                    // identify each row by the URL itself
                    // (since URLs are unique).
                    List
                    {
                        ForEach(videos)
                        {
                            video in
                            HStack
                            {
                                Image(systemName: "film")
                                    .foregroundStyle(.red)
                                // a URL is a long path like
                                // Users/gul/Movies/clip1.mov;
                                // .lastPathComponent extracts just
                                // the filename (clip1.mov).
                                // Much friendlier to show than the full path.
                                Text(video.url.lastPathComponent)
                                Spacer()
                                // Delete button for this row
                                Button
                                {
                                    removeVideo(video)
                                }
                            label:
                                {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        // This handler fires when the user drags a row.
                        // indices is where the row(s) came from,
                        // newOffset is where they're being dropped.
                        .onMove
                        {
                            indices, newOffset in
                            videos.move(fromOffsets: indices,
                                        toOffset: newOffset)
                        }
                    }
                    .frame(minHeight: 200)
                }
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.movie],   // only video files
                allowsMultipleSelection: true    // let them pick several at once
            )
            {
                result in handleFilePick(result)
            }
            
            
            // ---- FOOTER ----
            HStack
            {
                // Far left: copyright
                Text("© SeungHwan, G-UL, Um")
                    .font(.footnote)
                    .foregroundStyle(Color(red: 0.2,
                                           green: 0.2,
                                           blue: 0.2))
                
                Spacer()   // pushes everything below to the right
                
                // Footer logo → /place/
                Link(destination: URL(string: "https://g-ul.me/place/")!)
                {
                    Image("G-UL-Logo2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                }
                
                // Social icons (red circles) — REPLACE the image names below
                // with your actual asset names.
                SocialIcon(imageName: "Facebook-Logo",
                           url: "https://www.facebook.com/stuperfection.g.ul/")
                SocialIcon(imageName: "LinkedIn-Logo",
                           url: "https://www.linkedin.com/in/g-ul/")
                SocialIcon(imageName: "Github-Logo",
                           url: "https://github.com/G-UL")
                SocialIcon(imageName: "Instagram-Logo",
                           url: "https://www.instagram.com/ii_gul_ii/")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(red: 0.969,
                              green: 0.969,
                              blue: 0.976))
        }
        .frame(minWidth: 700,
               minHeight: 500)
        .sheet(isPresented: $showingHelp)
        {
            HelpView()
        }
    }
    
    
    // Piece 1: copy the embedded engine template to a test location.
    // Ask the user where to save, then copy the engine template there.
    private
    func
    createScreensaver()
    {
        // 1. Find the engine template inside our own app bundle.
        guard let engineURL = Bundle.main.url(forResource: "ScreenSaverGUL",
                                              withExtension: "saver")
        else
        {
            statusMessage = "Error: engine template not found in app."
            return
        }
        
        // 2. Show the system save dialog with a suggested name.
        let panel = NSSavePanel()
        panel.title = "Save Your Screensaver"
        panel.nameFieldStringValue = "MyScreensaver.saver"   // default name
        panel.canCreateDirectories = true
        // Only proceed if the user clicked Save (not Cancel).
        guard panel.runModal() == .OK, let destination = panel.url
        else
        {
            statusMessage = "Cancelled."
            return
        }
        
        do
        {
            // 3. Replace anything already at that path.
            if FileManager.default.fileExists(atPath: destination.path)
            {
                try FileManager.default.removeItem(at: destination)
            }
            
            // 4. Copy the engine template to the chosen location.
            try FileManager.default.copyItem(at: engineURL,
                                             to: destination)

            // 5. Update the copy's Info.plist so macOS shows the user's name.
            //    Get the name without the ".saver" extension.
            let saverName = destination.deletingPathExtension().lastPathComponent
            let plistURL = destination
                .appendingPathComponent("Contents")
                .appendingPathComponent("Info.plist")
            if let plist = NSMutableDictionary(contentsOf: plistURL)
            {
                plist["CFBundleName"] = saverName
                plist["CFBundleDisplayName"] = saverName
                plist.write(to: plistURL, atomically: true)
            }
            
            // 6. Create the Resources folder (the clean template has none).
            let resourcesURL = destination
                .appendingPathComponent("Contents")
                .appendingPathComponent("Resources")
            
            try FileManager.default.createDirectory(
                at: resourcesURL,
                withIntermediateDirectories: true
            )
            
            // 7. Copy each video in, numbered to preserve the user's order
            //    and to avoid duplicate-filename collisions.
            for (index, video) in videos.enumerated()
            {
                let numbered = String(format: "%03d_%@",
                                      index + 1,
                                      video.url.lastPathComponent)
                let dest = resourcesURL.appendingPathComponent(numbered)
                // Claim sandbox access to this user-picked file.
                let didStart = video.url.startAccessingSecurityScopedResource()
                defer
                {
                    if didStart
                    {
                        video.url.stopAccessingSecurityScopedResource()
                    }
                }
                try FileManager.default.copyItem(at: video.url,
                                                 to: dest)
                // Make this video world-readable natively — the sandboxed
                // copy gives owner-only permissions, which the screensaver
                // host process can't read.
                try FileManager.default.setAttributes(
                    [.posixPermissions: 0o644],
                    ofItemAtPath: dest.path
                )
            }

            // 8. Clear extended attributes natively (spawned xattr lacks
            //    our sandbox grant; these C calls run in-process).
            clearXattrsRecursively(at: destination)

            // 9. Re-sign ad-hoc. codesign has no Swift API, so it stays a
            //    Process call — and it succeeded in our tests.
            runCommand("/usr/bin/codesign",
                       ["--force",
                        "--deep",
                        "--sign",
                        "-",
                        destination.path])

            // 10. Strip the quarantine flag — possible now that we're
            //     unsandboxed. Without this, Gatekeeper blocks the output.
            runCommand("/usr/bin/xattr",
                       ["-dr",
                        "com.apple.quarantine",
                        destination.path])

            statusMessage = "Created: \(destination.lastPathComponent)"
        }
        catch
        {
            statusMessage = "Failed: \(error.localizedDescription)"
        }
    }


    // Remove all extended attributes from a file — natively, in-process.
    private
    func
    clearXattrs(atPath path: String)
    {
        let size = listxattr(path,
                             nil,
                             0,
                             0)
        guard size > 0 else
        {
            return
        }

        var buffer = [CChar](repeating: 0,
                             count: size)
        let count = listxattr(path,
                              &buffer,
                              size,
                              0)
        guard count > 0 else
        {
            return
        }

        // The buffer holds attribute names separated by null bytes.
        var names: [String] = []
        var current = ""
        for ch in buffer[0..<count]
        {
            if ch == 0
            {
                if !current.isEmpty
                {
                    names.append(current)
                }

                current = ""
            }
            else
            {
                current.append(Character(UnicodeScalar(UInt8(bitPattern: ch))))
            }
        }

        for name in names
        {
            removexattr(path,
                        name,
                        0)
        }
    }


    // Apply clearXattrs to a bundle and everything inside it.
    private
    func
    clearXattrsRecursively(at url: URL)
    {
        clearXattrs(atPath: url.path)
        if let enumerator = FileManager.default.enumerator(
            at: url,
            includingPropertiesForKeys: nil
        )
        {
            for case let file as URL in enumerator
            {
                clearXattrs(atPath: file.path)
            }
        }
    }


    // Called when the user finishes picking files.
    private
    func
    handleFilePick(_ result: Result<[URL], Error>)
    {
        switch result
        {
        case .success(let urls):
            // Wrap each picked URL in a VideoItem and add to our list.
            videos.append(contentsOf: urls.map { VideoItem(url: $0) })
        case .failure(let error):
            // If something went wrong, just log it for now.
            print("File pick failed: \(error.localizedDescription)")
        }
    }
    
    
    // Remove a specific video from the list.
    private
    func
    removeVideo(_ video: VideoItem)
    {
        videos.removeAll { $0.id == video.id }
    }
    
    
    // Run a command-line tool and wait for it to finish.
    // Returns true if it exited successfully.
    @discardableResult
    private
    func
    runCommand(_ toolPath: String,
               _ arguments: [String]) -> Bool
    {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: toolPath)
        process.arguments = arguments
        do
        {
            try process.run()
            process.waitUntilExit()

            return process.terminationStatus == 0
        }
        catch
        {
            return false
        }
    }
}


#Preview
{
    ContentView()
}


// The usage guide shown when "Help" is clicked.
struct
HelpView: View
{
    @Environment(\.dismiss) private var dismiss


    var body: some View
    {
        VStack(alignment: .leading,
               spacing: 16)
        {
            Text("How to Use G-UL Screensaver Maker")
                .font(.title)
                .fontWeight(.bold)

            Text("This app turns your videos into a macOS screensaver.")
                .foregroundStyle(.secondary)

            // Placeholder steps — we'll refine these once features exist.
            VStack(alignment: .leading,
                   spacing: 10)
            {
                Text("1.  Add your video files.")
                Text("2.  Drag to arrange the play order.")
                Text("3.  Click \"Create Screensaver\".")
                Text("4.  Install the generated screensaver.")
            }

            Spacer()

            // Small about line at the bottom.
            Text("Made by G-UL  •  g-ul.me")
                .font(.footnote)
                .foregroundStyle(.secondary)

            HStack
            {
                Spacer()
                Button("Close")
                {
                    dismiss()
                }
            }
        }
        .padding(30)
        .frame(width: 460,
               height: 360)
    }
}


// A single social icon: a brand image on a red circle, links to a URL.
struct
SocialIcon: View
{
    let imageName: String
    let url: String

    var body: some View
    {
        Link(destination: URL(string: url)!)
        {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
//                .padding(8)                     // space between icon and circle edge
//                .background(Color.red)          // the red circle color
//                .clipShape(Circle())            // makes the red background a circle
//                .foregroundStyle(.white)        // (helps if icon is a template)
        }
        .buttonStyle(.plain)                    // removes default link styling
    }
}


// One video in the user's list. The UUID gives each row a stable,
// unique identity — even if the same file is added twice.
struct
VideoItem: Identifiable
{
    let id = UUID()
    let url: URL
}
