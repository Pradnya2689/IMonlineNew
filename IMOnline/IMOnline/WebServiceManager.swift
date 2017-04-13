//
//  WebServiceManager.swift
//  IMOnline
//
//  Created by pradnya on 12/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Alamofire
class WebServiceManager: NSObject {
    static let sharedInstance = WebServiceManager()
    
    func loginWebservice(){
        
        let url = URL(string: "https://mobility-stg.ingrammicro.com/1.0.0.0/Session/Login/?DEVICE=iPhone&AGENT=iOS&OSVERSION=10.2&CONNECTIONTYPE=WIFI&APPVERSION=3.0&lang=EN&country=MX&deviceid=ABD979BE-11F6-487F-AAE1-EECE1A5144A1&saveid=false&securitycode=&resendcode=false")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let parameters = "username:pradnya.dongre@ingrammicro.com\npassword:1Loveingram"
        
        urlRequest.httpBody = parameters.data(using: String.Encoding.utf8)
        
        urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
        
        Alamofire.request(urlRequest)
            .responseString { response in
                print("Response String: \(response.result.value)")
                let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                print(parser.lines)
            }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }
    }
    

}
