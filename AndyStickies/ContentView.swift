import SwiftUI
import AppKit

struct ContentView: View {
    @State private var note = NSAttributedString(string: "New Note")

    var body: some View {
        ZStack {
            // 1) Your fixed “light purple” background:
            Color(red: 0.93, green: 0.90, blue: 0.97)
              .ignoresSafeArea()

            // 2) Your rich-text editor on top of it
            AttributedTextEditor(attributedText: $note)
              .padding()
        }
        .frame(minWidth: 100, minHeight: 100)
    }
}


// ——— This block is required for the Canvas to appear ———
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
