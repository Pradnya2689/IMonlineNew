//
//  ResponseParser.swift
//  IMOnline
//
//  Created by pradnya on 12/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class ResponseParser: NSObject
{
    var lines:NSArray!
    var response: NSString!
    
    init(responseStr:NSString)
    {
        self.response = responseStr as NSString!
        self.lines = responseStr.components(separatedBy: .newlines) as NSArray
    }
    
    func countries() -> [Any] {
        
        var countries = [Any]()
        let elements : [String] = (self.lines[0] as AnyObject).components(separatedBy: ";")
     //   let elements: [Any] =  self.lines.componentsSeparatedByCharactersInSet(";")
        
        for country in self.lines
        {
            print(country)
        }

        return countries
    }
    
    func myArrayFunc() -> Array<String>
    {
        var countries = [Any]()
        let elements : [String] = (self.lines[0] as AnyObject).components(separatedBy: ";")
        //   let elements: [Any] =  self.lines.componentsSeparatedByCharactersInSet(";")
        
        for country in self.lines
        {
             let elements : [String] = (country as AnyObject).components(separatedBy: ";")
            
           
            
            
            let empty : String = elements[0]
            if (empty.characters.count == 0)
            {
                print("empty")
            }
            else
            {
                if elements.count < 8
                {
                    break
                }
              let countryadd = elements[1]
                let empty : String = countryadd.replacingOccurrences(of: "\"", with: "")
                countries.append(empty)
            }
            
           print(countries)
//            if ( countryadd = elements[1])
//            {
//                
            
//            }
            
        }
        
        return countries as! Array<String>
    }
}

