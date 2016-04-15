//
//  ToneGenerator.swift
//  waka
//
//  Created by WellMet on 4/14/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import AVFoundation

class  ToneGenerator{
    var audioEngine : AVAudioEngine
    var player : AVAudioPlayerNode
    var mixer : AVAudioMixerNode
    var buffer : AVAudioPCMBuffer
    var frequency : Float
    init(){
        //setup engine and players
        audioEngine = AVAudioEngine()
        player = AVAudioPlayerNode()
        mixer = audioEngine.mainMixerNode
        buffer = AVAudioPCMBuffer(PCMFormat: player.outputFormatForBus(0), frameCapacity: 100)
        buffer.frameLength = 100
        frequency = 262.00
        generateTone()
        audioEngine.attachNode(player)
        audioEngine.connect(player, to : mixer, format: player.outputFormatForBus(0))
        try! audioEngine.start()
    }
    
    func generateTone(){
        let sampleR = Float(mixer.outputFormatForBus(0).sampleRate)
        let channels = mixer.outputFormatForBus(0).channelCount
        
        //use sin function with given frequency to generate the buffer info
        for var i = 0; i < Int(buffer.frameLength); i+=Int(channels){
            //val =  sin(theta(i))
            //theta(i) = (2pi * f * i)/sampleRate
            let val = sinf((2*Float(M_PI)*262*Float(i))/sampleR)
            buffer.floatChannelData.memory[i] = val * 0.5
        }
    }
    
    func setFrequency(newF: Float){
        frequency = newF
        generateTone()
    }
    
    func start(){
        player.play()
        player.scheduleBuffer(buffer, atTime: nil, options: .Loops, completionHandler: nil)
    }
    
    func stop(){
        player.stop()
    }
}