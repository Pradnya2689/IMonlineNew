//
//  ResponseParser.swift
//  IMOnline
//
//  Created by pradnya on 12/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class ResponseParser: NSObject {
    var lines:NSArray!
    var response: NSString!
    
    init(responseStr:NSString) {
        
        self.response = responseStr as NSString!
        self.lines = responseStr.components(separatedBy: .newlines) as NSArray
    }
}
