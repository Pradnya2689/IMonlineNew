//
//  ProductSearchViewCell.swift
//  IMONLINE
//
//  Created by Administrator on 4/12/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class ProductSearchViewCell: UITableViewCell {

    @IBOutlet weak var prodImg: UIImageView!
    @IBOutlet weak var prodDesLbl: UILabel!
    @IBOutlet weak var prodSKULbl: UILabel!
    @IBOutlet weak var prodPriceLbl: UILabel!
    @IBOutlet weak var cartImg: UIImageView!
    @IBOutlet weak var stockLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
