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
    
    //var outageHtmlData: String = ""
//    var user:IMUser!
//    var countrySelection:IMCountry!
    var saveID:NSString = "false"
    var securityCode:NSString = ""
    var resendCode:NSString = "false"
    var operationss:NSArray?
    var productGroups:ProductGroups!
    var numberOfGroups3:Int!
   // var productGroups:ProductGroup!
    var outageHtmlData:String!
    var isOutageAvailable:Bool!
    
     var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private override init() {
        print("inside webservice")
    }

    // MARK: - FETCH COUNTRIES FUNCTION
    func fetchCountries(withCompletionBlock successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: Void) -> Void) {
 
        
        let params = self.preferredLanguageDictionary()
        
        self.performRESTCall(baseURL: Constants.URL_GET_COUNTRY_LIST, httpMethod: "GET", parameters: params as! [NSObject : AnyObject], successBlock: {(_ responseText: String) -> Void in
            print(successBlock)
            
            let parser = ResponseParser.init(responseStr: responseText as NSString )
            var arr : NSArray = []
            arr = parser.myArrayFunc() as NSArray
            successBlock(arr as! [Any])

        }, failedBlock: failedBlock)
        
        
    }
    
    
    // MARK: - FETCH FUNCTIONLIST FUNCTION
    func fetchFunctionList(withCompletionBlock successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: Void) -> Void) {
        
        let params = self.preferredLanguageDictionary()
        
        self.performRESTCall(baseURL: Constants.URL_GET_FUNCTION_LIST, httpMethod: "GET", parameters: params as! [NSObject : AnyObject], successBlock: {(_ responseText: String) -> Void in
            print(successBlock)
            
            let parser = ResponseParser.init(responseStr: responseText as NSString )
            var arr : NSArray = []
            arr = parser.FunctionList() as NSArray
            print(arr)
            successBlock(arr as! [Any])
          
        }, failedBlock: failedBlock)
        
        
    }
    // MARK: - LOGIN RELATED FUNCTIONS
    func loginWebservice(withCompletionBlock successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: String) -> Void){
           let paramStr: String = "?DEVICE=%@&AGENT=%@&OSVERSION=%@&CONNECTIONTYPE=%@&APPVERSION=%@&lang=%@&country=%@&deviceid=%@&saveid=%@&securitycode=%@&resendcode=%@"
            
            let loginPath = String(format: IMHelper.getURIforContractName("DoLogin") + (paramStr),
                                   "iPhone",
                                   "iOS",
                                   IMHelper.currentOS(),
                                   "WIFI",
                                   IMHelper.appVersion(),
                                   WebServiceManager.sharedInstance.countrySelection.languageCode,
                                   WebServiceManager.sharedInstance.countrySelection.countryId,
                                   "ABD979BE-11F6-487F-AAE1-EECE1A5144A1",
                                   WebServiceManager.sharedInstance.saveID,
                                    WebServiceManager.sharedInstance.securityCode,
                                    WebServiceManager.sharedInstance.resendCode)

        let url = URL(string:loginPath)!
            print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
       // let parameters = "username:\(WebServiceManager.sharedInstance.user.userId!)\npassword:\(WebServiceManager.sharedInstance.user.password!)"
        let parameters = "username:\(WebServiceManager.sharedInstance.user.userId!)\npassword:\(WebServiceManager.sharedInstance.user.password!)"
        print(parameters)
        urlRequest.httpBody = parameters.data(using: String.Encoding.utf8)
        
        urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
   
        Alamofire.request(urlRequest).validate()
            .responseString { response in
                print("Response String: \(response.result.description)")
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(response.response?.statusCode)
                        let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                        print(parser.lines)
                        
                        let fullName    = parser.lines.object(at: 0)
                        let fullNameArr = (fullName as AnyObject).components(separatedBy: ";")
                        let message = parser.validateLogin()
                        let name    = fullNameArr[0]
                        print(name)
                        let allCookies = IMHelper.fetchCookieArray(response: response.response! )
                        let cookval = allCookies.first!
                        print(allCookies)
                        IMHelper.setCookie(domain: cookval.domain, path: cookval.path, name: cookval.name, value: cookval.value, secure: cookval.isSecure, expires: cookval.expiresDate!,url: "")
                        if(name == "Failure"){
                            failedBlock(parser.errorMsg)
                        }
                        
                        if parser.isOutageAvailable() && self.isOutagePageVisible {
                            var outageResponse: String = parser.outageResponse()
                            self.isOutagePageVisible = true
                            failedBlock(parser.errorMsg)
                        }
                        if self.user != nil
                        {
                            self.user.sessionCookie = cookval
                            self.user.allCookies = allCookies
                        }
                        
                        if(message == ""){
                            self.user .remember()
                            // let url = URL(string: "https://mobility-stg.ingrammicro.com/1.0.0.0/Settings/ReadLocalSettingsList/?AGENT=iOS&APPVERSION=3.0&CONNECTIONTYPE=WIFI&DEVICE=iPhone&OSVERSION=10.2&uid=pradnya.dongre@ingrammicro.com&lang=EN&country=MX")!
                            self.localsettingAfterLogin(successBlock:{ Void in
                                
                              successBlock(fullNameArr)
                            }, failedBlock:  {() -> Void in
                                
                                failedBlock("")
                                print("error handling for failure pending" )
                            })
                        
                             successBlock(fullNameArr)
                            
                        }else{
                             failedBlock(parser.errorMsg)
                        }
                        
                    }
                    
                    break
                    
                case .failure( let error):
                    print(response.result.error)
                    
                    
                    //guard case let .failure(error) = response.result else { return }
                    if let error = error as? AFError {
                        switch error {
                        case .invalidURL(let url):
                            print("Invalid URL: \(url) - \(error.localizedDescription)")
                        case .parameterEncodingFailed(let reason):
                            print("Parameter encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .multipartEncodingFailed(let reason):
                            print("Multipart encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .responseValidationFailed(let reason):
                            print("Response validation failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            
                            switch reason {
                            case .dataFileNil, .dataFileReadFailed:
                                print("Downloaded file could not be read")
                            case .missingContentType(let acceptableContentTypes):
                                print("Content Type Missing: \(acceptableContentTypes)")
                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                            case .unacceptableStatusCode(let code):
                                print("Response status code was unacceptable: \(code)")
                            }
                        case .responseSerializationFailed(let reason):
                            print("Response serialization failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        }
                        
                        print("Underlying error: \(error.underlyingError)")
                    } else if let error = error as? URLError {
                        print("URLError occurred: \(error)")
                    } else {
                        print("Unknown error: \(error)")
                    }
                    
                    failedBlock(error.localizedDescription as! String)
                    break
                    
                }
                
                
                
              
        }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }
            
            
    }
    
    func localsettingAfterLogin(successBlock: @escaping (_: [Any]) -> Void, failedBlock: @escaping (_: Void) -> Void)
    {
        let paramStr: String = "?AGENT=%@&APPVERSION=%@&CONNECTIONTYPE=%@&DEVICE=%@&OSVERSION=%@&uid=%@&lang=%@&country=%@"
        let settingsPath = String(format: IMHelper.getURIforContractName("ReadLocalSettingsList") + (paramStr), "iOS", IMHelper.appVersion(),
                                  "WIFI",//IMHelper.connectionType(),
            IMHelper.deviceModel(),
            IMHelper.currentOS(),
            (self.user.userId)!,
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
                    
                    
                    if (self.user.isStatesAvailable)! {
                        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                            
                            //pending
                            //  self.loadStates()
                        })
                    }
                    
                    
                    //block()
                }else{
                    
                     if settingsParser.isOutageAvailable() && !self.isOutageAvailable {
                        let outageResponse: String = settingsParser.outageResponse()
                        self.isOutageAvailable = true
                        failedBlock()
                    }
                    else if !settingsParser.isOutageAvailable() {
                        // failedBlock(NSLocalizedString("General Login Error Message", comment: "login failed error message"), false)
                    }
                    
                }
                if(response.result.isFailure){
                    let settingsParser = ResponseParser(responseStr: response.result.value as! NSString)
                    if settingsParser.isOutageAvailable() {
                        let outageResponse: String = settingsParser.outageResponse()
                        self.isOutageAvailable = true
                        failedBlock()
                    }
                    else if !settingsParser.isOutageAvailable() {
                        failedBlock()
                    }
                }
                if((response.error) == nil){
                    let settingsParser = ResponseParser(responseStr: response.result.value as! NSString)
                    if settingsParser.isOutageAvailable() && !self.isOutageAvailable {
                        self.isOutageAvailable = true
                        let outageResponse: String = settingsParser.outageResponse()
                        //failedBlock(outageResponse, true)
                    }
                    else if !settingsParser.isOutageAvailable() {
                        // failedBlock(NSLocalizedString("General Login Error Message", comment: "login failed error message"), false)
                    }
                    
                    
                }
        }
    
    }
   
    func loginUserLegacy(withCompletionBlock block: @escaping (_: Void) -> Void, failedBlock: @escaping (_ errorMessage: String, _ isOutage: Bool) -> Void) {
    
        fetchSessionForLegacy(withCompletionBlock: {
            var paramStr: String = "?DEVICE=%@&AGENT=%@&OSVERSION=%@&CONNECTIONTYPE=%@&APPVERSION=%@&lang=%@&country=%@&sid=%@&deviceid=%@&saveid=%@&securitycode=%@&resendcode=%@"
            var loginPath = String(format: IMHelper.getURIforContractName("DoLogin") + (paramStr), "iPhone", "iOS",
                IMHelper.currentOS(),
                "WIFI",//IMHelper.connectionType(),
                IMHelper.appVersion(),
                WebServiceManager.sharedInstance.countrySelection.languageCode,
                WebServiceManager.sharedInstance.countrySelection.countryId,
                IMHelper.empty(forNil: self.user.sessionId!))

            let url = URL(string:loginPath)!
            print(url)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            let parameters = "username:\(WebServiceManager.sharedInstance.user.userId!)\npassword:\(WebServiceManager.sharedInstance.user.password!)"
            print(parameters)
            urlRequest.httpBody = parameters.data(using: String.Encoding.utf8)
            
            urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
            
            Alamofire.request(urlRequest)
                .responseString { response in
                    print("Response String: \(response.result.value)")
                    let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                    if parser.isOutageAvailable() && !self.isOutageAvailable {
                        self.isOutageAvailable = true
                        self.outageHtmlData = "\(parser.outageResponse())"
                        self.user.isOutage = true
                        failedBlock(self.outageHtmlData, true)
                    }
                    let message: String = parser.validateLegacyLogin()
                    if(message == ""){
                        self.user.remember()
                        
                        let paramStr: String = "?AGENT=%@&APPVERSION=%@&CONNECTIONTYPE=%@&DEVICE=%@&OSVERSION=%@&ccd=%@&bnr=%@&knr=%@&uid=%@&sid=%@&lang=%@&country=%@"
                        let settingsPath = String(format: IMHelper.getURIforContractName("ReadLocalSettingsList") + (paramStr),
                            "iOS",
                            IMHelper.appVersion(),
                            "WIFI",//IMHelper.connectionType(),
                            IMHelper.deviceModel(),
                            IMHelper.currentOS(),
                            self.user.language!,
                            self.user.bnr!,
                            self.user.customerNumber!,
                            self.user.userId!,
                            self.user.sessionId!,
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
                                if settingsParser.isOutageAvailable() && !self.isOutageAvailable {
                                    self.isOutageAvailable = true
                                    self.outageHtmlData = "\(settingsParser.outageResponse())"
                                    self.user.isOutage = true
                                    failedBlock(self.outageHtmlData, true)
                                }
                                
                                if settingsParser.canLogin(){
                                    self.user.canAccessTracking = settingsParser.canAccessTracking()
                                    self.user.canOrder = settingsParser.canOrder()
                                    self.user.isAdmin = settingsParser.isAdmin()
                                    self.user.isStatesAvailable = settingsParser.isStatesAvailable()
                                    //amit.p
                                    self.user.isDropShipAllowed = settingsParser.isDropshipAllowed()
                                    //46276 Amit.p
                                    //Amit.p:44926
                                    self.user.currency = WebServiceManager.sharedInstance.countrySelection.currencySymbol as NSString!
                                    //[IMHelper currentCurrency];
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
                                }else {
                                    if parser.isOutageAvailable() && !self.isOutageAvailable {
                                        self.isOutageAvailable = true
                                        self.outageHtmlData = "\(parser.outageResponse())"
                                        self.user.isOutage = true
                                        failedBlock(self.outageHtmlData, true)
                                    }
                                    else if !parser.isOutageAvailable() {
                                        if parser.isOutageAvailable() {
                                            self.isOutageAvailable = true
                                            self.outageHtmlData = "\(parser.outageResponse())"
                                            failedBlock(self.outageHtmlData, true)
                                        }
                                        else {
                                            failedBlock(NSLocalizedString("General Login Error Message", comment: "login failed error message"), false)
                                        }
                                    }
//                                    failedBlock
//                                    if parser.isOutageAvailable() && !isOutageAvailable {
//                                        isOutageAvailable = true
//                                        outageHtmlData = "\(parser.outageResponse())"
//                                        failedBlock(outageHtmlData, true)
//                                    }
//                                    else if !parser.isOutageAvailable() {
//                                        failedBlock(NSLocalizedString("General Login Error Message", comment: "login failed error message"), false)
//                                    }
                                    
                                }
 
                                }

                    }else {
                        if parser.isOutageAvailable() && !self.isOutageAvailable {
                            self.isOutageAvailable = true
                            self.user.isOutage = true
                            self.outageHtmlData = "\(parser.outageResponse())"
                            failedBlock(self.outageHtmlData, true)
                        }
                        else if !parser.isOutageAvailable() && !self.user.isOutage! {
                            failedBlock(NSLocalizedString("General Login Error Message", comment: "login failed error message"), false)
                        }
                        
                    }
                    }
           // }
            
            
        }, failedBlock: {_,_ in })
    }
    
    

    func fetchSessionForLegacy(withCompletionBlock successBlock: @escaping (_: Void) -> Void, failedBlock: @escaping (_ errorMessage: String, _ isOutage: Bool) -> Void) {
        
        var paramStr: String = "?DEVICE=%@&AGENT=%@&OSVERSION=%@&CONNECTIONTYPE=%@&APPVERSION=%@&country=%@&uid=%@&lang=%@"
        var sessionPath = String(format: IMHelper.getURIforContractName("CreateSession") + (paramStr), IMHelper.empty(forNil: IMHelper.deviceModel()),
                                 "iOS",
                                 IMHelper.empty(forNil: IMHelper.currentOS()),
                                 "WIFI",//IMHelper.empty(forNil: IMHelper.connectionType()),
                                 IMHelper.empty(forNil: IMHelper.appVersion()),
                                 WebServiceManager.sharedInstance.countrySelection.countryId,
                                 IMHelper.empty(forNil: user.userId!),
                                 IMHelper.empty(forNil: user.language!))
        

        let url = URL(string:sessionPath)!
        print(url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
    
        
        
        urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
        
        Alamofire.request(urlRequest)
            .responseString { response in
                print("Response String: \(response.result.value)")
                let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                
                if parser.isOutageAvailable() && !self.isOutageAvailable {
                    self.isOutageAvailable = true
                    self.outageHtmlData = "\(parser.outageResponse())"
                    self.user.isOutage = true
                    failedBlock(self.outageHtmlData, true)
                }
               else if parser.successREST() {
                    self.user.sessionId = parser.sessionId()
                    if self.user.sessionId != nil {
                        successBlock()
                    }
                    else {
                        if parser.isOutageAvailable() {
                            self.isOutageAvailable = true
                            self.outageHtmlData = "\(parser.outageResponse())"
                            self.user.isOutage = true
                            failedBlock(self.outageHtmlData, true)
                        }
                        else if !parser.isOutageAvailable() {
                           // DLog("fetchSessionWithCompletionBlock could not parse the sessionId in the response")
                            failedBlock("", false)
                        }
                    }
                }
                else {
                    if parser.isOutageAvailable() {
                        self.isOutageAvailable = true
                        self.outageHtmlData = "\(parser.outageResponse())"
                        self.user.isOutage = true
                        failedBlock(self.outageHtmlData, true)
                    }
                    else if !parser.isOutageAvailable() {
                        failedBlock("", false)
                    }
                    
                }

        }
    }
    func loadStates() {
        var productGroupsSavedAtDate: Date? = UserDefaults.standard.object(forKey: Constants.DEFAULTS_KEY_PRODUCTGROUPS_REMEMBERED_AT_DATE) as! Date?
//        if (productGroupsSavedAtDate == nil || Date().timeIntervalSince(productGroupsSavedAtDate!) > Double(Constants.PRODUCTGROUPS_TIMEOUT_IN_SECONDS)   || UserDefaults.standard.bool(forKey: "updateCache")) {
//            var parameters: NSDictionary = [
//                WebServiceManager.sharedInstance.countrySelection.countryId : IMHelper.empty(forNil: user.language!)
//            ]
       // let params = "USA = en"
//        self.performRESTCall(baseURL: IMHelper.getURIforContractName("GetStatesList") , httpMethod: "GET", parameters: params as! [NSObject : AnyObject], successBlock: {(_ responseText: String) -> Void in
//            
//            //print(successBlock)
////            let stringdemo = responseText as
////           let parser = ResponseParser.init(responseStr: successBlock as! String)
////            
//            let parser = ResponseParser.init(responseStr: responseText as NSString )
////            var arr : NSArray = []
////            arr = parser.myArrayFunc() as NSArray
////            successBlock(arr as! [Any])
//            //            let parser = ResponseParser().response
//            //            var arr : NSArray = []
//            //                          arr = parser.myArrayFunc() as NSArray
//            //            //
//            //                            successBlock(arr as NSArray)
//            // successBlock = SUC
//        }, failedBlock: {(_: Void) -> Void in
//           
//            //DLog("States Request failed");
//            //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"StatesLoaded"];
//            })
        
        let params: [AnyHashable: Any]? = [
            "USA" : "en"
        ]

        
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
        print(user.sessionId)
        var parameters: NSDictionary = [
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
    
     // MARK: - GENERAL NETWORK CALLS(PERFORM REST CALL)
    func performRESTCall(baseURL: String, httpMethod: String, parameters: [NSObject : AnyObject], successBlock: @escaping (_ response: String) -> Void, failedBlock: @escaping () -> Void) {
        //    NSLog(@"Received Parameters: %@",parameters);
        self.performRESTCall(baseURL, httpMethod: (httpMethod as! String), parameters: parameters, successBlock: successBlock, failedBlock: failedBlock, showLoginViewIfSessionInvalid: true)
    }

    func performRESTCall(_ baseURL: String, httpMethod: String, parameters: [AnyHashable: Any], successBlock: @escaping (_ response: String) -> Void, failedBlock: @escaping () -> Void, showLoginViewIfSessionInvalid: Bool) {
        performRESTCall(baseURL, httpMethod: httpMethod, parameters: parameters, successBlock: successBlock, failedBlock: failedBlock, showLoginViewIfSessionInvalid: showLoginViewIfSessionInvalid, contentType:"application/mobile")
    }
    
    func performRESTCall(_ baseURL: String, httpMethod: String, parameters: [AnyHashable: Any], successBlock: @escaping (_ response: String) -> Void, failedBlock: @escaping () -> Void, showLoginViewIfSessionInvalid: Bool, contentType: String) {
    
      //  if #available(iOS 10.0, *) {
           let  appdelgt = UIApplication.shared.delegate as! AppDelegate
      
        if(appdelgt.isInternetAvailable == true){
            
       
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
        
        
        let authorisationParameters: String = self.authorisationParametersREST()
        print(addedParameters)
        let serviceParameters: String = self.serviceParameters(fromDictionary: addedParameters as! [String : String])
        let urlString: String = "\(baseURL)?\(authorisationParameters)\(serviceParameters)"
        // https://mobility-stg2.ingrammicro.com/Dispatcher/Countrylist/?country=&ccd=EN&lang=en&bnr=&knr=&uid=&sid=&AGENT=iOS&LANGCODE=en&DEVICE=iPhone&OSVERSION=10.2&CONNECTIONTYPE=WIFI&APPVERSION=3.0
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        
        
        urlRequest.httpMethod = httpMethod
        
        
        urlRequest.addValue(Constants.CONTENTYPE_VALUE, forHTTPHeaderField: Constants.CONTENTYPE)
        
        Alamofire.request(urlRequest).validate()
            .responseString { response in
               switch(response.result) {
                case .success(_):
                    print("Response String: \(response.result.value)")
                    let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                    // successBlock(parser.response as String)
                    
                    var validSession: Bool = true
                    
                    if (self.countrySelection.environmentType == Constants.ENV_DACH)
                    {
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
                                var message: String?=""
                                if let a = messageDict.value(forKey: MESSAGE_DESC_KEY) as? String{
                                    message = a
                                }
                                
                                
                                var orderService: String = "Order"
                                var basketListService: String = "Basket/List/?"
                                var range: NSRange = (urlString as NSString).range(of: orderService, options: .caseInsensitive)
                                var rangeBasket: NSRange = (urlString as NSString).range(of: basketListService, options: .caseInsensitive)
                                if range.location == NSNotFound {
                                    if rangeBasket.location == NSNotFound {
                                        if((message?.characters.count)! > 0){
                                            var alertView = UIAlertView(title: title!, message: message!, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
                                            alertView.show()
                                        }
                                        else{
                                            
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                    if !validSession {
                        // session has expired, present login view modally
                        let parser = ResponseParser.init(responseStr: response.result.value as! NSString)
                        if showLoginViewIfSessionInvalid && !parser.isOutageAvailable() && !(self.user.isOutage!)
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

                    break
                    
                case .failure( let error):
                    print(response.result.error)
                    
                    
                    //guard case let .failure(error) = response.result else { return }
                    if let error = error as? AFError {
                        switch error {
                        case .invalidURL(let url):
                            print("Invalid URL: \(url) - \(error.localizedDescription)")
                        case .parameterEncodingFailed(let reason):
                            print("Parameter encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .multipartEncodingFailed(let reason):
                            print("Multipart encoding failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        case .responseValidationFailed(let reason):
                            print("Response validation failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                            
                            switch reason {
                            case .dataFileNil, .dataFileReadFailed:
                                print("Downloaded file could not be read")
                            case .missingContentType(let acceptableContentTypes):
                                print("Content Type Missing: \(acceptableContentTypes)")
                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                            case .unacceptableStatusCode(let code):
                                print("Response status code was unacceptable: \(code)")
                            }
                        case .responseSerializationFailed(let reason):
                            print("Response serialization failed: \(error.localizedDescription)")
                            print("Failure Reason: \(reason)")
                        }
                        
                        print("Underlying error: \(error.underlyingError)")
                    } else if let error = error as? URLError {
                        print("URLError occurred: \(error)")
                    } else {
                        print("Unknown error: \(error)")
                    }
                    
                    
                    break
                    
                }
                
                
                

            }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }

        }
        else{
            print("No internet")
        }
    
        
    }
   
    
    func authorisationParameters() -> String
    {
        return "CCD=\(user.countryCode)&LANG=\(user.language)&BNR=\(user.bnr)&KNR=\(user.customerNumber)&UID=\(user.userId)&SID=\(user.sessionId)&RESSEP=%%3B&TS=\(IMHelper.timestamp)"
    }
    
    
    func performCall(_ baseURL: String, parameters: [AnyHashable: Any], successBlock: @escaping (_ response: String) -> Void, failedBlock: @escaping () -> Void, showLoginViewIfSessionInvalid: Bool) {
        
        var addedParameters = [String: String]()
        for (k, v) in parameters { addedParameters.updateValue(v as! String, forKey: k as! String) }
        addedParameters["AGENT"] = "iOS"
        addedParameters["APPVERSION"] = IMHelper.empty(forNil: IMHelper.appVersion())
        addedParameters["DEVICE"] = IMHelper.empty(forNil: IMHelper.deviceModel())
        addedParameters["OSVERSION"] = IMHelper.empty(forNil: IMHelper.currentOS())
       //addedParameters["CONNECTIONTYPE"] = IMHelper.empty(forNil: IMHelper.connectionType())
        let authorisationParameters: String = self.authorisationParameters()
        let serviceParameters: String = self.serviceParameters(fromDictionary: addedParameters as! [String : String])
        let urlString: String = "\(baseURL)?\(authorisationParameters)\(serviceParameters)"
        
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
     
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
    
     // MARK: - PREFFERED LOCAL LANGUAGE FUNCTIONS
    func preferredLanguageDictionary() -> NSMutableDictionary
    {
    
        
        let params: NSMutableDictionary = [
            "LANGCODE" : (NSLocale.preferredLanguages[0])
        ]
        return params
    }
    func showActivityIndicatory(uiView: UIView)
    {
        //var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x:0, y: 0, width: 40, height:40)
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.color = UIColor(red: 21.0/255.0, green: 75.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func stopActivityIndicatory(uiView: UIView)
    {
       
        actInd.stopAnimating()
    }
    
    
    
}
