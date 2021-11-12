//
//  NSMenu+VisibleItems.swift
//  FilterMenuPlayground
//
//  Created by Alexander Rinass on 15.11.21.
//

import AppKit

extension NSMenu {
    var visibleItems: [NSMenuItem] {
        get {
            items.filter { item in
                !item.isHidden
            }
        }
    }

    var indexesOfVisibleItems: IndexSet {
        get {
            (items as NSArray).indexesOfObjects { item, i, c in
                return (item as! NSMenuItem).isHidden
            }
        }
    }
}
