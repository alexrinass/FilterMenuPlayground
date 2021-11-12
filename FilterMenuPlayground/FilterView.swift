//
//  FilterView.swift
//  FilterMenuPlayground
//
//  Created by Alexander Rinass on 15.11.21.
//

import AppKit
import Combine

class FilterView: NSView {
    let searchField: NSSearchField = NSSearchField()
    private var cancellables: [AnyCancellable] = []

    private let filterActiveImage: NSImage = {
        let image = NSImage(systemSymbolName: "line.3.horizontal.decrease.circle.fill", accessibilityDescription: nil)

        let cellImage = NSImage(size: NSSize(width: 15, height: 15), flipped: false) { rect in
            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            let cgImage = image!.cgImage(forProposedRect: nil, context: nil, hints: nil)

            NSColor.controlAccentColor.set()
            context.clip(to: rect, mask: cgImage!)
            context.fill(rect)

            return true
        }

        cellImage.isTemplate = false
        return cellImage
    }()

    private let filterInactiveImage: NSImage = {
        let image = NSImage(systemSymbolName: "line.3.horizontal.decrease.circle", accessibilityDescription: nil)

        let cellImage = NSImage(size: NSSize(width: 15, height: 15), flipped: false) { rect in
            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            let cgImage = image!.cgImage(forProposedRect: nil, context: nil, hints: nil)

            NSColor.secondaryLabelColor.set()
            context.clip(to: rect, mask: cgImage!)
            context.fill(rect)

            return true
        }

        cellImage.isTemplate = false
        return cellImage
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configureView()
        updateFilterImage()
        configureObserver()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        updateFilterImage()
        configureObserver()
    }

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false

        searchField.placeholderString = "Filter"
        searchField.focusRingType = .none

        addSubview(searchField)

        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        searchField.topAnchor.constraint(equalTo: topAnchor, constant: -1).isActive = true
    }

    func configureObserver() {
        NotificationCenter.default.publisher(for: NSControl.textDidChangeNotification, object: searchField)
            .sink { [weak self] n in
                self?.updateFilterImage()
            }
            .store(in: &cancellables)
    }

    func updateFilterImage() {
        let isFiltering = searchField.stringValue != ""
        let cellImage = isFiltering ? filterActiveImage : filterInactiveImage

        let buttonCell = NSButtonCell(imageCell: cellImage)
        buttonCell.isBordered = false
        (searchField.cell as! NSSearchFieldCell).resetSearchButtonCell() // Forces the cell to redraw because `updateCell` isn't working
        (searchField.cell as! NSSearchFieldCell).searchButtonCell = buttonCell
    }
}
