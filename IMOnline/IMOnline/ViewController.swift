//
//  ViewController.swift
//  IMOnline
//
//  Created by Administrator on 06/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
var selectedcountry = NSString()

class ViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var passUnderLineLB: UILabel!
    @IBOutlet weak var nameUnderLineLabel: UILabel!
    @IBOutlet weak var countryBtn: UIButton!
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var forgotPassBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet var noInternetVC:UIView!
    
    @IBAction func countryBtnAction(_ sender: UIButton) {
        
        if #available(iOS 10.0, *) {
            let nextView = storyboard?.instantiateViewController(withIdentifier: "search") as! CountrySearchViewController
            nextView.isCall = "loginView"
            navigationController?.present(nextView, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       print(selectedcountry)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        navigationController?.isNavigationBarHidden = true
        
        //create gradient effect
        self.countryBtn.applyGradient(colours: [UIColor(red: 236.0/255, green: 243.0/255, blue: 255.0/255, alpha: 1.0), UIColor(red: 216.0/255.0, green: 230.0/255.0, blue: 255.0/255.0, alpha: 1.0)])
        self.countryBtn.setImage(UIImage.init(named: "Australia"), for: .normal)
        self.countryBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -50, bottom: 0, right: 0)
        self.countryBtn.bringSubview(toFront: self.countryBtn.imageView!)
        
        // rounded corners for button code
        loginBtn.layer.cornerRadius = 20; // this value vary as per your desire
        loginBtn.clipsToBounds = true

        countryBtn.layer.cornerRadius = 10; // this value vary as per your desire
        countryBtn.clipsToBounds = true
        countryBtn.layer.borderWidth = 1
        countryBtn.layer.borderColor = UIColor(red: 188.0/255, green: 188.0/255, blue: 188.0/255, alpha: 1.0).cgColor
        
        //for iphone 5
        if(screenWidth == 320){
            arrowImgView.translatesAutoresizingMaskIntoConstraints = true
            
            arrowImgView.frame = CGRect(x:(Int((screenWidth-countryBtn.frame.width)/2)+Int(countryBtn.frame.width-30)), y: Int(countryBtn.frame.origin.y+countryBtn.frame.height/2), width: 15, height: 15)
        }
        
    }
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil){
        usernameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        return true
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
        
        var contentInset:UIEdgeInsets = self.loginScrollView.contentInset
        contentInset.bottom = keyboardSize.height
        self.loginScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.loginScrollView.contentInset = UIEdgeInsets.zero
        self.loginScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    override func viewDidAppear(_ animated: Bool) {
        self.countryBtn.setTitle("", for: UIControlState.normal)
        self.countryBtn.setTitle(selectedcountry as String, for: UIControlState.normal)
    }
    override func viewWillAppear(_ animated: Bool) {
       
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
    }
    
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        nameUnderLineLabel.backgroundColor = UIColor(red: 21.0/255.0, green: 75.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        passUnderLineLB.backgroundColor = UIColor(red: 21.0/255.0, green: 75.0/255.0, blue: 173.0/255.0, alpha: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        nameUnderLineLabel.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        passUnderLineLB.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }
    
    @IBAction func loginClicked(){
        if(usernameTF.text == "" && passwordTF.text == ""){
            showAlert(messageToShow: "Please enter username, password field.")
        }else{
            loginService(userid: usernameTF.text!, password: passwordTF.text!)
        }

    }
    func preferedLanguage() -> String {
        return NSLocale.preferredLanguages[0]
    }
    func loginService(userid:String,password:String){
        var user : IMUser! = WebServiceManager.sharedInstance.user
        
        user.userId = userid
        user.password = password
        user.language = preferedLanguage()
        user.countryCode = WebServiceManager.sharedInstance.countrySelection.countryId
        if WebServiceManager.sharedInstance.countrySelection != nil && (!(WebServiceManager.sharedInstance.countrySelection.environmentType == Constants.ENV_DACH)) {
            // user.userId = self.userIdLabelLegacy.text;////Check it and include in login UI
            user.bnr = ""
            user.countryCode = ""
            user.customerNumber = ""
        }
        
        //For endavour contry
        if("E" == Constants.ENV_ENDEAVOUR){
            WebServiceManager.sharedInstance.loginWebservice(withCompletionBlock: { (_: [Any]) in
                 self.noInternetVC.isHidden = true
            }, failedBlock: {() -> Void in
                 self.noInternetVC.isHidden = false
            })
        }
        
        else if("L" == Constants.ENV_LEGACY)
        {
        
        }
        
       
    }
    
    func getVisibleElements(byFunctions _functions: [IMFunctionList]) -> NSMutableArray {
        /*
         PRODUCTSEARCH
         SCANNER
         TRACKING
         BASKET
         */
        let functionMap = NSMutableDictionary()
        functionMap["ORDER"] = [Constants.BASKET_BTN]
        functionMap["TRACKING"] = [Constants.TRACKING_BTN]
        functionMap["SCANNER"] = [Constants.SCANNER_BTN]
        //amit.p 46192
        let visibleItems: NSMutableArray = [Constants.SEARCH_BTN]
        for  funcs : IMFunctionList in (_functions as? [IMFunctionList])!{
            if (functionMap.object(forKey: funcs.groupName) != nil) {
                let elements: NSArray? = (functionMap[ funcs.groupName] as? NSArray)
                //                DLog(@"->found function for %@",func.groupName );
                for en in elements! {
                    visibleItems.add(en as! String)
                    //                    DLog(@"+ add element for %@ to menu",func.groupName );
                }
            }
        }
        if visibleItems.count > 3 {
            if (visibleItems as NSArray).index(of: "SCANNER") != NSNotFound {
                let indexScanner: Int = (visibleItems as NSArray).index(of: "SCANNER")
                let el1: String? = (visibleItems[indexScanner] as? String)
                visibleItems[indexScanner] = visibleItems[3]
                visibleItems[3] = el1
            }
            if (visibleItems as NSArray).index(of: "BASKET") != NSNotFound && (visibleItems as NSArray).index(of: "TRACKING") != NSNotFound {
                let index1: Int = (visibleItems as NSArray).index(of: "BASKET")
                let index2: Int = (visibleItems as NSArray).index(of: "TRACKING")
                if index1 > index2 {
                    let el: String? = (visibleItems[index1] as? String)
                    visibleItems[index1] = visibleItems[index2]
                    visibleItems[index2] = el
                }
            }
        }
        return visibleItems;
    }
    
    
    
    func showAlert(messageToShow:String){
        let alertView:UIAlertView = UIAlertView()
        alertView.title = ""
        alertView.message = messageToShow
        alertView.delegate = nil
        alertView.addButton(withTitle: "OK")
        alertView.show()
    }
    @IBAction func retrybtnClk(){
        self.noInternetVC.isHidden = true
        if(usernameTF.text == "" && passwordTF.text == ""){
            showAlert(messageToShow: "Please enter username, password field.")
        }else{
            loginService(userid: usernameTF.text!, password: passwordTF.text!)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
// MARK: - gradient functionality
extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
