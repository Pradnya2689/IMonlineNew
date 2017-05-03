//
//  IMWebViewController.swift
//  IMOnline
//
//  Created by Administrator on 03/05/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class IMWebViewController: UIViewController {

    @IBOutlet weak var imWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //navigationController?.isNavigationBarHidden = false
        
        let b = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDownload(sender:)))
        self.navigationItem.leftBarButtonItem = b
    }
    
    
    
    func cancelDownload(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
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
