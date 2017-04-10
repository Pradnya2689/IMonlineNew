//
//  CountrySearchTableViewCell.swift
//  IMOnline
//
//  Created by Administrator on 07/04/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class CountrySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameLB: UILabel!
    @IBOutlet weak var flagImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
