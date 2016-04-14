//
//  TabBarController.swift
//  waka
//
//  Created by Uxi on 3/9/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import UIKit
import PermissionScope


class TabBarController: UITabBarController {

    private let micPermissions = PermissionScope()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        micPermissions.addPermission(MicrophonePermission(), message: "Waka would like to use the microphone")
        
        micPermissions.headerLabel.text = "Microphone needs to be enable!"
        micPermissions.bodyLabel.text = "Please accept this to get started"
        micPermissions.closeButton.hidden = true //Hide Close Button
        micPermissions.show({ (finished, results) -> Void in
            let result = results.filter({ $0.type == .Microphone })[0]
            if result.status != .Authorized {
                self.showMicrophoneAccessAlert()
            }
            }, cancelled: { (results) -> Void in
                self.showMicrophoneAccessAlert()
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func showMicrophoneAccessAlert() {
        let alert = UIAlertController(title: "Microphone Access", message: "Waka requires access to your microphone; please enable access in your device's settings.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
