# SwiftUI

## SwiftUI is "describe what you want," not "draw step by step"

- In the engine, you wrote imperative drawing code: "fill this rectangle, move this square, redraw." You told the computer how to draw, step by step.

- SwiftUI flips this. You describe what the screen should look like, and SwiftUI figures out how to draw it and keep it updated. You say "a black bar at the top containing a logo and some text," and SwiftUI renders it. This is called declarative UI — you declare the result, not the steps.


## The building blocks: Views
- In SwiftUI, everything on screen is a View. A button is a View, a piece of text is a View, an image is a View. And — this is the key idea — you compose small Views into bigger ones. Your whole app screen is just Views nested inside Views:
	- Your app = a big vertical stack containing → [black header View] + [video workspace View] + [footer View]. And the header itself = a horizontal stack containing → [logo View] + [title View] + [nav items View]. It's Views all the way down, like nesting boxes.


## The three layout tools you'll use constantly
- SwiftUI arranges Views mostly with three "stack" containers:
	- VStack — stacks its contents vertically (top to bottom). Your whole app is a VStack: header on top, workspace in middle, footer at bottom.

	- HStack — stacks its contents horizontally (left to right). Your header is an HStack: logo, then title, then nav items in a row.

	- ZStack — stacks things on top of each other (front to back, like layers). Useful for putting text over an image, etc.

- Almost every layout is just these three, nested. Once this clicks, SwiftUI becomes very approachable — it's like arranging boxes inside boxes.


## What the starter code looks like
- When we open your files in a moment, you'll see two main Swift files SwiftUI made:
	- `ScreenSaverMakerGULApp.swift` — the entry point. It just says "launch the app and show the main window." You rarely touch this. (Note the App on the end of the name — that's how you tell it apart from the next file.)

	- `ContentView.swift` — the actual screen. This is where the starter puts a sample View (usually a globe icon and "Hello, world!"). This is the file we'll edit — we replace that sample with your header/workspace/footer.

- You'll also notice each View file has a `#Preview` section and a live preview canvas on the right side of Xcode — SwiftUI shows you the UI as you type, without building and installing. This is a huge advantage over the engine work: no cache-clearing dance, you see changes instantly. You'll like this part.

- Views composed with VStack/HStack/ZStack, described declaratively, shown live in a preview.


