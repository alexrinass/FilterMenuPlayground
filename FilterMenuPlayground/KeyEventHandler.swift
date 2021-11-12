//
//  KeyEventHandler.swift
//  FilterMenuPlayground
//
//  Created by Alexander Rinass on 15.11.21.
//

import AppKit
import Carbon

class KeyEventHandler {
    private var carbonEventHandler: EventHandlerRef?

    deinit {
        remove()
    }
    
    func install() {
        guard carbonEventHandler == nil else { return }
        let ssptr = Unmanaged.passUnretained(self).toOpaque()
        var spec = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: OSType(kEventRawKeyDown))
        var h: EventHandlerRef?
        let status = InstallEventHandler(
            GetEventDispatcherTarget(),
            redirectCallbackToContext as EventHandlerUPP,
            1,
            &spec,
            ssptr,
            &h)
        guard status == noErr else { return }
        carbonEventHandler = h
    }

    func remove() {
        guard self.carbonEventHandler != nil else { return }
        RemoveEventHandler(self.carbonEventHandler)
        self.carbonEventHandler = nil
    }
}

private func redirectCallbackToContext(_ call: EventHandlerCallRef?, _ event: EventRef?, _ context: UnsafeMutableRawPointer!) -> OSStatus {
    guard let event = event else { return CallNextEventHandler(call, event) }
    guard let e = NSEvent(eventRef: UnsafeRawPointer(event)) else { return CallNextEventHandler(call, event) }

    let keyCodes: [UInt16] = [
        36, // return
        53, // ESC
        125, // down
        126 // up
    ]

    if !keyCodes.contains(e.keyCode) {
        NotificationCenter.default.post(name: .KeyEventHandlerDidReceiveEvent, object: nil)
        return CallNextEventHandler(call, event)
    }

    return CallNextEventHandler(call, event)
}

extension NSNotification.Name {
    static let KeyEventHandlerDidReceiveEvent = Notification.Name("KeyEventHandlerDidReceiveEvent")
}
