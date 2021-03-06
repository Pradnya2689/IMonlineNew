//
//  ViewController.swift
//  IMOnline
//
//  Created by Administrator on 06/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import LocalAuthentication

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
    
      let reachability = Reachability()!
    
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
    
    
    func reachabilityChanged(_ sender: NSNotification) {
        
        
        
        let reachability = sender.object as! Reachability
        
        
        if (reachability.isReachable)
        {
            print("Internet Connection Available!")
            
        }
        else
        {
            
            print("Internet Connection not Available!")
            
            
        }
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        
        //navigationController?.isNavigationBarHidden = false
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
            
        
           self.loginService(userid: usernameTF.text!, password: passwordTF.text!)

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
             user.bnr = ""
            user.countryCode = ""
            user.customerNumber = ""
        }
        
        //For endavour contry
        if("E" == Constants.ENV_ENDEAVOUR){
                    }
        
        else if("L" == Constants.ENV_LEGACY)
        {
        
        }
        WebServiceManager.sharedInstance.loginWebservice(withCompletionBlock: { (_: [Any]) in
          //  self.noInternetVC.isHidden = true
            self.showAlert(messageToShow: "Login success")
        }, failedBlock: {(_ str: String) in
            self.showAlert(messageToShow: str)
           // self.noInternetVC.isHidden = false
        })

       
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
  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func conditionUseBtnAction(_ sender: UIButton) {
        
//        let webView = storyboard?.instantiateViewController(withIdentifier: "webView") as! IMWebViewController
//        navigationController?.present(webView, animated: true, completion: nil)
        
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "webView") as! IMWebViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)
        
    }
    
    @IBAction func contectUsBtnAction(_ sender: UIButton) {
        
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "webView") as! IMWebViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.present(navController, animated:true, completion: nil)

        
    }
    // MARK: - TouchID Functions
    
//    func authenticateUser(){
//        
//        // Get the local authentication context.
//        let context : LAContext = LAContext()
//        
//        // Declare a NSError variable.
//        var error: NSError?
//        
//        // Set the reason string that will appear on the authentication alert.
//        var reasonString = "Authentication is needed to login App."
//        
//        // Check if the device can evaluate the policy
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Identify yourself!"
//            
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
//                [unowned self] success, authenticationError in
//                
//                DispatchQueue.main.async {
//                    if success {
//                        
//                        self.isTouchIDAuthenticated = true
//                        
//                        if self.launchedBefore  {
//                            let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "myKey")
//                            
//                            if(retrievedPassword != nil){
//                                
//                                print("SUCCESSFUL")
//                                
//                                var userInfoString = retrievedPassword! as String
//                                
//                                //userCredentialsArray = retrievedPassword componentsSeparatedByString:@"^"
//                                
//                                self.userCredentialsArray = retrievedPassword!.components(separatedBy: "^")
//                                
//                                
//                                if(self.userCredentialsArray.count > 0)
//                                {
//                                    
//                                    print(self.userCredentialsArray)
//                                    
////                                    let nextView = self.storyboard?.instantiateViewController(withIdentifier: "nextView") as! NextViewController
////                                    self.navigationController?.pushViewController(nextView, animated: true)
//                                    
//                                }
//                                
//                                
//                                
//                            }
//                        } else {
//                            //if(username password not saved)
//                            
//                            let alertVC = UIAlertController(title: "", message: "To login with your fingerprint register your credentials.", preferredStyle: .alert)
//                            
//                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                            alertVC.addAction(okAction)
//                            
//                            self.present(alertVC, animated: true, completion: nil)
//                            
//                            self.usernameTF.isHidden = false
//                            self.passwordTF.isHidden = false
//                            self.loginBtn.isEnabled = true
//                            UserDefaults.standard.set(true, forKey: "launchedBefore")
//                        }
//                        
//                        
//                    } else {
//                        
//                        if let error = (authenticationError as? NSError) {
//                            
//                            let message = self.errorMessageForLAErrorCode(errorCode: error.code)
//                            self.showAlertWithTitle(title: "TOUCH ID for App", message: message)
//                            
//                            self.usernameTF.isHidden = false
//                            self.passwordTF.isHidden = false
//                            self.loginBtn.isEnabled = true
//                        }
//                        
//                    }
//                }
//            }
//        }
//        else{
//            // If the security policy cannot be evaluated then show a short message depending on the error.
//            switch error!.code{
//                
//            case LAError.touchIDNotEnrolled.rawValue:
//                print("TouchID is not enrolled")
//                
//            case LAError.passcodeNotSet.rawValue:
//                print("A passcode has not been set")
//                
//            default:
//                // The LAError.TouchIDNotAvailable case.
//                print("TouchID not available")
//            }
//            
//            // Optionally the error description can be displayed on the console.
//            print(error?.localizedDescription)
//            
//            // Show the custom alert view to allow users to enter the password.
//            
//            self.usernameTF.isHidden = false
//            self.passwordTF.isHidden = false
//            self.loginBtn.isEnabled = true
//            
//        }
//        
//    }
//    
//    
//    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
//        
//        var message = ""
//        
//        switch errorCode {
//            
//        case LAError.appCancel.rawValue:
//            message = "Authentication was cancelled by application"
//            
//        case LAError.authenticationFailed.rawValue:
//            message = "The user failed to provide valid credentials"
//            
//        case LAError.invalidContext.rawValue:
//            message = "The context is invalid"
//            
//        case LAError.passcodeNotSet.rawValue:
//            message = "Passcode is not set on the device"
//            
//        case LAError.systemCancel.rawValue:
//            message = "Authentication was cancelled by the system"
//            
//        case LAError.touchIDLockout.rawValue:
//            message = "Too many failed attempts."
//            
//        case LAError.touchIDNotAvailable.rawValue:
//            message = "TouchID is not available on the device"
//            
//        case LAError.userCancel.rawValue:
//            message = "The user did cancel"
//            
//        case LAError.userFallback.rawValue:
//            message = "The user chose to use the fallback"
//            
//        default:
//            message = "Did not find error code on LAError object"
//            
//        }
//        
//        return message
//        
//    }
//    
//    
//    func showAlertWithTitle( title:String, message:String ) {
//        
//        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alertVC.addAction(okAction)
//        
//        self.present(alertVC, animated: true, completion: nil)
//        
//    }
    
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
