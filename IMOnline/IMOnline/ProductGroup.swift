//
//  ProductGroup.swift
//  IMOnline
//
//  Created by pradnya on 18/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class ProductGroup: NSObject {
    var index:Int!
    var name:String!
    var lengthDiff:Int!
    static let sharedInstance = ProductGroup()
    
    
    enum ProductGroupType: Int {
        case herstellerProductGroupType = 0
        case group1ProductGroupType = 1
        case group2ProductGroupType = 2
        case group3ProductGroupType = 3
        case numberOfProductGroupTypes = 4
    }
   
    convenience override init() {
        self.init(_index: 0, _name: "", _diffLength: 0) // calls above mentioned controller with default name
    }
    
//    func groupSortKey(d1: IMProductGroup,d2: IMProductGroup) -> ComparisonResult {
//        return d1.name!.compare(d2.name!, options: .caseInsensitive)}
    
    func groupCombiSort(d1: IMGroupCombDTO,d2: IMGroupCombDTO,context:Void) -> ComparisonResult {
        return d1.key!.compare(d2.key!, options: .caseInsensitive)
    }
    
//    func groupSort(d1: IMGroupDTO,d2: IMGroupDTO,context:Void) -> ComparisonResult {
//        return d1._id!.compare(d2._id!, options: .caseInsensitive)
//    }
    //class func abc()-> ComparisonResult{
    
       // return groupSortKey
    //}
    let groupSort = { (i: IMGroupDTO,i1: IMGroupDTO) -> ComparisonResult in return i._id!.compare(i1._id!, options: .caseInsensitive) }
    init(_index: Int,_name: String,_diffLength: Int) {
        // if super.init() {
        index = _index
        name = _name
        lengthDiff = _diffLength
        // }
        
    }
     convenience init(index _index: Int, name _name: String) {
             self.init(_index: _index, _name: _name, _diffLength: 0)
            //50489
        }
    
   
    let groupSortKey = { (i: IMProductGroup,i1: IMGroupDTO) -> ComparisonResult in return i.name!.compare(i1.name!, options: .caseInsensitive) }
}
class ProductGroups: NSObject {
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
    var groupSelections:[Int]!
    
    var dirtyProductGroups:NSMutableIndexSet!
    var selectedInOrder:NSMutableArray! = NSMutableArray()
    var numberOfCombinations:Int!
    
