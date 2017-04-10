//
//  CountrySearchViewController.swift
//  IMOnline
//
//  Created by Administrator on 06/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class CountrySearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate {
    @IBOutlet weak var countrySearchTableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var countryNameAAray = ["AUSTRALIA","CROATIA","ENGLAND","FRANCE","ICELAND","JORDAN"]
    var flagArray = ["Australia","Croatia","England","France","Iceland","Jordan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //        tap.delegate = self
        //        view.addGestureRecognizer(tap)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil){
        searchTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Tableview Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countrySearchCellId", for: indexPath) as! CountrySearchTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.flagImgView.image = UIImage(named: flagArray[indexPath.row])
        cell.countryNameLB.text = countryNameAAray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true, completion: nil)
        
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
