//
//  MetronomeViewController.swift
//  waka
//
//  Created by Uxi on 3/9/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import UIKit


class MetronomeViewController: UIViewController{
    var metronome = Metronome()
    var playing = false
    @IBOutlet weak var quarterButton: UIButton!
    @IBOutlet weak var eigthButton: UIButton!
    @IBOutlet weak var sixteenthButton: UIButton!
    @IBOutlet weak var bpmSlider: UISlider!
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var bpmText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metronome.bpm = Double(bpmSlider.value)
        metronome.meter = 1
        let intBPM = Int(bpmSlider.value)
        bpmText.text = "\(intBPM)"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func quarterPressed(sender: AnyObject) {
        metronome.meter = 1
    }
    @IBAction func eigthPressed(sender: AnyObject) {
        metronome.meter = 2
    }
    @IBAction func sixteenthPressed(sender: AnyObject) {
        metronome.meter = 4
    }
    @IBAction func playPressed(sender: AnyObject) {
        if(playing){
            playing = false
            metronome.stop()
            quarterButton.enabled = true
            eigthButton.enabled = true
            sixteenthButton.enabled = true
            bpmSlider.enabled = true
            playerButton.setTitle("Play", forState: UIControlState.Normal)
        }
        else{
            playerButton.setTitle("Stop", forState: UIControlState.Normal)
            playing = true
            quarterButton.enabled = false
            eigthButton.enabled = false
            sixteenthButton.enabled = false
            bpmSlider.enabled = false
            metronome.start()
        }
    }
    @IBAction func bpmChanged(sender: AnyObject) {
        metronome.bpm = Double(bpmSlider.value)
        let intBPM = Int(bpmSlider.value)
        bpmText.text = "\(intBPM)"
    }
}
