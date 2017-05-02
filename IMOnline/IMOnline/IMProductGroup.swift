//
//  IMProductGroup.swift
//  IMOnline
//
//  Created by pradnya on 18/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class IMProductGroup: NSObject {
    var name:String?
    var prodId:Int?
    
    init(string _name: String, _prodId: Int) {
        
        name = _name
        prodId = _prodId
    }
    
    override init() {
        
    }
    
}
