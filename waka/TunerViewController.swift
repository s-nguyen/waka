//
//  TunerViewController.swift
//  waka
//
//  Created by Uxi on 3/9/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import UIKit
import TuningFork



class TunerViewController: UIViewController, TunerDelegate {
    
    private var wakaTuner: Tuner?
    private var running = false
    private var generating = false
    private var wakaAudio = ToneGenerator()
    private var timer = NSTimer()
    private var genFreq = Float(0)
    private let tones: [Float] = [
        130.8, 138.6, 146.8, 155.6, 164.8, 174.6, 185.0, 196.0, 207.7, 220.0, 233.1, 246.9, // octive 3
        261.6, 277.2, 293.7, 311.1, 329.6, 349.2, 370.0, 392.0, 415.3, 440.0, 466.2, 493.9, // octive 4
        523.3, 554.4, 587.3, 622.3, 659.3, 698.5, 740.0, 784.0, 830.6, 880.0, 932.3, 987.8, // octive 5
    ]
    private let pitches = [
        "C3", "C♯/D♭3", "D3", "D♯/E♭3", "E3", "F3", "F♯/G♭3", "G3", "G♯/A♭3", "A3", "A♯/B♭3", "B3", //octive 3
        "C4", "C♯/D♭4", "D4", "D♯/E♭4", "E4", "F4", "F♯/G♭4", "G4", "G♯/A♭4", "A4", "A♯/B♭4", "B4", //octive 4
        "C5", "C♯/D♭5", "D5", "D♯/E♭5", "E5", "F5", "F♯/G♭5", "G5", "G♯/A♭5", "A5", "A♯/B♭5", "B5", //octive 5
    ]
    
    @IBOutlet weak var tunerLabel: UITextField!
    @IBOutlet weak var sharpBar: UIProgressView!
    @IBOutlet weak var flatBar: UIProgressView!
    
    @IBOutlet weak var toneSlider: UISlider!
    @IBOutlet weak var toneButton: UIButton!
    @IBOutlet weak var toneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reverse the progress bar direction
        var transform = CGAffineTransform()
        transform = CGAffineTransformMake(1, 0, 0, -1, 0, flatBar.frame.size.height)
        transform = CGAffineTransformRotate(transform, 3.14)
        flatBar.transform = transform
        //CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, flatBar.frame.size.height)
        
        //setup tuner
        wakaTuner = Tuner()
        wakaTuner?.delegate = self
        wakaTunerStart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func wakaTunerStart() {
        //once start data will be constantly obtain every 0.03 seconds
        if !running {
            running = true
            wakaTuner?.start()
        }
    }
    
    private func wakaTunerStop() {
        //Stop collecting data
        if running {
            running = false
            wakaTuner?.stop()
        }
    }
    
    
    func tunerDidUpdate(wakaTuner: Tuner, output: TunerOutput) {
        //Get Data from here. output.sutff
        var cents : Float
        if output.amplitude < 0.010 {
            //When no sound from instrument is detected
            cents = 0
            flatBar.progress = 0
            sharpBar.progress = 0
            tunerLabel.text = ""
        }
        else if(output.amplitude >= 0.010 && !generating){
            let desiredFrequency = output.frequency - output.distance
            cents = 1200*log2(output.frequency/desiredFrequency)
            //When sound is detected
            tunerLabel.text = output.pitch
            
            //update right status bar based on the distance between the base frequency and the mic frequency
            
            if(output.distance > 0){
                //first find the difference in cents from the desired frequency
                //then scale based on 50 to fit progress bar
                sharpBar.progress = abs(cents)/50
                flatBar.progress = 0
            }
            else if(output.distance < 0){
                flatBar.progress = abs(cents)/50
                sharpBar.progress = 0
            }
        }
    }
    
    @IBAction func tunePressed(sender: AnyObject) {
        if(!generating){
            //play pressed, stop tuner and get send genFreq to engine
            wakaTunerStop()
            generating = true
            genFreq = tones[Int(toneSlider.value)-1]
            //wakaAudio.setFrequency(genFreq)
            
            //display pitch in text field
            tunerLabel.text = pitches[Int(toneSlider.value)-1]
            
            //change play to stop
            toneButton.setTitle("Stop", forState: UIControlState.Normal)
            
            wakaAudio.start()
        }
        else{
            //stop generating and start tuner
            wakaAudio.stop()
            tunerLabel.text = ""
            generating = false
            toneButton.setTitle("Play", forState: UIControlState.Normal)
            wakaTunerStart()
        }
    }
    
    @IBAction func sliderChange(sender: AnyObject) {
        //invalidate any other timer instances
        timer.invalidate()
        
        //slider should only increment in whole numbers, must round slider value
        toneSlider.value = floor(toneSlider.value)
        
        //display tone in tone label
        toneLabel.text = pitches[Int(toneSlider.value)-1]
        
        //give generator new frequency
        wakaAudio.setFrequency(tones[Int(toneSlider.value)-1])
        
        //set timer for 1 second
        timer = NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: false)
    }
    
    func timerUpdate(){
        //make tone label blank
        toneLabel.text = ""
    }
}
