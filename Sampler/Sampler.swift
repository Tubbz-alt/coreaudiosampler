//
//  Sampler.swift
//  Sampler
//
//  Created by Nikita.Kardakov on 23/01/2018.
//  Copyright © 2018 NicheMarket. All rights reserved.
//

import Foundation
import AVFoundation

final class Sampler {
    
    private let engine:AVAudioEngine
    private var sampler:AVAudioUnitSampler
    private let pentatonic = [22, 25, 27, 30, 32, 34, 37, 39, 42, 44, 46, 49, 51, 54, 56, 58, 61, 63, 66, 68, 70, 73, 75]
    
    init() {
        engine = AVAudioEngine()
        
        sampler = AVAudioUnitSampler()
        engine.attach(sampler)
        engine.connect(sampler, to:engine.mainMixerNode, format:engine.inputNode.inputFormat(forBus: 0))
        
        do {
            if let url = Bundle.main.url(forResource:"d5", withExtension:"wav") {
                try sampler.loadAudioFiles(at:[url])
            }
            try engine.start()
        } catch {
            print("Couldn't start engine")
        }
    }

    func sendNote(pitch:Float, volume:Float) {
        let index = Int(0 + Float(pentatonic.count - 1) * pitch)
        sampler.startNote(UInt8(pentatonic[index]), withVelocity:UInt8(30 + 60 * volume), onChannel:0)
    }
    
    func startRecording() {
        do {
            engine.stop()
            let format = engine.inputNode.inputFormat(forBus: 0)
            let file = try AVAudioFile(forWriting:sampleFilePath(), settings:format.settings)
            engine.inputNode.installTap(onBus:0, bufferSize:1024, format:format, block: {
                (buffer : AVAudioPCMBuffer!, when : AVAudioTime!) in
                do {
                    try file.write(from: buffer)
                } catch {
                    print("Couldn't write into file")
                }
            })
            try engine.start()
        } catch {
            print("Couldn't record a file")
        }
    }
    
    func stopRecording() {
        engine.inputNode.removeTap(onBus: 0)
        do {
            try sampler.loadAudioFiles(at:[sampleFilePath()])
        } catch {
            print("Couldn't load samples")
        }
    }
    
    private func sampleFilePath() -> URL {
        return URL(fileURLWithPath: "\(NSTemporaryDirectory())sample.caf")
    }
}
