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
    
    func myArrayFunc() -> Array<String>
    {
        var countries = [Any]()
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
              let countryadd = elements[1]
                let empty : String = countryadd.replacingOccurrences(of: "\"", with: "")
                countries.append(empty)
            }
            
           print(countries)

            
        }
        
        return countries as! Array<String>
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
}

