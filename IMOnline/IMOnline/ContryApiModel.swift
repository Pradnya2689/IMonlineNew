//
//  ContryApiModel.swift/Users/Rishikesh
//  IMOnline
//
//  Created by pradnya on 10/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.


import Foundation
import Alamofire


class ContryApiModel:NSObject{
    
    var countryArr = NSMutableArray()
    func fetCountryList()
    {
        Alamofire.request("https://mobility-stg2.ingrammicro.com/Dispatcher/Countrylist/?country=&ccd=EN&lang=en&bnr=&knr=&uid=&sid=&AGENT=iOS&LANGCODE=en&DEVICE=iPhone&OSVERSION=10.2&CONNECTIONTYPE=WIFI&APPVERSION=3.0").responseString { response in

            print("Success: \(response.result.isSuccess)")
            
            print("Response String: \(response.result.value!)")
            
            let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
            print(parser.lines)
         // let parserArr = parser.lines as! []
            for object in parser.lines as! [String] {
                print(object)
               let url = object as! String
                let fullNameArr : [String] = url.components(separatedBy: ";")
//                print(fullNameArr[1])
//                self.countryArr.add(fullNameArr[1])
               
            //    let elements: [Any] = url.components(separatedBy: CharacterSet(charactersInString: ";"))
               // let elements: [String] = url.components(separatedBy: CharacterSet(CFCharacterSetAddCharactersInString(<#T##theSet: CFMutableCharacterSet!##CFMutableCharacterSet!#>, <#T##theString: CFString!##CFString!#>)))
//                let url = object.url
            }
            print(self.countryArr)
    
        }
    
    }
   
   
    
}
