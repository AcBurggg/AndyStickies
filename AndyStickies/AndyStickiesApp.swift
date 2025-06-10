
import SwiftUI

@main
struct StickiesMVPApp: App {
    var body: some Scene {
        WindowGroup("Andy Note : )") {
            ContentView()
        }
        .defaultSize(width: 200, height: 200)
        .commands {
            CommandMenu("Format") {
                Button("Strikethrough") {
                    guard let tv = NSApp.keyWindow?
                                           .firstResponder as? NSTextView,
                          let storage = tv.textStorage
                    else { return }

                    let sel = tv.selectedRange()
                    let text = tv.string as NSString
                    let rangeToToggle = sel.length > 0
                      ? sel
                      : text.lineRange(for: sel)

                    storage.beginEditing()
                    storage.enumerateAttribute(
                        .strikethroughStyle,
                        in: rangeToToggle,
                        options: []
                    ) { value, subRange, _ in
                        let current = (value as? Int) ?? 0
                        let next = (current == NSUnderlineStyle.single.rawValue)
                          ? 0
                          : NSUnderlineStyle.single.rawValue
                        storage.addAttribute(
                            .strikethroughStyle,
                            value: next,
                            range: subRange
                        )
                    }
                    storage.endEditing()
                }
                .keyboardShortcut("d", modifiers: .command)
            }
        }
    }
}
