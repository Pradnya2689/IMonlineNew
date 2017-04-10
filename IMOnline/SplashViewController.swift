//
//  SplashViewController.swift
//  IMOnline
//
//  Created by Administrator on 10/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    
    @IBOutlet weak var selectStateButton: UIButton!
    @IBOutlet weak var mapImgView: UIImageView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBAction func selectStateBtnAction(_ sender: UIButton) {
        
        let nextView = storyboard?.instantiateViewController(withIdentifier: "search") as! CountrySearchViewController
        navigationController?.present(nextView, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         navigationController?.isNavigationBarHidden = true
       
       // self.selectStateButton.titleLabel?.textAlignment = .left
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.logoImgView.alpha = 0.0
         self.mapImgView.alpha = 0.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, delay: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.logoImgView.alpha = 1.0
            self.mapImgView.alpha = 1.0
        }, completion: nil)
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
