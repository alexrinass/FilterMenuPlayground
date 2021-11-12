//
//  NSMenu+HighlightItem.swift
//  FilterMenuPlayground
//
//  Created by Alexander Rinass on 15.11.21.
//

import AppKit

extension NSMenu {
    func _highlightItem(_ item: NSMenuItem) {
        let sel = NSSelectorFromString("highlightItem:")
        if responds(to: sel) {
            perform(sel, with: item)
        }
    }
}
