//
//  SplashViewController.swift
//  IMOnline
//
//  Created by Administrator on 10/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var mapImgView: UIImageView!
    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var imgStackView: UIStackView!
    
    var country:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.isNavigationBarHidden = true
        
        // FETCH COUNTRY
        let localIdentifier = Locale.current.identifier //returns identifier of your telephones country/region settings
        
        let locale = NSLocale(localeIdentifier: localIdentifier)
        //if u want a special identifier use that
        //let locale = NSLocale(localeIdentifier: "en_US")
        if let countryCode = locale.object(forKey: .countryCode) as? String {
            
            if let country = locale.displayName(forKey: .countryCode, value: countryCode) {
                print(country)
            }
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.logoImgView.alpha = 0.0
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
 
        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.logoImgView.alpha = 1.0
            
        }, completion:  { finished in
            
            if finished {
                
                UIView.animate(withDuration: 2.0, delay: 1.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    
                    if #available(iOS 10.0, *) {
                        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "search") as! CountrySearchViewController
                        nextView.isCall = "SplashView"
                        self.navigationController?.pushViewController(nextView, animated: true)
                    } else {
                        // Fallback on earlier versions
                       // let nextView = self.storyboard?.ini
                        
                    }
                    
                    
                }, completion: nil)
                
            }
            
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
