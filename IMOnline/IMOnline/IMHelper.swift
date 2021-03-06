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

  class  func setCookie(domain: String, path: String,name:String,value:String,secure:Bool,expires:Date,url:String) {
    print("domain \(domain) path \(path)  name \(name)  value \(value) secure \(secure)  expires \(expires)  url \(url)")
    let cookieProps: [HTTPCookiePropertyKey : Any] = [
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: name,
            HTTPCookiePropertyKey.value: value,
            HTTPCookiePropertyKey.secure: false,
            HTTPCookiePropertyKey.expires: expires
        ]
        
        if let cookie = HTTPCookie(properties: cookieProps) {
            
            print(cookie)
            HTTPCookieStorage.shared.setCookie(cookie)
            WebServiceManager.sharedInstance.user.sessionCookie = cookie
        }
        
    }
    
    class func timestamp() -> String {
        var dateFormatter: DateFormatter?
        if dateFormatter == nil {
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "yyyyMMddHHmmss"
        }
        return (dateFormatter?.string(from: Date()))!
    }
    
   class func fetchCookieArray(response:HTTPURLResponse) -> [HTTPCookie]{
        var cookieArray = [HTTPCookie]()
        
        let httpResponse: HTTPURLResponse = response
        
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: httpResponse.allHeaderFields as! [String : String], for: (response.url!))
        
        
        for cookie in cookies{
            var newcookie : HTTPCookie!
            //   var textRange, altCookie : NSRange!;
            let nameck = cookie.name
            let textRange = nameck.range(of: "Mobile")
            // let cookiprop = cookie.properties! as! NSDictionary
            //print(cookiprop.value(forKey: "Path") as! String)
            if(textRange != nil){
                
                if(cookie.path != "/"){
                    let str = self.extractCookieVal(path: cookie.path, name: "IMGlobalWebAuthCookieMobile")
                    let dict : NSMutableDictionary = NSMutableDictionary.init(dictionary: cookie.properties!)
                    dict.setValue("IMGlobalWebAuthCookieMobile", forKey: "name")
                    dict.setValue(str, forKey: "value")
                    dict.setValue("/", forKey: "path")
                    // newcookie = cookie
                    newcookie = HTTPCookie.init(properties: dict as! [HTTPCookiePropertyKey : Any])
                    cookieArray.append(newcookie!)
                    //cookieArray.add(newcookie)
                }
                
            }else{
                print("cookie in array \(cookie)")
                cookieArray.append(cookie)
                // cookieArray.add(cookie)
            }
            
        }
        print(cookieArray)
        return cookieArray
        
    }
    
    
    class func extractCookieVal(path:String,name:String) -> String{
        
        
        var val = "";
        //var textRange:NSRange;
        let textRange = path.lowercased().range(of: name.lowercased())
        if(textRange != nil)
        {
            let index: Int = path.distance(from: path.startIndex, to: textRange!.lowerBound)
            // var pos = textRange?.lowerBound + textRange?.upperBound+1;
            val = path.substring(with: textRange!)
            
        }
        return val;
        
    }
    class func getURIforContractName(_ _name: String) -> String {
       // DLog("look for contract %@", _name)
        if let cnt = WebServiceManager.sharedInstance.operationss{
        for op: IMOperation in WebServiceManager.sharedInstance.operationss as! [IMOperation] {
            if (op.contractName == _name) && (op.appVersion == IMHelper.appVersion()) {
               // DLog("[* found operation '%@' for Appversion %@]", op.contractName, op.appVersion)
                return op.contractURI
            }
            }}
        return ""
    }
    class func documentsDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
   class func fetchSessionCookie(request:HTTPURLResponse) -> HTTPCookie{
//        var cookie : HTTPCookie!
//        
//        let array = NSArray.init(object: request.allHeaderFields) as! NSArray
//        var selectedCountry = "MX"
//        for cookie in array{
//            
//            var textRange, altCookie : NSRange!;
//            //textRange =
//        }
//        
//        
//        return cookie;
    let _cookiesAr = NSArray.init(object: request.allHeaderFields) as! [HTTPCookie]
    var cookie: HTTPCookie?
    var selectedCountry: String = WebServiceManager.sharedInstance.countrySelection.countryId
    var resAr = NSMutableArray()
    for cookie:HTTPCookie in _cookiesAr{
        var textRange = NSRange()
        textRange = (cookie.name as NSString).range(of: "SMIDENTITY")
        if (textRange.location != NSNotFound) {
          //  DLog("%@", cookie.properties)
            if cookie.domain.hasPrefix(".ingrammicro.com") {
                var val: String? = extractCookieVal(path: cookie.domain, name: "smsession")
                var cookieProperties = [AnyHashable: Any]()
                cookieProperties[HTTPCookiePropertyKey.name] = "SMSESSION"
                cookieProperties[HTTPCookiePropertyKey.value] = val
                cookieProperties[HTTPCookiePropertyKey.domain] = ".ingrammicro.com"
                cookieProperties[HTTPCookiePropertyKey.path] = "/"
                cookieProperties[HTTPCookiePropertyKey.version] = "0"
                cookieProperties[HTTPCookiePropertyKey.expires] = Date().addingTimeInterval(2629743)
                var _cookie = HTTPCookie(properties: cookieProperties as! [HTTPCookiePropertyKey : Any])
                resAr.add(cookie)
                break
            }
        }
        else {
            resAr.add(cookie)
        }
        
        
    }
    return cookie!
    }
    class func trimString(_ _str: String) -> String {
        return _str.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    class func isNumeric(_ _str: String) -> Bool {
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: _str)
        if number != nil {
            return true
        }
        return false
    }
    
    class func getUUID() -> String {
//        var anyStoringError: Error? = nil
//        let storedValue: String? = try? SFHFKeychainUtils.getPasswordForUsername("User Name", andServiceName: "Ingram")
//        if storedValue != nil {
//            return storedValue!
//        }
//        else {
//            let theUUID: CFUUIDRef = CFUUIDCreate(nil)
//            let string: CFString = CFUUIDCreateString(nil, theUUID)
//            return (string as? String)!
//        }
        
    return ""
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
