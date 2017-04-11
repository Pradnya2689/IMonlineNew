//
//  ContryApiModel.swift
//  IMOnline
//
//  Created by pradnya on 10/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import Foundation
import Alamofire


class ContryApiModel:NSObject{
    
    
    func fetCountryList(){
        Alamofire.request("https://httpbin.org/get").responseString { response in
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value)")
    }
    
    }
    
}
