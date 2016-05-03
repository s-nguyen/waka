//
//  Metronome.swift
//  waka
//
//  Created by WellMet on 5/1/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import Foundation
import AudioKit

class Metronome {
    //meter is 1, 2, or 4.  1 = quarter not, 2 = eigth note, 4 = sixteenth note

    var meter: Int!
    var bpm: Double!
    var interval: Double!
    var count: Int!
    var tambo: AKTambourineInstrument!
    var orch: AKOrchestra!
    var amp: AKAmplifier!
    var timer: NSTimer!
    var first: Bool!
    
    init(){
        
        self.tambo = AKTambourineInstrument()
        self.orch = AKOrchestra()
        self.amp = AKAmplifier()
        self.timer = NSTimer()
        self.meter = 1
        self.bpm = 1.0
        self.interval = 1
        self.count = 0
        self.first = true
        self.orch.addInstrument(tambo)
        self.amp = AKAmplifier(input: tambo.output)
        self.orch.addInstrument(amp)
        self.amp.start()
      
    }
    
    func start(){
        amp.start()
        interval = 1/(Double((bpm*Double(meter))/60))
        //setup timer at intervals based on meter and bpm
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    func stop(){
        amp.stop()
        timer.invalidate()
    }
    
    @objc func timerUpdate(){
        let note = AKTambourineNote()
        amp.amplitude.value = 0.5
        if(count == 0 ){
            //makes the first note of the meter louder
            amp.amplitude.value = 1.5
        
        }
        
        note.duration.value = Float(interval/1.7)
        tambo.playNote(note)
        
        //keep track of rhthym.  quarter note and sixteenth should reset every 4. eigth every 2
        count = count + 1
        if((meter == 1 || meter == 4) && count > 3){
            count = 0
        }
        else if(meter == 2 && count > 1){
            count = 0
        }
    }
}