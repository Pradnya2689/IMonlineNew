//
//  ProductGroup.swift
//  IMOnline
//
//  Created by pradnya on 18/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit






class ProductGroup: NSObject {
//    enum ProductGroupType : Int {
//        case herstellerProductGroupType = 0
//        case group1ProductGroupType
//        case group2ProductGroupType
//        case group3ProductGroupType
//        case numberOfProductGroupTypes
//    }
    
    enum ProductGroupType: Int {
        case herstellerProductGroupType = 0, group1ProductGroupType, group2ProductGroupType, group3ProductGroupType,numberOfProductGroupTypes
    }
    
    var hersteller = NSMutableArray()
    var gruppe1 = NSMutableArray()
    var gruppe2 = NSMutableArray()
    var gruppe3 = NSMutableArray()
    var origHersteller = NSMutableArray()
    var origGruppe1 = NSMutableArray()
    var origGruppe2 = NSMutableArray()
    var origGruppe3 = NSMutableArray()
    var searchParams = NSMutableArray()
    var sortedGroupCombinations = NSMutableArray()
    var _indexPrefix:NSString!
    var anySelectionProductGroup:ProductGroup!
    var productGroups:NSMutableArray!
    var groupSelections:Int!
    var index:Int!
    var name:String!
    var lengthDiff:Int!
    var dirtyProductGroups:NSMutableIndexSet!
    var selectedInOrder:NSMutableArray! = NSMutableArray()
    func groupSortKey(_ d1: IMProductGroup, _ d2: IMProductGroup) -> ComparisonResult {
        return d1.name!.compare(d2.name!, options: .caseInsensitive)
    }
    func groupCombiSort(_ d1: IMGroupCombDTO, _ d2: IMGroupCombDTO) -> ComparisonResult {
        return d1.key!.compare(d2.key!, options: .caseInsensitive)
    }
    
    func groupSort(_ d1: IMGroupDTO, _ d2: IMGroupDTO) -> ComparisonResult {
        return d1._id!.compare(d2._id!, options: .caseInsensitive)
    }

    init(_index: Int,_name: String,_diffLength: Int) {
        
            index = _index
            name = _name
            lengthDiff = _diffLength
       
    }
    init(string s: String) {
        super.init()
            let _process: Bool = true
            // not longer used
            // Group indicator
            var _grouphaschanged: Bool = false
            var _currentGroupName: String = ""
        
        searchParams = [Int(Constants.ANY_GROUP), Int(Constants.ANY_GROUP), Int(Constants.ANY_GROUP), Int(Constants.ANY_GROUP)]
        // start to find the common index prefix
        self.findAndSetNumberPrefix(s)
        if(_process){
        var _lines: [Any] = s.components(separatedBy: CharacterSet.newlines)
        var i: Int = 0
        // initialize all collections
        sortedGroupCombinations = NSMutableArray()
        // Vendor
        
            hersteller.add(IMProductGroup(string: "-", _prodId: Constants.ANY_GROUP))
            gruppe1.add(IMProductGroup(string: "-", _prodId: Constants.ANY_GROUP))
            gruppe2.add(IMProductGroup(string: "-", _prodId: Constants.ANY_GROUP))
            gruppe3.add(IMProductGroup(string: "-", _prodId: Constants.ANY_GROUP))

            for line: String in _lines as! [String]{
                
                var origElements: [String] = line.components(separatedBy:";")
                // create a new array for save modified data
                var elements = [String]()
                if (origElements[0] == "KOMBI") {
                    break
                }

                
                for s: String in origElements {
                    var replaceRange: NSRange = (s as NSString).range(of: _indexPrefix as String)
                    if replaceRange.location != NSNotFound {
                        elements.append((s as NSString).replacingCharacters(in: replaceRange, with: ""))
                    }
                    else {
                        elements.append(s)
                    }
                }
                
                if !(elements[0] == "") {
                    if elements[0].hasPrefix("HERSTELLER") {
                        _grouphaschanged = !(elements[0] == _currentGroupName)
                        _currentGroupName = elements[0]
                        i = 0
                        continue
                    }
                }
                if elements[0].hasPrefix("GRUPPE") {
                    _grouphaschanged = !(elements[0] == _currentGroupName)
                    _currentGroupName = elements[0]
                    i = 0
                    continue
                }
                
                 if(_grouphaschanged){
                    if (_currentGroupName == "HERSTELLER") {
                        if IMHelper.isNumeric(elements[0]) {
                            hersteller.add(IMProductGroup(string: IMHelper.trimString(elements[1]), _prodId: Int(elements[0])!))
                            i += 1
                        }
                    }
                    if (_currentGroupName == "GRUPPE1") {
                        if IMHelper.isNumeric(elements[0]) {
                            gruppe1.add(IMProductGroup(string: IMHelper.trimString(elements[1]), _prodId: Int(elements[0])!))
                            i += 1
                        }
                    }
                    if (_currentGroupName == "GRUPPE2") {
                        if IMHelper.isNumeric(elements[0]) {
                            gruppe2.add(IMProductGroup(string: IMHelper.trimString(elements[1]), _prodId: Int(elements[0])!))
                            i += 1
                        }
                    }
                    if (_currentGroupName == "GRUPPE3") {
                        if IMHelper.isNumeric(elements[0]) {
                            gruppe3.add(IMProductGroup(string: IMHelper.trimString(elements[1]), _prodId: Int(elements[0])!))
                            i += 1
                        }
                    }
                    
                }
                
            }
        }
        
        
        var lines: [String] = s.components(separatedBy: CharacterSet.newlines)
        var currentBlock: String? = nil
        var kombiCounter: Int = 0
        var currentProductGroup = NSMutableArray()
        anySelectionProductGroup = ProductGroup(_index: -1, _name: "-", _diffLength: 0)
        //50489
        //malloc(width * height * MemoryLayout<UInt8>.size)!.assumingMemoryBound(to: UInt8.self)
       // groupSelections = malloc(ProductGroupType.numberOfProductGroupTypes * MemoryLayout<UInt8>.size)
        //reset()
        // initialize productgroups
        
//        var val = ProductGroupType.numberOfProductGroupTypes
//        productGroups = NSMutableArray()
//        for var index in stride(from: 0, to: val, by: 1){
//            productGroups.add([Any]())
//        }
//
//        
//        hersteller.sort(using: groupSortKey)
//        WebServiceManager.sharedInstance.hersteller = hersteller
//        gruppe1.sort(using: groupSortKey)
//        gruppe2.sort(using: groupSortKey)
//        gruppe3.sort(using: groupSortKey)
//        WebServiceManager.sharedInstance.numberOfGroups3 = gruppe3.count
//        origHersteller = hersteller
//        origGruppe1 = gruppe1
//        origGruppe2 = gruppe2
//        origGruppe3 = gruppe3
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NOTIFICATION_READY_FOR_SEARCH), object: nil)
      //  return self
    }
    func reset() {
        // make sure this works also from init..
//        for i in 0..<ProductGroupType.numberOfProductGroupTypes {
//            groupSelections[i] = ANY_GROUP
//        }
//        selectedInOrder = [Any]()
//        resetDirtyProductGroups()
    }
    func resetDirtyProductGroups() {
//        dirtyProductGroups = IndexSet()
//        for i in 0..<numberOfProductGroupTypes {
//            dirtyProductGroups.insert(i)
//        }
    }

    func findAndSetNumberPrefix(_ _s: String) {
        _indexPrefix = ""
        // fetch all id's in a array
//        var ar: [Any] = fetchIds(_s)
//        // start to determine the common index Prefix
//        getPosArEquals(1, idArray: ar)
    }
}
