//
//  FavoritesTableViewCell.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/7/29.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
