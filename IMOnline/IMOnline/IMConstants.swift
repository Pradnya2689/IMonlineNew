//
//  IMConstants.swift
//  IMOnline
//
//  Created by pradnya on 10/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import Foundation
struct Constants {
    //App Constants
    static let APP_NAME = "IMOnline"
    static let ENV_DACH = "D"
    static let ENV_ENDEAVOUR = "E"
    static let ENV_LEGACY = "L"
    static let ENV_SAP = "S"
    static let ENV_IMPULSE = "I"
    
    static let PRODUCT_GROUPS_FILE = "productGroups.txt"
    static let DEFAULTS_KEY_PRODUCTGROUPS_REMEMBERED_AT_DATE = "productGroupsRememberedAtDate"
    static let PRODUCTGROUPS_TIMEOUT_IN_SECONDS = 60*60*24
    static let DEFAULT_REQUEST_TIMEOUT = 95
    static let CONTENTYPE  = "Content-Type"
    static let CONTENTYPE_VALUE = "application/mobile"
    static let CONTENTTYPE_JSON = "application/json"
    
    static let SESSION_COOKIE_NAME = ".ASPXAUTHMobile"
    static let US_SESSION_COOKIE_NAME = "IMGlobalWebAuthCookieMobile"
    
    
    
    //pragma mark base url's
    
    /// Stage 1 DEV
    static let HOST_URL = "https://mobility-stg.ingrammicro.com"
    
    
    static let URL_GET_COUNTRY_LIST  = "\(HOST_URL)/Dispatcher/Countrylist/"
    
    // Stage 2 DEV
    //static let HOST_URL = "https://mobility-stg2.ingrammicro.com"
    
    // Stage 3 DEV
    //static let HOST_URL = "https://mobility-stg3.ingrammicro.com"
    
    //Prod Chicago
    //static let HOST_URL = "https://mobile-ch.ingrammicro.com"
    
    //ab 29.10.12 verfügbar #define HOST_URL @"https://mobile.ingrammicro.com"
    //static let HOST_URL = "https://mobile-ff.ingrammicro.com"
    //static let HOST_URL = "https://mobile-sg.ingrammicro.com"
    
    /////////////////////////////////////////////////////////////
    // Old service URLs
    /////////////////////////////////////////////////////////////
    
    static let URL_GET_SESSION = "https://www.ingrammicro.de/cgi-bin/mobile.dev/m_get_sessionid.pl?CCD=%@&LANG=%@&BNR=%@&KNR=%@&UID=%@&SID=&RESSEP=%%3B"
    
    static let URL_LOGIN = "https://www.ingrammicro.de/cgi-bin/mobile.dev/m_login.pl?CCD=%@&LANG=%@&BNR=%@&KNR=%@&UID=%@&SID=%@&DID=&RESSEP=%%3B&REAL=0&MAXROW=1000&KEY=%@&TS=%@"
    
    static let URL_VENDOR_GROUPS = "https://www.ingrammicro.de/cgi-bin/mobile.dev/m_get_combi.pl?CCD=%@&LANG=%@&BNR=%@&KNR=%@&UID=%@&SID=%@&DID=&RESSEP=%%3B&SEARCH=ALL&TS=%@"
    
    static let URL_SETTINGS = "https://www.ingrammicro.de/cgi-bin/mobile.dev/m_get_settings.pl?CCD=%@&LANG=%@&BNR=%@&KNR=%@&UID=%@&SID=%@&RESSEP=%%3B&APP=IM.ORDER&TS=%@"
    
    // alter Service für die country/bnr Liste
    static let URL_DACH_GET_COUNTRY_BRNS = "http://www.ingrammicro.de/cgi-bin/mobile.dev/m_get_login.pl?CCD=&UID=000&SID=&RESSEP=%3B&TS="
    
    
    /////////////////////////////////////////////////////////////
    // DACH REST Services URLs
    /////////////////////////////////////////////////////////////
    //#define URL_LOGIN_DACH HOST_URL@"/1.0.0.0/Session/Login/?AGENT=%@&APPVERSION=%@&CONNECTIONTYPE=%@&DEVICE=%@&OSVERSION=%@&ccd=%@&bnr=%@&knr=%@&uid=%@&sid=%@&lang=DE&search=ALL&country=MX&password=%@"
    static let URL_LOGIN_DACH = "\(HOST_URL)/1.0.0.0/Session/Login/?AGENT=%@&APPVERSION=%@&CONNECTIONTYPE=%@&DEVICE=%@&OSVERSION=%@&ccd=%@&bnr=%@&knr=%@&uid=%@&sid=%@&lang=DE&search=ALL&country=MX&password=%@&deviceid=%@&saveid=%@&securitycode=%@&resendcode=%@"
    
