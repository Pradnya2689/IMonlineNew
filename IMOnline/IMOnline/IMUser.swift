//
//  IMUser.swift
//  IMOnline
//
//  Created by pradnya on 13/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class IMUser: NSObject {
     static let sharedInstance = IMUser()
    
    var countryCode:String?
    var language:String?
    var userId : String?
    var bnr : String?
    var customerNumber : String?
    var password : String?
    var sessionId : String?
    // var countryCode : String?
    var sessionCookie:HTTPCookie!
    var allCookies:[HTTPCookie]!
    var functions = [Any]()
//    var sessionCookie:HTTPCookie!
//    var allCookies:[HTTPCookie]!
    var shouldShowEKPrice: Bool = false
    var shouldShowEVPPrice: Bool = false
    var shouldShowSellPrice: Bool = false
    var shouldShowTaxes: Bool = false
    var sellPricePercentage: Float?
    var taxesPercentage: Float?
    var canAccessTracking: Bool?
    var canOrder: Bool?
    var isAdmin: Bool?
    var isVendor: Bool?
    var isStatesAvailable: Bool?
    var isDropShipAllowed: Bool?
    var isOutage:Bool?
    var testDate:NSDate?
    var searchFilters:NSArray!
    var useUserCulterSettings:Bool?
    var addsShown:NSMutableDictionary!
    var cookieString:NSString!
    var ads_ImpressionList:NSMutableArray!
    var currency: NSString!
    var currencyCultureForPage:NSMutableArray!
    override init() {
        
//        if super.init() {
//            
//        }
    }
    func remember() {
        let standardDefaults = UserDefaults.standard
        standardDefaults.setValue(countryCode, forKey: Constants.DEFAULTS_KEY_COUNTRY)
        standardDefaults.setValue(language, forKey: Constants.DEFAULTS_KEY_LANGUAGE)
        standardDefaults.setValue(bnr, forKey: Constants.DEFAULTS_KEY_BNR)
        standardDefaults.setValue(customerNumber, forKey: Constants.DEFAULTS_KEY_CUSTOMER_NUMBER)
        standardDefaults.setValue(userId, forKey: Constants.DEFAULTS_KEY_USER_ID)
        standardDefaults.set(shouldShowEKPrice, forKey: Constants.DEFAULTS_SHOW_EK_PRICE)
        standardDefaults.set(shouldShowEVPPrice, forKey: Constants.DEFAULTS_SHOW_EVP_PRICE)
        standardDefaults.set(shouldShowSellPrice, forKey: Constants.DEFAULTS_SHOW_SELL_PRICE)
        standardDefaults.set(sellPricePercentage, forKey: Constants.DEFAULTS_SELL_PRICE_PERCENTAGE)
        standardDefaults.set(shouldShowTaxes, forKey: Constants.DEFAULTS_SHOW_TAXES)
        standardDefaults.set(taxesPercentage, forKey: Constants.DEFAULTS_TAXES_PERCENTAGE)
        standardDefaults.synchronize()
    }
    func defaultUserSetting() {
        shouldShowEKPrice = true
        shouldShowEVPPrice = true
        shouldShowSellPrice = false
        sellPricePercentage = 0.0
        shouldShowTaxes = false
        taxesPercentage = 0.0
        let standardDefaults = UserDefaults.standard
        standardDefaults.set(shouldShowEKPrice, forKey: Constants.DEFAULTS_SHOW_EK_PRICE)
        standardDefaults.set(shouldShowEVPPrice, forKey: Constants.DEFAULTS_SHOW_EVP_PRICE)
        standardDefaults.set(shouldShowSellPrice, forKey: Constants.DEFAULTS_SHOW_SELL_PRICE)
        standardDefaults.set(sellPricePercentage, forKey: Constants.DEFAULTS_SELL_PRICE_PERCENTAGE)
        standardDefaults.set(shouldShowTaxes, forKey: Constants.DEFAULTS_SHOW_TAXES)
        standardDefaults.set(taxesPercentage, forKey: Constants.DEFAULTS_TAXES_PERCENTAGE)
        standardDefaults.synchronize()
    }
    func logout() {
        WebServiceManager.sharedInstance.countrySelection = IMCountry()
        canOrder = false
        canAccessTracking = false
        sessionId = nil
        password = nil
        isAdmin = false
        isVendor = false
        isStatesAvailable = false
        sessionCookie = nil
        testDate = nil
        searchFilters = nil
        isDropShipAllowed = nil
        useUserCulterSettings = false
        addsShown = nil
        //52344
        isOutage = false
        cookieString = nil
        ads_ImpressionList = nil
        WebServiceManager.sharedInstance.saveID = ""
        WebServiceManager.sharedInstance.securityCode = ""
        WebServiceManager.sharedInstance.resendCode = ""
    }
}
