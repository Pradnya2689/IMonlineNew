//
//  WebServiceManager.swift
//  IMOnline
//
//  Created by pradnya on 12/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Alamofire

class IMCountry : NSObject
{
    
     static let sharedInstance = IMCountry()
    
    
    var countryId: String = ""
    var name: String = ""
    var languageCode: String = ""
    var environmentType: String = ""
    var decimalSeprator: String = ""
    var thousandSeprator: String = ""
    var currencySymbol: String = ""
    
public func country(withId _id: String, code _code: String, name _name: String, env _env: String, currency _currency: String, decimalSeprator _decimalSeprator: String, thousandSeprator _thousandSeprator: String) -> Any {
    let country = IMCountry()
    country.countryId = _id
    country.name = _name
    country.languageCode = _code
    country.environmentType = _env
    country.decimalSeprator = _decimalSeprator
    country.thousandSeprator = _thousandSeprator
    country.currencySymbol = _currency
    return country
}
}

class WebServiceManager: NSObject {
    static let sharedInstance = WebServiceManager()
    var countryArr = NSMutableArray()
    func fetchCountries(withCompletionBlock successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: Void) -> Void) {
 
        
       
        let params: [AnyHashable: Any]? = [
            "LANGCODE" : (NSLocale.preferredLanguages[0] as? [AnyHashable: Any])
        ]
        self.performRESTCall(baseURL: Constants.URL_GET_COUNTRY_LIST, httpMethod: "GET", parameters: params as! [NSObject : AnyObject], successBlock: {(_ responseText: String) -> Void in
            print(responseText)
        }, failedBlock: failedBlock)
        
        
    }
   
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
    
    
    func performRESTCall(baseURL: String, httpMethod: String, parameters: [NSObject : AnyObject], successBlock: @escaping (_ response: String) -> Void, failedBlock: @escaping () -> Void) {
        //    NSLog(@"Received Parameters: %@",parameters);
        self.performRESTCall(baseURL, httpMethod: (httpMethod as! String), parameters: parameters, successBlock: successBlock, failedBlock: failedBlock, showLoginViewIfSessionInvalid: true)
    }

    func performRESTCall(_ baseURL: String, httpMethod: String, parameters: [AnyHashable: Any], successBlock: @escaping (_ response: String) -> Void, failedBlock: @escaping () -> Void, showLoginViewIfSessionInvalid: Bool) {
        performRESTCall(baseURL, httpMethod: httpMethod, parameters: parameters, successBlock: successBlock, failedBlock: failedBlock, showLoginViewIfSessionInvalid: showLoginViewIfSessionInvalid, contentType:"application/mobile")
    }
    
    func performRESTCall(_ baseURL: String, httpMethod: String, parameters: [AnyHashable: Any], successBlock: @escaping (_ response: String) -> Void, failedBlock: @escaping () -> Void, showLoginViewIfSessionInvalid: Bool, contentType: String) {
        
        
//        successBlock = successBlock
//        failedBlock = failedBlock
        var _netWorkFlag: Bool = true
        
        var addedParameters = [String: String]()
        if parameters != nil {
            for (k, v) in parameters { addedParameters.updateValue(v as! String, forKey: k as! String) }
        }
        addedParameters["AGENT"] = "iOS"
        addedParameters["APPVERSION"] = IMHelper.empty(forNil: IMHelper.appVersion())
        addedParameters["DEVICE"] = IMHelper.deviceModel()
        addedParameters["OSVERSION"] = IMHelper.empty(forNil: IMHelper.currentOS())
        addedParameters["CONNECTIONTYPE"] = "WIFI"
        
        
//        let authorisationParameters: String = "country=&ccd=EN&lang=en&bnr=&knr=&uid=&sid="
//       let serviceParameters: String = "&AGENT=iOS&LANGCODE=en&DEVICE=iPhone&OSVERSION=10.2&CONNECTIONTYPE=WIFI&APPVERSION=3.0"
        
        let authorisationParameters: String = self.authorisationParametersREST()
        print(addedParameters)
        let urlString: String = self.serviceParameters(fromDictionary: addedParameters as! [String : String])
        
        // https://mobility-stg2.ingrammicro.com/Dispatcher/Countrylist/?country=&ccd=EN&lang=en&bnr=&knr=&uid=&sid=&AGENT=iOS&LANGCODE=en&DEVICE=iPhone&OSVERSION=10.2&CONNECTIONTYPE=WIFI&APPVERSION=3.0
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        
        
        urlRequest.httpMethod = httpMethod
        
      //  let parameters = "username:pradnya.dongre@ingrammicro.com\npassword:1Loveingram"
        
       // urlRequest.httpBody = parameters.data(using: String.Encoding.utf8)
        
        urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
        
        Alamofire.request(urlRequest)
            .responseString { response in
                print("Response String: \(response.result.value)")
                let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                successBlock(parser.response as String)
                print(parser.lines)
            }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }

        
        
        
    }
    
    func authorisationParametersREST() -> String {
    
        let language: String? = (NSLocale.preferredLanguages[0] as? String)
        //language = @"en-US";
        let languageDic: [AnyHashable: Any] = NSLocale.components(fromLocaleIdentifier: language!)
        //languageDic will have the needed components
        let countryCode: String? = (languageDic["kCFLocaleCountryCodeKey"] as? String)
        //countryCode = "US"
        let languageCode: String? = (languageDic["kCFLocaleLanguageCodeKey"] as? String)
        //languageCode = "en"
    print(IMCountry.sharedInstance.countryId)
        print(IMUser.sharedInstance.language ?? "")
//        print(IMUser.sharedInstance.bnr)
        
//        print(IMUser.sharedInstance.customerNumber)
//        print(IMUser.sharedInstance.userId)
//        print(IMUser.sharedInstance.sessionId)
        
        return "country=\(IMHelper.empty(forNil: IMCountry.sharedInstance.countryId))&ccd=\(IMHelper.empty(forNil: IMUser.sharedInstance.language ?? ""))&lang=\(languageCode)&bnr=\(IMHelper.empty(forNil: IMUser.sharedInstance.bnr ?? ""))&knr=\(IMHelper.empty(forNil: IMUser.sharedInstance.customerNumber ?? ""))&uid=\(IMHelper.empty(forNil: IMUser.sharedInstance.userId ?? ""))&sid=\(IMHelper.empty(forNil: IMUser.sharedInstance.sessionId ?? ""))"
    }
    
    func serviceParameters(fromDictionary dictionary: [AnyHashable: String]) -> String {
        var retval = String()
        
        for (key, obj) in dictionary
        {
           // data[key] =  "\(key), \(obj)"
            
             retval += "&\(key)=\(IMHelper.empty(forNil: obj  ).urlEncode())"
        }

                   return retval
    }
}
