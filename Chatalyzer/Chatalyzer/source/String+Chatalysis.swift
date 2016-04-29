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

    ///  Parses string looking for items of interest
    ///
    ///  - returns: String which is a JSON dictionary. Will be empty if string has no identifiable content items.
    public func chatalysis() -> String {
        var contents = [NSString: AnyObject]()
        
        // TODO: Populate content
        contents.removeAll()
        
        do {
            return try contents.jsonString([.PrettyPrinted])
        } catch let error {
            print(error)
            return "{\n\n}"
        }
    }
}