    static let URL_GET_SESSION_DACH = "\(HOST_URL)/1.0.0.0/Session/?AGENT=%@&APPVERSION=%@&CONNECTIONTYPE=%@&DEVICE=%@&OSVERSION=%@&ccd=%@&bnr=%@&knr=%@&uid=%@&username=&lang=%@&password=%@&country=%@"
    
    static let URL_COUNTRY_BNR_DACH = "\(HOST_URL)/1.0.0.0/Settings/?AGENT=%@&APPVERSION=%@&CONNECTIONTYPE=%@&DEVICE=iphone&OSVERSION=%@&sid=%@&lang=%@&country=%@&id=LOGIN_SETTINGS"
    
    static let URL_PRODUCT_SEARCH = "\(HOST_URL)/1.0.0.0/Productsearch/"
    
    static let URL_SETTINGS_REST = "\(HOST_URL)/1.0.0.0/Settings/ReadLocalSettingsList/?AGENT=iphone&APPVERSION=3.0&CONNECTIONTYPE=wifi&DEVICE=iphone&OSVERSION=5.0&ccd=%@&bnr=%@&knr=%@&uid=%@&sid=%@&lang=%@&country=MX"
    
    /////////////////////////////////////////////////////////////
    // Endeavour REST Services URLs
    /////////////////////////////////////////////////////////////
    
    static let URL_GET_FUNCTION_LIST = "\(HOST_URL)/Dispatcher/Functionlist/"
    static let URL_GET_COUNTRY_LIST1 = "\(HOST_URL)/Dispatcher/Countrylist/"
    
    static let SEARCH_BTN = "SEARCH"
    static let BASKET_BTN = "BASKET"
    static let SUPPLIES_SEARCH_BTN = "SUPPILESSEARCH"
    static let MYPRODUCTS_BTN = "MYPRODUCTS"
    static let SCANNER_BTN = "SCANNER"
    static let TRACKING_BTN = "TRACKING"

//IMHELPER
//    static let SESSION_COOKIE_NAME = ".ASPXAUTHMobile"
//    static let US_SESSION_COOKIE_NAME = "IMGlobalWebAuthCookieMobile"
    static let DOMAIN_URI = "www.ingrammicro.de"
    static let COOKIE_URI = "ingrammicro.com"
    
    
//    static let SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
//    #define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
//    #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//    #define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//    #define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
    
//User
    
    static let DEFAULTS_KEY_COUNTRY = "countryCode"
    static let DEFAULTS_KEY_LANGUAGE = "language"
    static let DEFAULTS_KEY_BNR = "bnr"
    static let DEFAULTS_KEY_CUSTOMER_NUMBER = "customerNumber"
    static let DEFAULTS_KEY_USER_ID = "userId"
    
    static let DEFAULTS_SHOW_EK_PRICE = "showEKPrice"
    static let DEFAULTS_SHOW_EVP_PRICE = "showEVPPrice"
    static let DEFAULTS_SHOW_SELL_PRICE = "showSellPrice"
    static let DEFAULTS_SELL_PRICE_PERCENTAGE = "sellPricePercentage"
    static let DEFAULTS_SHOW_TAXES = "showTaxes"
    static let DEFAULTS_TAXES_PERCENTAGE = "taxesPercentage"
    static let DEFAULT_CURRENCY = "EUR"
    
    static let FILTER_AVAILABLE = "SEARCH_ONLY_AVAILABLE"
    static let FILTER_PROMOTIONS = "SEARCH_ONLY_PROMOTIONS"
    static let FILTER_NEW = "SEARCH_ONLY_NEW"
    static let FILTER_STOCKORORDER = "SEARCH_ONLY_STOCKORORDER"
    static let FILTER_LICENSE = "SEARCH_ONLY_LICENSE"
    static let FILTER_DISCONTINUED = "SEARCH_ONLY_DISCONTINUED"
    
}

func clearAllDefaults(){
    
}

