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
    
    func FunctionList() -> Array<String>
    {
       var _RIGHTS_BLOCK: Bool = false
        
        var funcSet = [Any]()
        var operations = [Any]()
        
        //IMOperation *imOperation = nil;
        
        
        
        for var line in self.lines
        {
           
            
            if (line as AnyObject).hasPrefix("[RIGHTS]")
            {
                _RIGHTS_BLOCK = true
            }
            
            if !_RIGHTS_BLOCK
            {
                // exclude lines
                if ((line as! String) == "")
                {
                    continue
                }
                
               // var elements: [Any] = (line as AnyObject).components(separatedBy: CharacterSet(charactersInString: "="))
                var elements : [Any] = (line as! String).components(separatedBy: "=")             // start block operation contracts
                if (elements[0] as AnyObject).hasPrefix("APP_VERSION")
                {
//                    imOperation = IMOperation()
//                    imOperation.appVersion = elements[1].replacingOccurrences(of: "\"", with: "")
                }
                if (elements[0] as AnyObject).hasPrefix("OPERATION_CONTRACT_NAME")
                {
                 //   imOperation.contractName = elements[1].replacingOccurrences(of: "\"", with: "")
                }
                if (elements[0] as AnyObject).hasPrefix("OPERATION_CONTRACT_URI")
                {
                   // imOperation.contractURI = elements[1].replacingOccurrences(of: "\"", with: "")
                }
                if (elements[0] as AnyObject).hasPrefix("OPERATION_CONTRACT_METHOD")
                {
                   // imOperation.contractMethod = elements[1].replacingOccurrences(of: "\"", with: "")
                }
           /* let empty : String = elements[0]
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
            }*/
            
           
            
        }
            
            if _RIGHTS_BLOCK
            {
                // exclude lines
                if (line as! String) == "" || (line as AnyObject).hasPrefix("[RIGHTS]") || (line as AnyObject).hasPrefix("Tier") {
                    continue
                }
//                var elements: [Any] = (line as! String).components(separatedBy: ";")
//                var func = IMFunctionList()
//                func.appVersion = elements[0]
//                func.appTierVersion = elements[1]
//                func.countryCode = elements[2]
//                func.groupName = elements[3]
//                func.value = (elements[4] == "TRUE") ? true : false
//                func.contractsGroup = CInt(elements[5])
//                //[func toString];
//                funcSet.append(func)
            }
        
            }
        
//        WebServiceManager.sharedInstance.countrySelection.functionList = funcSet
//        WebServiceManager.sharedInstance.operations = operations
        return funcSet as! Array<String>
}

}
