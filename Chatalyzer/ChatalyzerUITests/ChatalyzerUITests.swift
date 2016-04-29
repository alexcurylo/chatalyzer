//
//  ChatalyzerUITests.swift
//  ChatalyzerUITests
//
//  Created by alex on 2016-04-28.
//  Copyright © 2016 Trollwerks Inc. All rights reserved.
//

import XCTest

class ChatalyzerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTypingIsProcessed() {
        let app = XCUIApplication()
        let tapToBeginTextField = app.textFields["Tap to begin"]
        tapToBeginTextField.tap()
        app.typeText("(smile)")
        app.buttons["Done"].tap()
        let result = app.textViews["ResultView"].value as? String
        let expected = "{\n  \"emoticons\" : [\n    \"smile\"\n  ]\n}"
        XCTAssert(result == expected, "Unexpected result \(result)")
    }
}
