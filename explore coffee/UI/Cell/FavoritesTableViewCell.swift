//
//  FavoritesTableViewCell.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/7/29.
//

import UIKit

protocol FavoritesTableViewCellDelegate: AnyObject {
    func didSelectCell(_ cell: FavoritesTableViewCell)
}

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    // 新增一個 UITapGestureRecognizer 屬性
        private var tapGesture: UITapGestureRecognizer!
        weak var delegate: FavoritesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 初始化 tapGesture
                tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap))
                self.addGestureRecognizer(tapGesture)
    }
    // 觸發手勢時執行的方法
        @objc private func handleCellTap() {
            delegate?.didSelectCell(self)
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
