//
//  FilterViewController.swift
//  waka
//
//  Created by Uxi on 3/9/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import UIKit
import MessageUI

class FilterViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    //create instance of filter class
    var filter = Filter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func recordPressed(sender: UIButton) {
        if(filter.recording){
            filter.recording = !filter.recording
            filter.stopRecord()
            recordButton.setTitle("Start", forState: .Normal)
        }
        else{
            filter.recording = !filter.recording
            filter.startRecord()
            recordButton.setTitle("Stop", forState: .Normal)
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
