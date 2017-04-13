//
//  ContryApiModel.swift/Users/Rishikesh
//  IMOnline
//
//  Created by pradnya on 10/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.


import Foundation
import Alamofire


class ContryApiModel:NSObject{
    
    
    func fetCountryList()
    {
        Alamofire.request("https://mobility-stg2.ingrammicro.com/Dispatcher/Countrylist/?country=&ccd=EN&lang=en&bnr=&knr=&uid=&sid=&AGENT=iOS&LANGCODE=en&DEVICE=iPhone&OSVERSION=10.2&CONNECTIONTYPE=WIFI&APPVERSION=3.0").responseString { response in

            print("Success: \(response.result.isSuccess)")
            
            print("Response String: \(response.result.value!)")
    
        }
    
    }
   
   
    
}
