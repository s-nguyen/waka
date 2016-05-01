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
    public var meter = 1
    public var bpm = Double(1)
    private var interval : Double
    private var count = 0
    private var tambo = AKTambourineInstrument()
    private var orch = AKOrchestra()
    private var amp = AKAmplifier()
    private var timer = NSTimer()
    private var first = true
    
    init(){
        orch.addInstrument(tambo)
        amp = AKAmplifier(input: tambo.output)
        orch.addInstrument(amp)
        amp.start()
        interval = 1
        meter = 1
        bpm = 1
        count = 0
        first = true
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
            print("got here")
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