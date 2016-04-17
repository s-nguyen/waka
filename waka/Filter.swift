//
//  Filter.swift
//  waka
//
//  Created by WellMet on 3/9/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class Filter {
    //vars
    var recording = false;
    var playing = false;
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioEffector: AVAudioUnit!
    
    var volume:Float = 3.0
    var speed:Float = 1.0
    var pitch:Float = 0.0
    
    var currentFilePath = ""
    var filterNum = 0
    
    
    //methods
    func startRecord(){
        //get an audio session from the avkit
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        
        //Already amd epermission before. Try removing and testing this again.
        //ask for permission
        if(audioSession.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    
                    //set category and activate recorder session
                    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try! audioSession.setActive(true)
                    
                    
                    //get documnets directory
                    let documentsDirectory : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!
                    let fullPath = documentsDirectory.stringByAppendingPathComponent("voiceRecording.caf")
                    let url = NSURL.fileURLWithPath(fullPath)
                    
                    self.currentFilePath = fullPath
                    
                    //settings for the recorder
                    let settings: [String : AnyObject] = [
                        AVFormatIDKey:Int(kAudioFormatAppleIMA4), //Int required in Swift2
                        AVSampleRateKey:44100.0,
                        AVNumberOfChannelsKey:2,
                        AVEncoderBitRateKey:12800,
                        AVLinearPCMBitDepthKey:16,
                        AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
                    ]
                    
                    //record and write to documents
                    try! self.audioRecorder = AVAudioRecorder(URL: url, settings: settings)
                    self.audioRecorder.record()
                    
                } else{
                    print("Error starting recorder")
                }
            })
        }
    }
    
    func stopRecord(){
        self.audioRecorder.stop()
    }
    
    func startPlaying(){
        
        //var error: NSError?
        
        //get documnets directory
        let documentsDirectory : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first!
        let fullPath = documentsDirectory.stringByAppendingPathComponent("voiceRecording.caf")
        let url = NSURL.fileURLWithPath(fullPath)

        
        try! self.audioPlayer = AVAudioPlayer(contentsOfURL: url)
        audioFile = try? AVAudioFile(forReading: url)
        
        /*
        //set enable to change audio speed
        audioPlayer.enableRate = true
        
        audioPlayer.volume = self.volume
        audioPlayer.rate = self.speed
        */
        audioEngine = AVAudioEngine()
        
        //reset
        self.stopPlaying()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let changePitchEffect = AVAudioUnitTimePitch()
        
        
        //apply speed
        changePitchEffect.rate = self.speed
        
        //apply pitch
        
        if(self.pitch==0){
            changePitchEffect.pitch=1;
        }else{
            changePitchEffect.pitch = self.pitch*1200
        }
        
        
        
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        //apply filter
        if(filterNum==1){
            let echoEffect = AVAudioUnitDelay()
            echoEffect.delayTime=1.2
            echoEffect.feedback=20
            
            
            audioEngine.attachNode(echoEffect)
            audioEngine.connect(changePitchEffect, to: echoEffect, format: nil)
            audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
            
        }else if(filterNum==2){
            let reverbEffect = AVAudioUnitReverb()
            
            reverbEffect.loadFactoryPreset(.LargeRoom2)
            reverbEffect.wetDryMix=80
            
            audioEngine.attachNode(reverbEffect)
            audioEngine.connect(changePitchEffect, to:reverbEffect, format: nil)
            audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
            
        }else{
            //no effect
            audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        }
        

        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch _ {
            print("Error")
        }
        
        audioPlayerNode.play()
        
        
        
        //audioPlayer.prepareToPlay()
        //audioPlayer.play()
 
    }
    
    func stopPlaying(){
       // audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    func applyFilter(){
        //apply filter method..
    }
    
    
    
}