//
//  CafeTableViewCell.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/6/7.
//

import UIKit

class CafeTableViewCell: UITableViewCell {

    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var limitTimeLabel: UILabel!
    @IBOutlet weak var collectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
