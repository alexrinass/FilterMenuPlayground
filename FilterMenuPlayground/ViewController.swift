//
//  ViewController.swift
//  FilterMenuPlayground
//
//  Created by Alexander Rinass on 12.11.21.
//

import Cocoa

class ViewController: NSViewController {
    let filterMenuController = FilterMenuController()
    @IBOutlet weak var popUpButton: NSPopUpButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        filterMenuController.popUpButton = popUpButton
    }
}

