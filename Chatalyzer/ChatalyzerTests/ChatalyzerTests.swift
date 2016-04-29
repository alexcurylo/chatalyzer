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
    
    func testMentionsFindsAllMentions() {
        if let mentions = "@mention1 @mention1 @mention1".mentions(unique: false) {
            XCTAssert(mentions.count == 3, "Unexpected mentions \(mentions)")
        } else {
            XCTFail("Failed to find any mentions!")
        }
    }

    func testMentionsStripsUnmentionables() {
        let mentions1 = "@mention1".mentions()
        XCTAssertNotNil(mentions1, "Failed to find mention1")
        XCTAssert( mentions1! == ["mention1"], "Unexpected mentions \(mentions1!)")

        let mentions2 = "@mention2;".mentions()
        XCTAssertNotNil(mentions2, "Failed to find mention2")
        XCTAssert( mentions2! == ["mention2"], "Unexpected mentions \(mentions2!)")

        let mentions3 = "@mention3 @mention3.4.5".mentions()
        XCTAssertNotNil(mentions3, "Failed to find mention3")
        XCTAssert( mentions3! == ["mention3"], "Unexpected mentions \(mentions3!)")
    }

    func testMentionsFindsUniqueMentions() {
        if let mentions = "@mention1 @mention1 @mention2".mentions(unique: true) {
            XCTAssert(mentions.count == 2, "Unexpected mentions \(mentions)")
        } else {
            XCTFail("Failed to find any mentions!")
        }
    }
    
    func testMentionsRejectsNonMentions() {
        if let mentions = "@ ;@ user@mail.com".mentions() {
            XCTFail("Unexpected mentions \(mentions)")
        }
    }
    
    func testEmoticonsFindsAllEmoticons() {
        let emoticons1 = "(em1)".emoticons()
        XCTAssertNotNil(emoticons1, "Failed to find em1")
        XCTAssert( emoticons1! == ["em1"], "Unexpected emoticons \(emoticons1!)")
        
        let emoticons2 = "@}((em2);".emoticons()
        XCTAssertNotNil(emoticons2, "Failed to find em2")
        XCTAssert( emoticons2! == ["em2"], "Unexpected emoticons \(emoticons2!)")
        
        let emoticons3 = "( (em3) )".emoticons()
        XCTAssertNotNil(emoticons3, "Failed to find em3")
        XCTAssert( emoticons3! == ["em3"], "Unexpected emoticons \(emoticons3!)")
    }
    
    func testEmoticonsFindsUniqueEmoticons() {
        if let emoticons = "(em1) (em1) (2em2)".emoticons(unique: true) {
            XCTAssert(emoticons.count == 2, "Unexpected emoticons \(emoticons)")
        } else {
            XCTFail("Failed to find any emoticons!")
        }
    }

    func testEmoticonsRejectsNonEmoticons() {
        if let emoticons = "This () (brack(a!) (a.b) )( (manymorethan15charactersinthis)".emoticons() {
            XCTFail("Unexpected emoticons \(emoticons)")
        }
    }
   
    func testLinksFindsAllLinks() {
        if let links = "test.com test.com test.com".links(unique: false) {
            XCTAssert(links.count == 3, "Unexpected links \(links)")
        } else {
            XCTFail("Failed to find any links!")
        }
    }
   
    func testLinksFindsUniqueLink() {
        if let links = "test.com test.com test.com".links(unique: true) {
            XCTAssert(links.count == 1, "Unexpected links \(links)")
        } else {
            XCTFail("Failed to find any links!")
        }
    }

    func testPerformanceExample() {
        // Let's just lampshade the performance of naive title lookup.
        let measureString = "@mention (emoticon)"
        self.measureBlock {
            for _ in 0...1000 {
                measureString.chatalysis()
            }
        }
    }
}
