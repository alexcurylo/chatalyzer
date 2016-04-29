//
//  ChatalyzerTests.swift
//  ChatalyzerTests
//
//  Created by alex on 2016-04-28.
//  Copyright © 2016 Trollwerks Inc. All rights reserved.
//

import XCTest
@testable import Chatalyzer

func XCTAssertThrows<T>(@autoclosure expression: () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        try expression()
        XCTFail("No error to catch! - \(message)", file: file, line: line)
    } catch {
    }
}

func XCTAssertNoThrow<T>(@autoclosure expression: () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        try expression()
    } catch let error {
        XCTFail("Caught error: \(error) - \(message)", file: file, line: line)
    }
}

class ChatalyzerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testJsonStringThrowsNotValidObject() {
        let invalid = ["view" as NSString: UIView() as AnyObject]
        XCTAssertThrows(try invalid.jsonString())
    }

    func testJsonStringDoesNotThrowValidObject() {
        let valid = ["key" as NSString: "Value" as AnyObject]
        XCTAssertNoThrow(try valid.jsonString())
    }

    func testChatalysisHandlesEmptyString() {
        let emptyString = ""
        let chatalysis = emptyString.chatalysis()
        XCTAssert(chatalysis == "{\n\n}", "Unexpected chatalysis \(chatalysis)")
    }

    func testChatalysisHandlesNonEmptyString() {
        let nonEmptyString = "a string"
        let chatalysis = nonEmptyString.chatalysis()
        XCTAssert(chatalysis == "{\n\n}", "Unexpected chatalysis \(chatalysis)")
    }
    
    func testLinksFindsAllLinks() {
        if let links = "test.com test.com test.com".links(unique: false) {
            XCTAssert(links.count == 3, "Unexpected links \(links)")
        } else {
            XCTFail("Failed to find any links!")
        }
    }
   
    func testChatalysisFindsUniqueLink() {
        let uniqueTestResult = "{\n  \"links\" : [\n    {\n      \"title\" : \"WIP\",\n      \"url\" : \"http:\\/\\/test.com\"\n    }\n  ]\n}"
        
        let test1 = "test.com".chatalysis()
        XCTAssert(test1 == uniqueTestResult, "Unexpected chatalysis \(test1)")
        
        let test3 = "test.com test.com test.com".chatalysis()
        XCTAssert(test3 == uniqueTestResult, "Unexpected chatalysis \(test3)")
    }

    func testPerformanceExample() {
        let measureString = "test.com test.edu test.ca"
        self.measureBlock {
            for _ in 0...1000 {
                measureString.chatalysis()
            }
        }
    }
}
