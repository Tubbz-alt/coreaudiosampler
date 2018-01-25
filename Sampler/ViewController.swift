//
//  ViewController.swift
//  Sampler
//
//  Created by Nikita.Kardakov on 23/01/2018.
//  Copyright © 2018 NicheMarket. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet private var label:NSTextField!
    @IBOutlet private var recordButton:NSButton!    
    private let sampler = Sampler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.colors = [NSColor(white:1.0, alpha:0.5).cgColor, NSColor(white:0.0, alpha:0.5).cgColor]
        gradient.startPoint = CGPoint(x:0.0, y:0.5)
        gradient.endPoint = CGPoint(x:1.0, y:0.5)
        gradient.frame = self.view.bounds
        self.view.layer?.addSublayer(gradient)
        
        let gradient2 = CAGradientLayer()
        gradient2.colors = [NSColor(red:0.8, green:0.0, blue:0.0, alpha:0.5).cgColor, NSColor(red:0.0, green:0.8, blue:0.9, alpha:0.5).cgColor]
        gradient2.frame = self.view.bounds
        self.view.layer?.addSublayer(gradient2)
    }
    
    @IBAction func startRecording(sender:NSButton) {
        label.isHidden = !label.isHidden
        recordButton.isHidden = !recordButton.isHidden
        sampler.startRecording()
    }
    
    internal override func mouseDown(with event: NSEvent) {
        if !label.isHidden {
            label.isHidden = !label.isHidden
            recordButton.isHidden = !recordButton.isHidden
            sampler.stopRecording()
        } else {
            onMouseEvent(event: event)
        }
    }

    internal override func mouseDragged(with event: NSEvent) {
        onMouseEvent(event: event)
    }
    
    private func onMouseEvent(event: NSEvent) {
        let pitch = Float(event.locationInWindow.x / view.bounds.size.width)
        let volume = Float(event.locationInWindow.y / view.bounds.size.height)
        sampler.sendNote(pitch:pitch, volume:volume)
    }
}

