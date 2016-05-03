//
//  wakaTests.swift
//  wakaTests
//
//  Created by WellMet on 2/24/16.
//  Copyright © 2016 WellMet. All rights reserved.
//

import XCTest
@testable import waka


class wakaTests: XCTestCase {
    
    var metronomeVC: MetronomeViewController!
    var filterVC: FilterViewController!
    var tunerVC: TunerViewController!
    
    let metronomeSB = UIStoryboard(name: "Main", bundle: nil)
    let filterSB = UIStoryboard(name: "Main", bundle: nil)
    let tunerSB = UIStoryboard(name: "Main", bundle: nil)
    
    override func setUp() {
        super.setUp()

        metronomeVC = metronomeSB.instantiateViewControllerWithIdentifier("MetronomeID") as! MetronomeViewController
        filterVC = filterSB.instantiateViewControllerWithIdentifier("FilterID") as! FilterViewController
        tunerVC = tunerSB.instantiateViewControllerWithIdentifier("TunerID") as! TunerViewController
        
        let _ = metronomeVC.view
        let _ = filterVC.view
        let _ = tunerVC.view
    }
    /*
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    */
 
    //Compare Microphone input to internal databases
    
    //Metronome Test
    
    func testQuarterPressed() {
        metronomeVC.quarterButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssertEqual(metronomeVC.metronome.meter, 1)
        
        metronomeVC.eigthButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssertEqual(metronomeVC.metronome.meter, 2)
        
        metronomeVC.sixteenthButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssertEqual(metronomeVC.metronome.meter, 4)
        
    }
    
    //Tuner Test
    
    //FilterTest
    func testFilter() {
        //Verify Functionality
        
        //pickerView test
        XCTAssertEqual(filterVC.filter.filterNum, 0) // default value
        filterVC.pickerView.element.adjustToPickerWheelValue("Echo")
        XCTAssertEqual(filterVC.filter.filterNum, 1) // echo selecting
        filterVC.pickerView.element.adjustToPickerWheelValue("Reverb")
        XCTAssertEqual(filterVC.filter.filterNum, 2) // reverb selecting
        
        /*
        // reference https://www.raywenderlich.com/61419/ios-ui-testing-with-kif
         
        //speed stepper test
        XCTAssertEqual(filterVC.filter.speed, 1.0) // default value
        //increase once
        XCTAssertEqual(filterVC.filter.speed, 1.5) // increase speed by 0.5
        //increase once
        XCTAssertEqual(filterVC.filter.speed, 2.0) // increase speed by 0.5
        //decrease once
        XCTAssertEqual(filterVC.filter.speed, 1.5) // decrease speed by 0.5
        
        //pitch stepper test
        XCTAssertEqual(filterVC.filter.pitch, 0.0) // default value
        //increase once
        XCTAssertEqual(filterVC.filter.pitch, 1.0) // increase pitch by 1
        //increase once
        XCTAssertEqual(filterVC.filter.pitch, 2.0) // increase pitch by 1
        //decrease once
        XCTAssertEqual(filterVC.filter.pitch, 1.0) // decrease pitch by 1
        */
        
        //play button enablity test
        XCTAssertEqual(filterVC.playButton.enabled, false) // default value
        
        //recording test
        XCTAssertEqual(filterVC.filter.recording, false) // default value
        filterVC.recordButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssertEqual(filterVC.filter.recording, true) // recording state
        filterVC.recordButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssertEqual(filterVc.filter.recording, false) // recording done
        
        //playing test
        XCTAssertEqual(filterVC.filter.playing, false) // default value
        filterVC.playButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssertEqual(filterVC.filter.playing, true) // playing
        filterVC.playButton.sendActionsForControlEvents(.TouchUpInside)
        XCTAssertEqual(filterVC.filter.playing, false) // playing done
        
        
    }
    
    
}