    init(string s: String) {
        super.init()
        let _process: Bool = true
        // not longer used
        // Group indicator
        var _grouphaschanged: Bool = false
        var _currentGroupName: String = ""
        
        searchParams = [Int(Constants.ANY_GROUP), Int(Constants.ANY_GROUP), Int(Constants.ANY_GROUP), Int(Constants.ANY_GROUP)]
        // start to find the common index prefix
        findAndSetNumberPrefix(s)
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
        // groupSelections = malloc(4 * MemoryLayout<UInt8>.size)
        reset()
        // initialize productgroups
        
        var val = 4
        productGroups = NSMutableArray()
        for var index in stride(from: 0, to: 4, by: 1){
            productGroups.add([Any]())
        }
        for line: String in lines {
            var origElements: [String] = line.components(separatedBy:";")
            if origElements.count <= 1 {
                break
            }
            var isKombi: Bool = false
            isKombi = line.hasPrefix("KOMBI")
            
            
            var elements = [String]()
            for s: String in origElements as! [String] {
                var replaceRange: NSRange = (s as NSString).range(of: _indexPrefix as String)
                if replaceRange.location != NSNotFound {
                    if !isKombi {
                        elements.append((s as NSString).replacingCharacters(in: replaceRange, with: ""))
                    }
                    else {
                        elements.append(s)
                    }
                }
                else {
                    elements.append(s)
                }
            }
            
            if elements[1].isEqual("X") && elements[2].isEqual("X") {
                currentBlock = elements[0]
                if (currentBlock?.isEqual("KOMBI"))! {
                    kombiCounter = 0
                    numberOfCombinations = Int(elements[4])
                    //groupCombinations = malloc(numberOfCombinations * numberOfProductGroupTypes * sizeof(NSUInteger));
                }
                else if (currentBlock?.isEqual("AKTIONEN"))! {
                    
                }
                else {
                    var currentProductGroupType: ProductGroup.ProductGroupType = productGroupTypefromNSString(s: currentBlock!)
                    currentProductGroup = self.productGroups.object(at: currentProductGroupType.rawValue) as! NSMutableArray
                }
                
                continue
            }
            
            if (currentBlock?.isEqual("KOMBI"))! {
                if numberOfCombinations * 4 <= kombiCounter {
                    break
                }
                // create combinations and save it in a array
                var combi = IMGroupCombi()
                combi.vendor = Int(elements[0])
                combi.group1 = Int(elements[1])
                combi.group2 = Int(elements[2])
                combi.group3 = Int(elements[3])
                sortedGroupCombinations.add(combi)
                kombiCounter += 4
            }
            else {
                //50489
                var index = elements[0]
                var length: Int? = index.characters.count
                var indexLength: Int = "\(index)".characters.count
                var lengthDifference: Int = length! - indexLength
                var name: String? = (elements[1] as? String)
                var group = ProductGroup(_index: Int(index)!, _name: name!, _diffLength: lengthDifference)
                currentProductGroup.add(group)
            }
        }
       // hersteller = hersteller.sortedArray(comparator: { ($0 as! IMProductGroup).name!.compare($1 as! IMProductGroup).name!})
        let sortedArray = hersteller.sorted{ ($0 as! IMProductGroup).name!.compare(($1 as! IMProductGroup).name!, options: .caseInsensitive) == .orderedAscending }
        let sortedArray1 = gruppe1.sorted{ ($0 as! IMProductGroup).name!.compare(($1 as! IMProductGroup).name!, options: .caseInsensitive) == .orderedAscending }
        let sortedArray2 = gruppe2.sorted{ ($0 as! IMProductGroup).name!.compare(($1 as! IMProductGroup).name!, options: .caseInsensitive) == .orderedAscending }
        let sortedArray3 = gruppe3.sorted{ ($0 as! IMProductGroup).name!.compare(($1 as! IMProductGroup).name!, options: .caseInsensitive) == .orderedAscending }
        //origHersteller = hersteller.sorted (by: {($0 as! IMProductGroup).name! < ($1 as! IMProductGroup).name!})
       // hersteller = sorted(by: { ($0 as! IMProductGroup).name! < ($1 as! IMProductGroup).name! })
        //hersteller.sort(using: ProductGroup.sharedInstance.groupSortKey)
        WebServiceManager.sharedInstance.hersteller = hersteller
//        gruppe1.sort(using: groupSortKey)
//        gruppe2.sort(using: groupSortKey)
//        gruppe3.sort(using: ProductGroup.sharedInstance.groupSortKey)
        WebServiceManager.sharedInstance.numberOfGroups3 = gruppe3.count
        origHersteller = sortedArray as! NSMutableArray
        origGruppe1 = sortedArray1 as! NSMutableArray
        origGruppe2 = sortedArray2 as! NSMutableArray
        origGruppe3 = sortedArray3 as! NSMutableArray
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NOTIFICATION_READY_FOR_SEARCH), object: nil)
        //return self
    }
    func groupSortKey(this:IMProductGroup, that:IMProductGroup) -> ComparisonResult {
        return this.name!.compare(that.name!, options: .caseInsensitive)
    }
    func productGroupTypefromNSString( s: String) -> ProductGroup.ProductGroupType {
        if s.isEqual("HERSTELLER") {
            return ProductGroup.ProductGroupType.herstellerProductGroupType
        }
        else if s.isEqual("GRUPPE1") {
            return ProductGroup.ProductGroupType.group1ProductGroupType
        }
        else if s.isEqual("GRUPPE2") {
            return ProductGroup.ProductGroupType.group2ProductGroupType
        }
        else if s.isEqual("GRUPPE3") {
            return ProductGroup.ProductGroupType.group3ProductGroupType
        }
        
        // assert(false, "productGroupTypeFromNSString should never reach this line")
        return ProductGroup.ProductGroupType(rawValue: -1)!
    }
    
    func reset() {
        // make sure this works also from init..
        for i in 0..<4 {
            groupSelections[i] = Constants.ANY_GROUP
        }
        selectedInOrder = NSMutableArray()
        resetDirtyProductGroups()
    }
    func resetDirtyProductGroups() {
        dirtyProductGroups = NSMutableIndexSet()
        for i in 0..<4 {
            dirtyProductGroups.add(i)
        }
    }
    func findAndSetNumberPrefix(_ _s: String) {
        _indexPrefix = ""
        // fetch all id's in a array
        var ar: [String] = fetchIds(_s)
        // start to determine the common index Prefix
        getPosArEquals(_pos: 1, idArray: ar)
    }
    func fetchIds(_ s: String) -> [String] {
        let _lines: [String] = s.components(separatedBy: CharacterSet.newlines)
        var ar = [String]()
        for line: String in _lines {
            let elements: [String] = line.components(separatedBy: ";")
            if elements[0].hasPrefix("HERSTELLER") || elements[0].hasPrefix("GRUPPE") {
                continue
            }
            if elements[0].hasPrefix("KOMBI") {
                break
            }
            ar.append(elements[0])
        }
        return ar
    }
    func getPosArEquals(_pos: Int, idArray _ar: [String]) -> Int {
        var set = [AnyObject]()
        var ret: Int = 0
        var position = _pos
        if _ar.count > 0 {
           // (index, element)
            for (index, s) in _ar.enumerated() {
                var substr = (s as? NSString)?.substring(to: _pos) as! NSString
                set.insert(substr, at: index)
            }
            if set.count > 1 {
                // index prefix found
                var datastr = _ar[0] as NSString
                _indexPrefix = datastr.substring(to: _pos - 1) as NSString!
                //DLog("found _indexPrefix %@ ", indexPrefix)
                return -1
            }
            else {
                position += 1
                // if not founed start getPosArEquals recursiv
                if ret != -1 {
                    ret = getPosArEquals(_pos: position, idArray: _ar)
                }
            }
        }
        return ret
    }

}


