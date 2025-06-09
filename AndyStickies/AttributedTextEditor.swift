import SwiftUI
import AppKit

struct AttributedTextEditor: NSViewRepresentable {
    @Binding var attributedText: NSAttributedString

    // Change the NSViewType to NSScrollView
    func makeNSView(context: Context) -> NSScrollView {
        // 1) Create and configure the scroll view
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .noBorder
        scrollView.autohidesScrollers = true

        // 2) Create the text view
        let contentSize = scrollView.contentSize
        let textView = NSTextView(frame: NSRect(origin: .zero, size: contentSize))
        textView.isRichText = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.importsGraphics = false
        textView.delegate = context.coordinator

        // make it resize vertically so it shows from the top
        textView.minSize = NSSize(width: 0, height: contentSize.height)
        textView.maxSize = NSSize(width: 1000,
                                  height: 1000)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.textContainer?.containerSize =
            NSSize(width: contentSize.width,
                   height: .greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true

        // 3) Set your colors
        textView.drawsBackground = true
        textView.backgroundColor = NSColor(red: 0.93,
                                           green: 0.90,
                                           blue: 0.97,
                                           alpha: 1.0)
        textView.textColor = .black
        textView.insertionPointColor = .black

        // 4) Put the text view into the scroll view
        scrollView.documentView = textView

        // 5) Seed it with the current text
        textView.textStorage?.setAttributedString(attributedText)

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }

        // Keep the NSTextView in sync
        if textView.attributedString() != attributedText {
            textView.textStorage?.setAttributedString(attributedText)
        }

        // Re-apply styling in case of appearance changes
        textView.drawsBackground = true
        textView.backgroundColor = NSColor(red: 0.93,
                                           green: 0.90,
                                           blue: 0.97,
                                           alpha: 1.0)
        textView.textColor = .black

        // **Scroll to the very top** so new text always appears there
        DispatchQueue.main.async {
            nsView.contentView.scroll(to: .zero)
            nsView.reflectScrolledClipView(nsView.contentView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: AttributedTextEditor
        init(_ parent: AttributedTextEditor) { self.parent = parent }

        func textDidChange(_ notification: Notification) {
            if let tv = notification.object as? NSTextView {
                parent.attributedText = tv.attributedString()
            }
        }
    }
}
