//
//  IMHelper.swift
//  IMOnline
//
//  Created by inpanr07 on 13/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import CoreFoundation

class IMHelper: NSObject {
    
    
    class func appVersion() -> String {
        //return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        return "3.0"
    }
    
    class func deviceModel() -> String {
        return UIDevice.current.model.replacingOccurrences(of: " ", with: "")
    }
    
    class func currentOS() -> String {
        return UIDevice.current.systemVersion
    }
    
    class func empty(forNil s: String) -> String {
        return (s.characters.count == 0) ? "" : s
    }

    
    
   }

extension String {
    
    func urlEncode() -> String {
//        let result: String? = (CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (self as? CFString), nil, ":/?#[]@!$&’()*+,;=∼" as CFString!, CFStringBuiltInEncodings.isoLatin1.rawValue) as? String)
        
        
        let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (self as? CFString), nil,
                                                             ":/?#[]@!$&’()*+,;=∼" as CFString!,
                                                             CFStringBuiltInEncodings.isoLatin1.rawValue)
        
        
        
        
        return result! as String
    }
}
