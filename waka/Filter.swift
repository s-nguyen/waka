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
    var audioRecorder : AVAudioRecorder!
    var currentFilePath = ""
    
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
}