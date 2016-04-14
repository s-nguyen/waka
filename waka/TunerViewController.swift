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
    @IBOutlet weak var tunerLabel: UITextField!
    @IBOutlet weak var sharpBar: UIProgressView!
    @IBOutlet weak var flatBar: UIProgressView!
    
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
    
    private func wakaTuneStop() {
        
    }
    
    //TODO: Let the pitch / frequency stay longer than 0.03 seconds so user can see properly
    
    func tunerDidUpdate(wakaTuner: Tuner, output: TunerOutput) {
        //Get Data from here. output.sutff
        var cents : Float
        if output.amplitude < 0.010 {
            //When no sound from instrument is detected
            cents = 0
            flatBar.progress = 0
            sharpBar.progress = 0
        }
        else {
            let desiredFrequency = output.frequency - output.distance
            print(desiredFrequency)
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

    

}
