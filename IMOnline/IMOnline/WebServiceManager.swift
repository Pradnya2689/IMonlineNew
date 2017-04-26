//
//  WebServiceManager.swift
//  IMOnline
//
//  Created by pradnya on 12/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Alamofire


//class IMCountry : NSObject
//{
//    
//    }

class WebServiceManager: NSObject {
    static let sharedInstance = WebServiceManager()
    var countrySelection = IMCountry()
    var user = IMUser()
    var hersteller = NSMutableArray()
    var operations = [Any]()
    
    var countryArr = NSMutableArray()
    var isOutagePageVisible:Bool!
    
    var outageHtmlData: String = ""
//    var user:IMUser!
//    var countrySelection:IMCountry!
    var saveID:NSString!
    var securityCode:NSString!
    var resendCode:NSString!
    var operationss:NSArray?
    var productGroups:ProductGroups!
    var numberOfGroups3:Int!
   // var productGroups:ProductGroup!
    var outageHtmlData:NSMutableString!
    var isOutageAvailable:Bool!
    func fetchCountries(withCompletionBlock successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: Void) -> Void) {
 
        
       
        let params: [AnyHashable: Any]? = [
            "LANGCODE" : (NSLocale.preferredLanguages[0])
        ]
        self.performRESTCall(baseURL: Constants.URL_GET_COUNTRY_LIST, httpMethod: "GET", parameters: params as! [NSObject : AnyObject], successBlock: {(_ responseText: String) -> Void in
            print(successBlock)
            //let stringdemo = responseText as
            //let parser = ResponseParser.init(responseStr: successBlock as! String as NSString)
            
            let parser = ResponseParser.init(responseStr: responseText as NSString )
            var arr : NSArray = []
            arr = parser.myArrayFunc() as NSArray
            successBlock(arr as! [Any])
//            let parser = ResponseParser().response
//            var arr : NSArray = []
//                          arr = parser.myArrayFunc() as NSArray
//            //
//                            successBlock(arr as NSArray)
           // successBlock = SUC
        }, failedBlock: failedBlock)
        
        
    }
   
    
    func fetchFunctionList(withCompletionBlock successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: Void) -> Void) {
        
        
        
        let params: [AnyHashable: Any]? = [
            "LANGCODE" : (NSLocale.preferredLanguages[0])
        ]
        self.performRESTCall(baseURL: Constants.URL_GET_FUNCTION_LIST, httpMethod: "GET", parameters: params as! [NSObject : AnyObject], successBlock: {(_ responseText: String) -> Void in
            print(successBlock)
            //let stringdemo = responseText as
            //let parser = ResponseParser.init(responseStr: successBlock as! String as NSString)
            
            let parser = ResponseParser.init(responseStr: responseText as NSString )
            var arr : NSArray = []
            arr = parser.FunctionList() as NSArray
            print(arr)
            successBlock(arr as! [Any])
            //            let parser = ResponseParser().response
            //            var arr : NSArray = []
            //                          arr = parser.myArrayFunc() as NSArray
            //            //
            //                            successBlock(arr as NSArray)
            // successBlock = SUC
        }, failedBlock: failedBlock)
        
        
    }
        func loginWebservice(withCompletionBlock successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: Void) -> Void){
        
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
               // let sessionCookie = IMHelper.fetchSessionCookie(request:  response.response!)
                let allCookies = IMHelper.fetchCookieArray(response: response.response! )
                let cookval = allCookies.first!
                print(allCookies)
                IMHelper.setCookie(domain: cookval.domain, path: cookval.path, name: cookval.name, value: cookval.value, secure: cookval.isSecure, expires: cookval.expiresDate!,url: "")
                
                if parser.isOutageAvailable() && self.isOutagePageVisible {
                    var outageResponse: String = parser.outageResponse()
                    self.isOutagePageVisible = true
                    failedBlock()
                }
                if self.user != nil  {
                   // self.user.sessionCookie = sessionCookie
                    self.user.allCookies = allCookies
                }
                var message = parser.validateLogin()
                if(message == ""){
                self.user .remember()
               // let url = URL(string: "https://mobility-stg.ingrammicro.com/1.0.0.0/Settings/ReadLocalSettingsList/?AGENT=iOS&APPVERSION=3.0&CONNECTIONTYPE=WIFI&DEVICE=iPhone&OSVERSION=10.2&uid=pradnya.dongre@ingrammicro.com&lang=EN&country=MX")!
                    
                    var paramStr: String = "?AGENT=%@&APPVERSION=%@&CONNECTIONTYPE=%@&DEVICE=%@&OSVERSION=%@&uid=%@&lang=%@&country=%@"
                    var settingsPath = String(format: IMHelper.getURIforContractName("ReadLocalSettingsList") + (paramStr), "iOS", IMHelper.appVersion(),
                    "WIFI",//IMHelper.connectionType(),
                        IMHelper.deviceModel(),
                        IMHelper.currentOS(),
                        self.user.userId!,
                        WebServiceManager.sharedInstance.countrySelection.languageCode,
                        WebServiceManager.sharedInstance.countrySelection.countryId)
                    
                    var urlRequest = URLRequest(url: URL(string:settingsPath)!)
                urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
                urlRequest.httpMethod = "GET"
                urlRequest.httpShouldHandleCookies = true
                urlRequest.addValue("0", forHTTPHeaderField: "Content-Length")
                urlRequest.httpShouldHandleCookies = true
                print("urlstr \(urlRequest)")
                Alamofire.request(urlRequest)
                    .responseString { response in
                        print("Response String: \(response.result.value)")
                        let settingsParser = ResponseParser.init(responseStr: response.result.value as! NSString)
                        //  Converted with Swiftify v1.0.6314 - https://objectivec2swift.com/
                        
                            //self.user.remember()
                        if settingsParser.isOutageAvailable() && !self.isOutagePageVisible {
                            var outageResponse: String = settingsParser.outageResponse()
                            self.isOutagePageVisible = true
                            failedBlock()
                        }

                        if (settingsParser.canLogin()){
                            self.user.canAccessTracking = settingsParser.canAccessTracking()
                            self.user.canOrder = settingsParser.canOrder()
                            self.user.isAdmin = settingsParser.isAdmin()
                            self.user.isDropShipAllowed = settingsParser.isDropshipAllowed()
                            //46276 Amit.p
                            self.user.isStatesAvailable = settingsParser.isStatesAvailable()
                            self.user.currency = WebServiceManager.sharedInstance.countrySelection.currencySymbol as NSString!
                            self.user.searchFilters = settingsParser.searchFilters() as NSArray!
                            settingsParser.cultureSettings()

                            if !(UserDefaults.standard.string(forKey: "selectedCountry") == WebServiceManager.sharedInstance.countrySelection.countryId) || !(UserDefaults.standard.string(forKey: "loginUserId") == WebServiceManager.sharedInstance.user.userId) {
                                UserDefaults.standard.set(true, forKey: "updateCache")
                                UserDefaults.standard.set(WebServiceManager.sharedInstance.countrySelection.countryId, forKey: "selectedCountry")
                                UserDefaults.standard.set(WebServiceManager.sharedInstance.user.userId, forKey: "loginUserId")
                                UserDefaults.standard.set(nil, forKey: "setDeliveryway")
                                self.user.defaultUserSetting()
                                //uttam.b Ticket 54178:Switching User or coutry should refresh right data
                            }
                            else {
                                UserDefaults.standard.set(false, forKey: "updateCache")
                            }
                            
                            self.loadWheelData()
                            
                            
                            if self.user.isStatesAvailable! {
                                DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                                    self.loadStates()//pending
                                })
                            }
                            //block()
                        }else{
                            //DLog("loginUserWithCompletionBlock settings canLogin says, user has no rights")
                            if settingsParser.isOutageAvailable() && !self.isOutageAvailable {
                                var outageResponse: String = settingsParser.outageResponse()
                                self.isOutageAvailable = true
                                failedBlock()
                            }
                            else if !settingsParser.isOutageAvailable() {
                               // failedBlock(NSLocalizedString("General Login Error Message", comment: "login failed error message"), false)
                            }
                            
                        }
                        if(response.result.isFailure){
                            var settingsParser = ResponseParser(responseStr: response.result.value as! NSString)
                            if settingsParser.isOutageAvailable() {
                                var outageResponse: String = settingsParser.outageResponse()
                                self.isOutageAvailable = true
                                //failedBlock(outageResponse, true)
                            }
                            else if !settingsParser.isOutageAvailable() {
                               // failedBlock(NSLocalizedString("General Login Error Message", comment: "login failed error message"), false)
                            }
                        }
                        }
                    
                    
                }
                if((response.error) == nil){
                    var settingsParser = ResponseParser(responseStr: response.result.value as! NSString)
                    if settingsParser.isOutageAvailable() && !self.isOutageAvailable {
                        self.isOutageAvailable = true
                        var outageResponse: String = settingsParser.outageResponse()
                        //failedBlock(outageResponse, true)
                    }
                    else if !settingsParser.isOutageAvailable() {
                       // failedBlock(NSLocalizedString("General Login Error Message", comment: "login failed error message"), false)
                    }
                    

                }
        }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }
            
            
    }
   
    func loadStates() {
        var productGroupsSavedAtDate: Date? = UserDefaults.standard.object(forKey: Constants.DEFAULTS_KEY_PRODUCTGROUPS_REMEMBERED_AT_DATE) as! Date?
        if (productGroupsSavedAtDate == nil || Date().timeIntervalSince(productGroupsSavedAtDate!) > Double(Constants.PRODUCTGROUPS_TIMEOUT_IN_SECONDS)   || UserDefaults.standard.bool(forKey: "updateCache")) {
//            var parameters: NSDictionary = [
//                WebServiceManager.sharedInstance.countrySelection.countryId : IMHelper.empty(forNil: user.language!)
//            ]
            let url = URL(string: IMHelper.getURIforContractName("GetStatesList"))!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            let parameters = "USA = en"
            
            urlRequest.httpBody = parameters.data(using: String.Encoding.utf8)
            
            //urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
            
            Alamofire.request(urlRequest)
                .responseJSON { response in
                    print("Response JSON: \(response.result.value)")
            }
            
            
            //var plainPart: NSDictionary = [kSKPSMTPPartContentTypeKey: "text/plain; charset=UTF-8", kSKPSMTPPartMessageKey: self.data , kSKPSMTPPartContentTransferEncodingKey : "8bit"]
        }
        
    }
    func loadWheelData() {
        WebServiceManager.sharedInstance.fetchVendorsGroups(withCompletionBlock: {(_ wheelData: [Any]) -> Void in
        }, failedBlock: {() -> Void in
        })
    }
    
    func fetchVendorsGroups(withCompletionBlock successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: Void) -> Void) {
        //  Converted with Swiftify v1.0.6314 - https://objectivec2swift.com/
        var productGroupsSavedAtDate: Date? = UserDefaults.standard.object(forKey: Constants.DEFAULTS_KEY_PRODUCTGROUPS_REMEMBERED_AT_DATE) as! Date?
        if productGroupsSavedAtDate != nil && Date().timeIntervalSince(productGroupsSavedAtDate!) < Double(Constants.PRODUCTGROUPS_TIMEOUT_IN_SECONDS) && !UserDefaults.standard.bool(forKey: "updateCache") {

            var path: String = URL(fileURLWithPath: IMHelper.documentsDirectory()).appendingPathComponent(Constants.PRODUCT_GROUPS_FILE).absoluteString
            var productGroupsAsText = try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
            productGroups = ProductGroups(string: productGroupsAsText!)
            return
        }
        
        var parameters: [AnyHashable: Any] = [
            IMHelper.empty(forNil: user.sessionId!) : IMHelper.empty(forNil: user.userId!),
            WebServiceManager.sharedInstance.countrySelection.countryId : IMHelper.empty(forNil: user.language!),
            "search" : "ALL"
        ]
        performRESTCall(baseURL: IMHelper.getURIforContractName("LoadVendorGroups"), httpMethod: "GET", parameters: parameters as [NSObject : AnyObject], successBlock: {(_ responseText: String) -> Void in
            var parser = ResponseParser(responseStr: responseText as NSString)
            if parser.successREST() {
                var path: String = URL(fileURLWithPath: IMHelper.documentsDirectory()).appendingPathComponent(Constants.PRODUCT_GROUPS_FILE).absoluteString
                try? responseText.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
                UserDefaults.standard.setValue(Date(), forKey: Constants.DEFAULTS_KEY_PRODUCTGROUPS_REMEMBERED_AT_DATE)
               // productGroups = ProductGroups(string: responseText)
            }
            else {
                failedBlock()
            }
        }, failedBlock: failedBlock)

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
        
        var addedParameters = [AnyHashable: Any]()
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
        let serviceParameters: String = self.serviceParameters(fromDictionary: addedParameters as! [String : String])
        let urlString: String = "\(baseURL)?\(authorisationParameters)\(serviceParameters)"
        // https://mobility-stg2.ingrammicro.com/Dispatcher/Countrylist/?country=&ccd=EN&lang=en&bnr=&knr=&uid=&sid=&AGENT=iOS&LANGCODE=en&DEVICE=iPhone&OSVERSION=10.2&CONNECTIONTYPE=WIFI&APPVERSION=3.0
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        
        
        urlRequest.httpMethod = httpMethod
        
        
        urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
        
        Alamofire.request(urlRequest)
            .responseString { response in
                print("Response String: \(response.result.value)")
                let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
               // successBlock(parser.response as String)
                
                var validSession: Bool = true
                
                if (self.countrySelection.environmentType == Constants.ENV_DACH)
                {
                    //                    var location: String? = (request.responseHeaders()["Location"] as? String)
                    //                    if request.responseStatusCode() == 302 && location != nil
                    //                    {
                    //                        validSession = false
                    //                    }
                }
                else if (self.countrySelection.environmentType == Constants.ENV_ENDEAVOUR)
                {
                    let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                    let res = parser.response as String
                    
                    
                    if parser.isOutageAvailable() && !self.isOutagePageVisible {
                        self.isOutagePageVisible = true
                        self.user.isOutage = true
                                            self.outageHtmlData = (parser.outageResponse() as String)
                       // failedBlock(self.outageHtmlData, true)
                                              //  failedBlock(outageHtmlData, true)
                    }
                    
                    if self.user.sessionCookie != nil {
                        var now = Date()
                        //                        DLog("exptime:%f now:%f", user.sessionCookie.expiresDate.timeIntervalSince1970, now.timeIntervalSince1970)
                            var elapsedTime: TimeInterval = self.user.sessionCookie.expiresDate!.timeIntervalSince1970 - now.timeIntervalSince1970
                                              self.user.remainingTime = elapsedTime
                                                if elapsedTime < 0
                                                {
                                                    validSession = false
                                                }
                        
                     //   var messageDict: [String: String] = [:]
                        var messageDict: NSMutableDictionary = parser.validateEndeavourSession(urlString)
                        if messageDict != nil {
                          
                            var title: String? = messageDict.value(forKey: MESSAGE_TITLE_KEY) as! String?
                            var message: String? = messageDict.value(forKey: MESSAGE_DESC_KEY) as! String?
                        
                            var alertView = UIAlertView(title: title!, message: message!, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
                            var orderService: String = "Order"
                            var basketListService: String = "Basket/List/?"
                            var range: NSRange = (urlString as NSString).range(of: orderService, options: .caseInsensitive)
                            var rangeBasket: NSRange = (urlString as NSString).range(of: basketListService, options: .caseInsensitive)
                            if range.location == NSNotFound {
                                if rangeBasket.location == NSNotFound {
                                    alertView.show()
                                }
                            }
                            // [alertView show];//Temporarily hiding error alert messages
                        }
                    }
                    
                    
                }
                
                if !validSession {
                    // session has expired, present login view modally
                    let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                    if showLoginViewIfSessionInvalid && !parser.isOutageAvailable() && !self.user.isOutage!
                    {
                        if #available(iOS 10.0, *) {
                            (UIApplication.shared.delegate as? AppDelegate)?.showModalLogin(withSuccessBlock: {() -> Void in
                                (UIApplication.shared.delegate as? AppDelegate)?.hideModalLogin()
 
                                self.performCall(baseURL, parameters: parameters, successBlock: successBlock, failedBlock: failedBlock, showLoginViewIfSessionInvalid: false)
                                return
                            }, failedBlock: failedBlock)
                        } else {
                            OperationQueue.main.addOperation {() -> Void in
                                failedBlock()
                            }
                        }
                    }
                    else {
                        OperationQueue.main.addOperation {() -> Void in
                            failedBlock()
                        }
                    }
                }
                else {
                    var responseString = parser.response as String
                    OperationQueue.main.addOperation {() -> Void in
                        successBlock(responseString)
                    }

                }


            }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }

       
        
        
    }
    
    
    func authorisationParameters() -> String
    {
        return "CCD=\(user.countryCode)&LANG=\(user.language)&BNR=\(user.bnr)&KNR=\(user.customerNumber)&UID=\(user.userId)&SID=\(user.sessionId)&RESSEP=%%3B&TS=\(IMHelper.timestamp)"
    }
    
    
    func performCall(_ baseURL: String, parameters: [AnyHashable: Any], successBlock: @escaping (_ response: String) -> Void, failedBlock: @escaping () -> Void, showLoginViewIfSessionInvalid: Bool) {
        
        var addedParameters = [AnyHashable: Any]()
        for (k, v) in parameters { addedParameters.updateValue(v, forKey: k) }
        addedParameters["AGENT"] = "iOS"
        addedParameters["APPVERSION"] = IMHelper.empty(forNil: IMHelper.appVersion())
        addedParameters["DEVICE"] = IMHelper.empty(forNil: IMHelper.deviceModel())
        addedParameters["OSVERSION"] = IMHelper.empty(forNil: IMHelper.currentOS())
       //addedParameters["CONNECTIONTYPE"] = IMHelper.empty(forNil: IMHelper.connectionType())
        let authorisationParameters: String = self.authorisationParameters()
        let serviceParameters: String = self.serviceParameters(fromDictionary: addedParameters as! [AnyHashable : String])
        let urlString: String = "\(baseURL)?\(authorisationParameters)\(serviceParameters)"
        
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        
        
       // urlRequest.httpMethod = ""
        
        
        urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
        
        Alamofire.request(urlRequest)
            .responseString{response in
                print("Response String: \(response.result.value)")
                let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
        }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }
        }
        
        
   // }
        
    
    func authorisationParametersREST() -> String {
    
        let language: String? = (NSLocale.preferredLanguages[0] as? String)
        //language = @"en-US";
        let languageDic: [AnyHashable: Any] = NSLocale.components(fromLocaleIdentifier: language!)
        //languageDic will have the needed components
        let countryCode: String? = (languageDic["kCFLocaleCountryCodeKey"] as? String)
        //countryCode = "US"
        let languageCode: String? = (languageDic["kCFLocaleLanguageCodeKey"] as! String)
        //languageCode = "en"
//        print(IMCountry.sharedInstance.countryId)
//        print(WebServiceManager.sharedInstance.countrySelection.countryId)
//        print(WebServiceManager.sharedInstance.user?.language )
//        print(WebServiceManager.sharedInstance.countrySelection.countryId)
//        print(WebServiceManager.sharedInstance.user.language )
////        print(IMUser.sharedInstance.bnr)
        
//        print(WebServiceManager.sharedInstance.countrySelection.countryId)
//        print(WebServiceManager.sharedInstance.user.language)
//        print(WebServiceManager.sharedInstance.user.bnr)
//        
//        print(WebServiceManager.sharedInstance.user.customerNumber)
//        print( WebServiceManager.sharedInstance.user.userId)
//        print(WebServiceManager.sharedInstance.user.sessionId)
        
         return "country=\(IMHelper.empty(forNil: (WebServiceManager.sharedInstance.countrySelection.countryId)))&ccd=\(IMHelper.empty(forNil: WebServiceManager.sharedInstance.user.language ?? ""))&lang=\(languageCode!)&bnr=\(IMHelper.empty(forNil: WebServiceManager.sharedInstance.user.bnr ?? ""))&knr=\(IMHelper.empty(forNil: WebServiceManager.sharedInstance.user.customerNumber ?? ""))&uid=\(IMHelper.empty(forNil: WebServiceManager.sharedInstance.user.userId ?? ""))&sid=\(IMHelper.empty(forNil: WebServiceManager.sharedInstance.user.sessionId ?? ""))"
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
