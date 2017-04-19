//
//  IMUser.swift
//  IMOnline
//
//  Created by pradnya on 13/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class IMUser: NSObject {
     static let sharedInstance = IMUser()
    
    var countryCode:String?
    var language:String?
    var userId : String?
    var bnr : String?
    var customerNumber : String?
    var password : String?
    var sessionId : String?
    // var countryCode : String?
    
    
    override init() {
        
//        if super.init() {
//            
//        }
    }
    
}
