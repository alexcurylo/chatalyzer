//
//  String+Chatalysis.swift
//  Chatalyzer
//
//  Created by alex on 2016-04-28.
//  Copyright © 2016 Trollwerks Inc. All rights reserved.
//

import UIKit

///  Errors that can arise transcribing an array to JSON
///
///  - NotValidObject:      Contains unserializable objects
///  - SerializationFailed: dataWithJSONObject internal error encountered
///  - FormattingFailed:    String creation from data failed
///
enum JSONError: ErrorType {
    case NotValidObject
    case SerializationFailed
    case FormattingFailed
}

extension Dictionary where Key: NSObject, Value: AnyObject {
    
    ///  Convenience function for providing a JSON string
    ///
    ///  - parameter options: Pass [.PrettyPrinted] if desired
    ///
    ///  - throws: a JSONError
    ///
    ///  - returns: Stringification of dataWithJSONObject
    public func jsonString(options: NSJSONWritingOptions = []) throws -> String {
        guard NSJSONSerialization.isValidJSONObject(self) == true else {
            throw JSONError.NotValidObject
        }
        
        guard let data = try? NSJSONSerialization.dataWithJSONObject(self, options: options) else {
            throw JSONError.SerializationFailed
        }
        
        guard let chatalysis = String(data: data, encoding: NSUTF8StringEncoding) else {
            throw JSONError.FormattingFailed
        }
        
        return chatalysis
    }
}

extension String {
    
    ///  Parses string looking for items of interest: @mentions, (emoticons) and <links>
    ///
    ///  - note: In accordance with instructions "This exercise is not meant to be tricky or complex;" it is assumed that semantically distinct matches are sufficient and there is no need to guard against overlapping or nested pattern matches.
    ///
    ///  - parameter unique: Whether to remove duplicates. Assumed true.
    ///  - parameter pretty: Whether to pretty print result. Assumed true.
    ///
    ///  - returns: String which is a JSON dictionary. Will be empty if string has no identifiable content items.
    public func chatalysis(unique unique: Bool = true, pretty: Bool = true) -> String {
        var contents = [NSString: AnyObject]()
        
        contents["mentions"] = mentions(unique: unique)
        contents["emoticons"] = emoticons(unique: unique)
        contents["links"] = links(unique: unique)
        
        do {
            return try contents.jsonString(pretty ? [.PrettyPrinted] : [])
        } catch let error {
            print(error)
            return "{\n\n}"
        }
    }
    
    ///  Finds all unique @mentions in the string.
    ///  @mentions are prefixed with @ and extend to next non-word character.
    ///
    ///  - note: In accordance with instructions "This exercise is not meant to be tricky or complex;" it is assumed that all @mentions will begin with space/newline, otherwise disambiguating from email addresses and the like would be complex.
    ///  - parameter unique: Whether to remove duplicates. Assumed true.
    ///
    ///  - returns: Optional array of names @mentioned
    public func mentions(unique unique: Bool = true) -> [String]? {
        let separators = NSMutableCharacterSet.whitespaceAndNewlineCharacterSet()
        let unmentionables = NSMutableCharacterSet.alphanumericCharacterSet()
        unmentionables.invert()
        
        let words = componentsSeparatedByCharactersInSet(separators)
        
        let allMentions = words.filter {
                $0.hasPrefix("@")
            }.map {
                $0.stringByTrimmingCharactersInSet(unmentionables).componentsSeparatedByCharactersInSet(unmentionables).first ?? ""
            }.filter {
                $0.utf16.count > 0
            }
        guard allMentions.count > 0 else {
            return nil
        }

        let mentions = unique ? Array(Set(allMentions)) : allMentions
        return mentions
    }
    
    ///  Finds all unique (emoticons) in the string.
    ///  Emoticons are at most 15 parentherized alphanumeric characters.
    ///
    ///  - parameter unique: Whether to remove duplicates. Assumed true.
    ///
    ///  - returns: Optional array of (emoticon) names
    public func emoticons(unique unique: Bool = true) -> [String]? {
        var allEmoticons = [String]()
        
        let scanner = NSScanner(string: self)
        scanner.scanUpToString("(", intoString: nil)
        while !scanner.atEnd {
            scanner.scanLocation = scanner.scanLocation + 1
            var emoticon: NSString?
            if scanner.scanCharactersFromSet(NSMutableCharacterSet.alphanumericCharacterSet(), intoString: &emoticon),
                let asString = emoticon as? String where asString.utf16.count < 15 && scanner.scanString(")", intoString: nil)
                {
                allEmoticons.append(asString)
            }
            scanner.scanUpToString("(", intoString: nil)
        }
        guard allEmoticons.count > 0 else {
            return nil
        }
        
        let emoticons = unique ? Array(Set(allEmoticons)) : allEmoticons
        return emoticons
    }
    
    ///  Finds all links in the string and retrieves their titles.
    ///
    ///  - parameter unique: Whether to remove duplicates. Assumed true.
    ///
    ///  - returns: Optional array of ["url": <url>, "title": <title>]
    public func links(unique unique: Bool = true) -> [[String: String]]? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue) else {
            return nil
        }
        
        let allUrls = detector.matchesInString(self, options: .ReportCompletion, range: NSMakeRange(0, (self as NSString).length)).flatMap { $0.URL }
        guard allUrls.count > 0 else {
            return nil
        }
        
        let urls = unique ? Array(Set(allUrls)) : allUrls
        let links = urls.map {
            ["url": $0.absoluteString, "title": $0.title()]
        }
        return links
     }
}

extension NSURL {
    
    ///  Finds title of a webpage
    ///
    ///  - note: In accordance with instructions "This exercise is not meant to be tricky or complex;" it is assumed that caching and throttling of web requests are unnecessary.
    ///
    /// Those would be dramatically unsafe assumptions for a production app. The correct way to accomplish this without regard for trickiness or complexity is found at https://github.com/tryolabs/TLMetaResolver for instance.
    ///
    ///  - returns: title of the webpage or "" if not found
    public func title() -> String {
        let pattern = "(?<=\\<title\\>).*?(?=\\<\\/title\\>)"
        guard let page = try? NSString(contentsOfURL: self, encoding: NSUTF8StringEncoding),
            let regex = try? NSRegularExpression(pattern: pattern, options: [.CaseInsensitive]),
            let match = regex.firstMatchInString(page as String, options: .ReportCompletion, range: NSMakeRange(0, page.length)) else {
            return ""
        }
        
        return page.substringWithRange(match.range)
    }
}
