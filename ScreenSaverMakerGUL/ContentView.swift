//
//  ContentView.swift
//  ScreenSaverMakerGUL
//
//  Created by SeungHwan Um on 2026-07-04.
//

import SwiftUI
// for identifying video file types
import UniformTypeIdentifiers


struct ContentView: View
{
    @State private var showingHelp = false
    @State private var videoURLs: [URL] = []        // the videos the user added
    @State private var showingFilePicker = false     // controls the file picker
    
    
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
                
                // Temporary: show how many videos have been added, so we can
                // confirm the picker works before we build the real list.
                Text("\(videoURLs.count) video(s) added")
                    .foregroundStyle(.secondary)
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
    
    
    // Called when the user finishes picking files.
    private
    func
    handleFilePick(_ result: Result<[URL], Error>)
    {
        switch result
        {
            case .success(let urls):
                // Add the newly picked videos to our list.
                videoURLs.append(contentsOf: urls)
            case .failure(let error):
                // If something went wrong, just log it for now.
                print("File pick failed: \(error.localizedDescription)")
        }
    }
}


#Preview
{
    ContentView()
}


// The usage guide shown when "Help" is clicked.
struct HelpView: View
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
struct SocialIcon: View
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


