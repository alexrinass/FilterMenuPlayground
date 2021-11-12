//
//  FilterMenuController.swift
//  FilterMenuPlayground
//
//  Created by Alexander Rinass on 12.11.21.
//

import AppKit
import Carbon
import Combine

class FilterMenuController: NSObject, NSMenuDelegate, NSSearchFieldDelegate {
    var selectedRef: String?
    private let dataLoader = RefsLoader()
    private let keyEventHandler = KeyEventHandler()
    private var cancellables: [AnyCancellable] = []

    var popUpButton: NSPopUpButton? {
        didSet {
            configurePopUpButton()
            configureNotifcationHandler()
            dataLoader.reload()
            selectedRef = dataLoader.allRefs.first
            generateMenu()
            popUpButton?.selectItem(withTitle: selectedRef!)
            popUpButton?.synchronizeTitleAndSelectedItem()
        }
    }

    private lazy var filterMenuItem: NSMenuItem = {
        let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")

        let view = FilterView()
        view.searchField.delegate = self
        // Magic numbers 25, 4, and -1 make consistent 5pt margins around the filter
        // Setting the menu item's width to 200 enforces a min width for the menu (was having a hard time getting the menu's `minWidth` property to be respected)
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        view.heightAnchor.constraint(equalToConstant: 25).isActive = true
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        item.view = view
        return item
    }()

    private var searchField: NSSearchField {
        return (filterMenuItem.view as! FilterView).searchField
    }

    private func configurePopUpButton() {
        guard popUpButton != nil else {
            return
        }

        popUpButton?.target = self
        popUpButton?.action = #selector(selectionDidChange(_:))
        popUpButton?.menu?.delegate = self
    }

    private func configureNotifcationHandler() {
        NotificationCenter.default.publisher(for: .KeyEventHandlerDidReceiveEvent, object: nil)
            .sink { [weak self] n in
                (self?.filterMenuItem.view as! FilterView).searchField.selectText(nil)
                self?.keyEventHandler.remove()
        }.store(in: &cancellables)
    }

    private func generateMenu() {
        if let menu = popUpButton?.menu {
            menu.removeAllItems()
            menu.addItem(filterMenuItem)

            for ref in dataLoader.refs {
                let item = NSMenuItem(title: ref, action: nil, keyEquivalent: "")

                if item.title == selectedRef {
                    item.state = .on

                }

                menu.addItem(item)
            }
        }
    }

    private func filterMenu() {
        if let menu = popUpButton?.menu {
            for item in menu.items {
                if item == filterMenuItem {
                    continue
                }

                if item.title == selectedRef {
                    continue
                }

                item.isHidden = !dataLoader.refs.contains(item.title)
            }

            menu.popUp(positioning: menu.items[1], at: NSPoint(x: 0, y: 0), in: popUpButton!)
        }
    }

    @IBAction func selectionDidChange(_ sender: Any?) {
        selectedRef = popUpButton?.selectedItem?.title
    }

    func highlightPrevMenuItem() -> Bool {
        if let menu = popUpButton?.menu {
            var visibleItems = menu.visibleItems
            visibleItems.removeFirst()
            guard visibleItems.count > 0 else { return false }

            var i = 0

            if let highlightedItem = menu.highlightedItem {
                if visibleItems.contains(highlightedItem) {
                    if let j = visibleItems.firstIndex(of: highlightedItem) {
                        if j > visibleItems.startIndex {
                            i = visibleItems.index(before: j)
                        }
                    }
                }
            }

            menu._highlightItem(visibleItems[i])
            return false
        }

        return false
    }

    func highlightNextMenuItem() -> Bool {
        if let menu = popUpButton?.menu {
            var visibleItems = menu.visibleItems
            visibleItems.removeFirst()

            guard visibleItems.count > 0 else { return false }

            var i = 0

            if let highlightedItem = menu.highlightedItem {
                if visibleItems.contains(highlightedItem) {
                    if let j = visibleItems.firstIndex(of: highlightedItem) {
                        if j < visibleItems.endIndex {
                            i = visibleItems.index(after: j)
                        }
                    }
                }
            }

            let nextItem = visibleItems[i]
            menu._highlightItem(nextItem)
            return false
        }

        return false
    }

    // MARK: NSMenuDelegate

    func menuWillOpen(_ menu: NSMenu) {
        searchField.stringValue = ""
        dataLoader.filterString = ""
        dataLoader.reload()
        filterMenu()
    }

    // MARK: NSTextFieldDelegate

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.moveUp(_:)) {
            return highlightPrevMenuItem()
        }

        if commandSelector == #selector(NSResponder.moveDown(_:)) {
            return highlightNextMenuItem()
        }

        return false
    }

    func controlTextDidChange(_ obj: Notification) {
        if let userInfo = obj.userInfo, let fieldEditor = userInfo["NSFieldEditor"] as? NSTextView {
            dataLoader.filterString = fieldEditor.string
            dataLoader.reload()
            filterMenu()
        }
    }

    func controlTextDidBeginEditing(_ obj: Notification) {
        print("controlTextDidBeginEditing")
        keyEventHandler.remove()
    }

    func controlTextDidEndEditing(_ obj: Notification) {
        print("controlTextDidEndEditing")
        keyEventHandler.install()
    }
}
