//
//  FilterViewController.swift
//  waka
//
//  Created by Uxi on 3/9/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation

class FilterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pitchLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView! //IBOutlet for pickerView

    
    
    
    //create instance of filter class
    var filter = Filter()
    
    //picker view data set
    var pickerDataSource = ["None", "Echo", "Reverb"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set pickerView dataSource and delegate
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        self.playButton.enabled = false;
        self.saveButton.enabled = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //pickerView data source control
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)->String?{
        
        return pickerDataSource[row]
    }
    
    
    //pickerView action control
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //update filter number
        filter.filterNum = row
        
    }


    @IBAction func recordPressed(sender: UIButton) {
        if(filter.recording){
            filter.recording = !filter.recording
            filter.stopRecord()
            recordButton.setTitle("Re-Record", forState: .Normal)
            
            saveButton.enabled = true
            playButton.enabled = true
        }
        else{
            filter.recording = !filter.recording
            filter.startRecord()
            recordButton.setTitle("Done", forState: .Normal)
            
            saveButton.enabled = false
            playButton.enabled = false
        }
    }
    
    @IBAction func playPressed(sender: AnyObject) {
        if(filter.playing){
            filter.playing = !filter.playing
            filter.stopPlaying()
            playButton.setTitle("Play", forState: .Normal)
            
            recordButton.enabled = true
            saveButton.enabled = true
            
        }else{
            filter.playing = !filter.playing
            filter.startPlaying()
            playButton.setTitle("Stop", forState: .Normal)
            
            recordButton.enabled = false
            saveButton.enabled = false
        }
        
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        recordButton.enabled = true
        playButton.setTitle("Play", forState: .Normal)
    }
    
    
    @IBAction func speedPressed(sender: UIStepper) {
        
        self.speedLabel.text="x"+String(sender.value)
        filter.speed = Float(sender.value)
        
        
    }
    
    
    @IBAction func pitchPressed(sender: UIStepper) {
        
        if(sender.value<0){
            self.pitchLabel.text=String(Int(sender.value))+" Octave"
        }else{
            self.pitchLabel.text="+"+String(Int(sender.value))+" Octave"
        }
        filter.pitch = Float(sender.value)
    }
    
    @IBAction func savePressed(sender: UIButton) {
        if(filter.filterNum==0){
            self.view.backgroundColor = UIColor.redColor()
        }else if(filter.filterNum==1){
            self.view.backgroundColor = UIColor.blueColor()
        }else{
            self.view.backgroundColor = UIColor.greenColor()
        }
        
    }
    
    @IBAction func emailPressed(sender: UIButton) {
        let emailer = MFMailComposeViewController()
        emailer.mailComposeDelegate = self
        
        //subject
        emailer.setSubject("Sending from Waka")
        emailer.setMessageBody("sup m8", isHTML: false)
        
        //attach latest recorded data
        if let fileData = NSData(contentsOfFile: filter.currentFilePath) {
            emailer.addAttachmentData(fileData, mimeType: "audio/x-caf", fileName: "recording.caf")
        }
        
        //switch view
        self.presentViewController(emailer, animated: true, completion: nil)
    }
 
    
    //return back to original view
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
