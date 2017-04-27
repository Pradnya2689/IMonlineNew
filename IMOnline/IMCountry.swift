//
//  IMCountry.swift
//  IMOnline
//
//  Created by inpanr07 on 17/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class IMCountry: NSObject {
    //static let sharedInstance = IMCountry()
    
    var countryId: String = ""
    var name: String = ""
    var languageCode: String = ""
    var environmentType: String = ""
    var decimalSeprator: String = ""
    var thousandSeprator: String = ""
    var currencySymbol: String = ""
    var countryEnvironmentType : String = ""
    var functionList = [Any]()
    
   
    
    
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
