//
//  ProductSearchViewController.swift
//  IMONLINE
//
//  Created by Administrator on 4/12/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class ProductSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
extension ProductSearchViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductSearchViewCell
        
    //dynamically fetching information
        cell.prodImg.image = UIImage(named: "monitor")
        cell.prodDesLbl.text = "Monitor Acer V196HQLbd (UM.XV6 SS.002) 18.5 inch 1366x768 LED"
        cell.prodSKULbl.text = "SKU : 1245ABCD | VPN : 6598SDAD"
        cell.cartImg.image = UIImage(named: "iconMike64")
        cell.prodPriceLbl.text = "$ 600.00"
        cell.stockLbl.clipsToBounds = true
        cell.stockLbl.layer.cornerRadius = 6
        
        return  cell
    }
}
