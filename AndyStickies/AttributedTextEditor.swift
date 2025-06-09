//
//  AttributedTextEditor.swift
//  AndyStickies
//
//  Created by Andrew Burgess on 6/9/25.
//

import SwiftUI
import AppKit

// A simple NSViewRepresentable wrapper to expose NSTextView (rich text) in SwiftUI
struct AttributedTextEditor: NSViewRepresentable {
    @Binding var attributedText: NSAttributedString

    func makeNSView(context: Context) -> NSTextView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .noBorder
        scrollView.autohidesScrollers = true

        let textView = NSTextView()
        textView.isRichText = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.importsGraphics = false
        textView.textStorage?.setAttributedString(attributedText)
        textView.delegate = context.coordinator

        // Set custom light purple background and black text
        textView.drawsBackground = true
        textView.backgroundColor = NSColor(red: 0.93, green: 0.90, blue: 0.97, alpha: 1.0)
        textView.textColor = NSColor.black
        textView.insertionPointColor = NSColor.black

        scrollView.documentView = textView
        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        // Keep SwiftUI state in sync
        if nsView.attributedString() != attributedText {
            nsView.textStorage?.setAttributedString(attributedText)
        }
        // Reinforce background and text color in case of appearance changes
        nsView.drawsBackground = true
        nsView.backgroundColor = NSColor(red: 0.93, green: 0.90, blue: 0.97, alpha: 1.0)
        nsView.textColor = NSColor.black
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

