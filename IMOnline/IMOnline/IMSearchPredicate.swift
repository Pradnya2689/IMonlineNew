//
//  IMSearchPredicate.swift
//  IMOnline
//
//  Created by pradnya on 19/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//
import UIKit
class IMSearchPredicate: NSObject {

    
    var text:String!
    
    var hersteller:String!
    var group1:String!
    var group2:String!
    var group3:String!
    
    var aktion: Bool!
    var onlyAK:Bool!
    var onlyAV:Bool!
    var onlyNew:Bool!
    var onlyOut:Bool!
    var onlyBStock:Bool!
    
    var onOrder:Bool!
    var onlyLicenseProducts:Bool!
    var onlyDiscontinuedProducts:Bool!
    var onlyStockOrOnOrderProducts:Bool!
    var onlyDirectshipmentProducts:Bool!
    
    var page:Int!
    var rowsPerPage:Int!
    var searchType:String!
}
