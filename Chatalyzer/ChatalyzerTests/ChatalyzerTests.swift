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
    
    func testPerformanceExample() {
        let measureString = "testPerformanceExample"
        self.measureBlock {
            for _ in 0...10000 {
                measureString.chatalysis()
            }
        }
    }
}
