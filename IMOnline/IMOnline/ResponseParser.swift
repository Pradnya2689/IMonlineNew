//
//  ResponseParser.swift
//  IMOnline
//
//  Created by pradnya on 12/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class ResponseParser: NSObject
{
    var lines:NSArray!
    var response: NSString!
    
    init(responseStr:NSString)
    {
        self.response = responseStr as NSString!
        self.lines = responseStr.components(separatedBy: .newlines) as NSArray
    }
    
    func countries() -> [Any] {
        
        var countries = [Any]()
        let elements : [String] = (self.lines[0] as AnyObject).components(separatedBy: ";")
        //   let elements: [Any] =  self.lines.componentsSeparatedByCharactersInSet(";")
        
        for country in self.lines
        {
            print(country)
        }
        
        return countries
    }
    
    func myArrayFunc() -> Array<IMCountry>
    {
        var countries = [Any]()
        var countries1 = [Any]()
        let elements : [String] = (self.lines[0] as AnyObject).components(separatedBy: ";")
        //   let elements: [Any] =  self.lines.componentsSeparatedByCharactersInSet(";")
        
        for country in self.lines
        {
            let elements : [String] = (country as AnyObject).components(separatedBy: ";")
            
            
            
            
            let empty : String = elements[0]
            if (empty.characters.count == 0)
            {
                print("empty")
            }
            else
            {
                if elements.count < 8
                {
                    break
                }
                //                var country = IMCountry(id: (elements[0] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), code: (elements[3] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), name: (elements[1] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), env: (elements[4] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), currency: (elements[5] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), decimalSeprator: (elements[7] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), thousandSeprator: (elements[6] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""))
                
                //  var country = IMCountry cou
                
                var country = IMCountry().country(withId: elements[0].replacingOccurrences(of: "\"", with: ""), code: elements[3].replacingOccurrences(of: "\"", with: ""), name: elements[1].replacingOccurrences(of: "\"", with: ""), env: elements[4].replacingOccurrences(of: "\"", with: ""), currency: elements[5].replacingOccurrences(of: "\"", with: ""), decimalSeprator: elements[7].replacingOccurrences(of: "\"", with: ""), thousandSeprator: elements[6].replacingOccurrences(of: "\"", with: ""))
                //                country.country(withId: (elements[0] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), code: (elements[3] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), name: (elements[1] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), env: (elements[4] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), currency: (elements[5] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), decimalSeprator: (elements[7] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""), thousandSeprator: (elements[6] as? IMCountry)?.replacingOccurrences(of: "\"", with: ""))
                //  (country as AnyObject).countryEnvironmentType = elements[elements.count-1].replacingOccurrences(of: "\"", with: "")
                let countryadd = elements[1]
                let empty : String = countryadd.replacingOccurrences(of: "\"", with: "")
                countries.append(country)
                countries1.append(country)
            }
            
            print(countries)
            print(countries1)
            for cot in countries1
            {
                var c = cot as! IMCountry
                print(c.name)
                print(c.countryId)
                print(c.languageCode)
                print(c.environmentType)
                print(c.decimalSeprator)
                print(c.thousandSeprator)
                
            }
            
        }
        
        return countries  as! Array<IMCountry>
    }
    
    func isOutageAvailable() -> Bool {
        let outageAvailable = value(forKey: "TIER_I_STATUS") as! String
        if (outageAvailable == "\"ServiceUnavailable\"") {
            return true
        }
        else {
            return false
        }
    }
    func outageResponse() -> String {
        let outageHtml: String = createOutageHtml()
        return outageHtml
    }
    
    func createOutageHtml() -> String {
        var ms: String = ""
        for line in self.lines {
            // NSArray *elements = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
            let line = (line as AnyObject).replacingOccurrences(of: ";", with: " ")
            if (line == "TIER_I_ERRORMESSAGE") || (line as NSString).range(of: "TIER_").location != NSNotFound {
                continue
            }
            ms += line
        }
        return ms
    }
    
    func validateLogin() -> NSString{
        
        if(self.lines.count <= 0){
            return ""
        }
        var firstLine: String? = (lines[0] as? String)
        //DLog("** validateLogin %@", firstLine)
        //Testcase: firstLine = @"Failure;  ( 1909 ccountLocked - (id:stage1be5@im.com)";
        var elements: [Any]? = firstLine?.components(separatedBy: ";")
        if (elements?.count)! < 2 {
            return ""
        }
        var msg = elements?[0] as! String
        if("SUCCESS" != msg.uppercased())
        {
            var errorDisc: String? = (lines[6] as? String)
            var errorDiscStrElements: [Any]? = errorDisc?.components(separatedBy: "=")
            var errorDiscription: String = ""
            if (errorDiscStrElements?.count)! > 0 {
                errorDiscription = (errorDiscStrElements?[1] as? String)!
            }
            var errorCodeStr: String? = (lines[10] as? String)
            if (errorCodeStr as? NSString)?.range(of: "9999").location != NSNotFound {
                return "\(errorDiscription),\(errorCodeStr)" as! NSString
            }
            return getLoginErrMessage(_errStr: elements![1] as! NSString)
        }
        return ""
    }
    
    func getLoginErrMessage(_errStr:NSString) -> NSString{
        var strErrMessage : NSString = NSLocalizedString("General Login Error Message", comment: "login failed error message") as NSString
        if _errStr != nil
        {
            if (_errStr as NSString).range(of: "1326").location != NSNotFound {
                strErrMessage = NSLocalizedString("Benutzerdaten oder Passwort falsch.", comment: "login failed error message") as NSString
                
            }
            if (_errStr as NSString).range(of: "1909").location != NSNotFound {
                strErrMessage = NSLocalizedString("Zugang gesperrt.", comment: "Account locked") as NSString
                return strErrMessage
            }
            if (_errStr as NSString).range(of: "1331").location != NSNotFound {
                strErrMessage = NSLocalizedString("Zugang deaktiviert.", comment: "Account disabled") as NSString
                return strErrMessage
            }
            if (_errStr as NSString).range(of: "1793").location != NSNotFound {
                strErrMessage = NSLocalizedString("Zugang ist abgelaufen.", comment: "Account expired") as NSString
                return strErrMessage
            }
            if (_errStr as NSString).range(of: "1330").location != NSNotFound {
                strErrMessage = NSLocalizedString("Passwort ist abgelaufen.", comment: "Password expired") as NSString
                return strErrMessage
                
            }
            if (_errStr as NSString).range(of: "1907").location != NSNotFound {
                strErrMessage = NSLocalizedString("Passwort muss geändert werden.", comment: "Password must change") as NSString
                return strErrMessage
            }
            if (_errStr as NSString).range(of: "9999").location != NSNotFound {
                strErrMessage = NSLocalizedString("Show two factor auth", comment: "Show two factor auth") as NSString
                return strErrMessage
            }
        }
        return strErrMessage;
        
    }
    
    
    func canLogin() -> Bool {
        return ("true" == self.valueforSeparatedKey(key: "LOGIN").lowercased())
    }
    
    func canAccessTracking() -> Bool {
        return ("true" == self.valueforSeparatedKey(key: "TRACKING"))
    }
    func canOrder() -> Bool {
        return ("true" == self.valueforSeparatedKey(key: "ORDER"))
    }
    func isAdmin() -> Bool {
        return ("true" == self.valueforSeparatedKey(key: "ADMIN"))
    }
    func isStatesAvailable() -> Bool {
        if self.valueforSeparatedKey(key:"STATES_ AVAILABLE").compare("TRUE", options: .caseInsensitive) == .orderedSame {
            return true
        }
        return false
        //return [@"true" isEqualToString:[self valueForSeparatedKey:@"STATES_ AVAILABLE"]];
    }
    
    func isDropshipAllowed() -> Bool {
        let dropShipAllowed: String = self.valueforSeparatedKey(key:"ISDROPSHIPALLOWED")
        if dropShipAllowed.compare("true", options: .caseInsensitive) == .orderedSame {
            return true
        }
        else {
            return false
        }
    }
    func valueforSeparatedKey( key: String) -> String {
        let prefix: String = "\(key);"
        for line:String in self.lines as! [String] {
            if line.hasPrefix(prefix) {
                let elements: [Any] = line.components(separatedBy: ";")
                return elements[1] as! String
            }
            return ""
        }
        return ""
    }
        func successREST() -> Bool {
            return ("\"OK\"" == self.valueforSeparatedKey(key:"TIER_II_STATUS"))
        }
        func cultureSettings() {
            let cultureSettings: String = self.valueforSeparatedKey(key:"CURRENCY_FORMAT")
            WebServiceManager.sharedInstance.user.currencyCultureForPage = NSMutableArray()
            let elements: [Any] = cultureSettings.components(separatedBy:"|")
            for cultureForPage: String in elements as! [String] {
                let cultureDetails: [Any] = cultureForPage.components(separatedBy:  "~")
                if cultureDetails.count >= 3 {
                }
                if (WebServiceManager.sharedInstance.user.currencyCultureForPage?.count)! >= 6 {
                    WebServiceManager.sharedInstance.user.useUserCulterSettings = true
                }
                print("currencycount: \(WebServiceManager.sharedInstance.user.currencyCultureForPage?.count)")
            }
    }
            func searchFilters() -> [Any] {
                var filters = [Any]()
                if ("TRUE" == self.valueforSeparatedKey(key:"SEARCH_ONLY_AVAILABLE")) {
                    filters.append("SEARCH_ONLY_AVAILABLE")
                }
                if ("TRUE" == self.valueforSeparatedKey(key:"SEARCH_ONLY_PROMOTIONS")) {
                    filters.append("SEARCH_ONLY_PROMOTIONS")
                }
                if ("TRUE" == self.valueforSeparatedKey(key:"SEARCH_ONLY_NEW")) {
                    filters.append("SEARCH_ONLY_NEW")
                }
                if ("TRUE" == self.valueforSeparatedKey(key:"SEARCH_ONLY_STOCKORORDER")) {
                    filters.append("SEARCH_ONLY_STOCKORORDER")
                }
                if ("TRUE" == self.valueforSeparatedKey(key:"SEARCH_ONLY_LICENSE")) {
                    filters.append("SEARCH_ONLY_LICENSE")
                }
                if ("TRUE" == self.valueforSeparatedKey(key:"SEARCH_ONLY_DISCONTINUED")) {
                    filters.append("SEARCH_ONLY_DISCONTINUED")
                }
                return filters
            }
}

