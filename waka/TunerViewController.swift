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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wakaTuner = Tuner()
        wakaTuner?.delegate = self
        // Do any additional setup after loading the view.
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
    
    private func wakaTuneStop() {
        
    }
    
    //TODO: Let the pitch / frequency stay longer than 0.03 seconds so user can see properly
    
    func tunerDidUpdate(wakaTuner: Tuner, output: TunerOutput) {
        //Get Data from here. output.sutff
        if output.amplitude < 0.005 {
            //When no sound from instrument is detected
        }
        else {
            //When sound is detected
            //example
            //UILabel.Text = output.pitch
            //UILabel.Text = "\(output.frequency)"
        }
    }

    

}
