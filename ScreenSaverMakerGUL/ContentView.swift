//
//  ContentView.swift
//  ScreenSaverMakerGUL
//
//  Created by SeungHwan Um on 2026-07-04.
//

import SwiftUI

struct ContentView: View
{
    @State private var showingHelp = false


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
            Spacer()
            Text("Video workspace goes here")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(minWidth: 700,
               minHeight: 500)
        .sheet(isPresented: $showingHelp)
        {
            HelpView()
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

