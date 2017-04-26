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
    var selectedcountry = NSString()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.countryBtn.setTitle("", for: UIControlState.normal)
        self.countryBtn.setTitle(selectedcountry as String, for: UIControlState.normal)
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
    func loginService(userid:String,password:String){
        var user = WebServiceManager.sharedInstance.user
        
        user.userId = userid
        user.password = password
        user.language = "EN"
        user.countryCode = "MX"
        
        
        //For endavour contry
        if("E" == Constants.ENV_ENDEAVOUR){
            
        }
        
        WebServiceManager.sharedInstance.loginWebservice(withCompletionBlock: { (_: [Any]) in
            
        }, failedBlock: {() -> Void in
        })
    }
    func showAlert(messageToShow:String){
        let alertView:UIAlertView = UIAlertView()
        alertView.title = ""
        alertView.message = messageToShow
        alertView.delegate = nil
        alertView.addButton(withTitle: "OK")
        alertView.show()
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
