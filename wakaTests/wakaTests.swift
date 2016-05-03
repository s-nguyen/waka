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
    }
    
    
}
