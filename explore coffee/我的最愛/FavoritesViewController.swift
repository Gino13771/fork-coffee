//
//  My favourite.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/7/23.
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var favoritesArray: Results<RLM_DataModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName:"FavoritesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FavoritesTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let favoritesManager = FavoritesManager()
        favoritesArray = favoritesManager.getFavorites()
        tableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavoritesTableViewCell.self), for: indexPath) as! FavoritesTableViewCell
        
        cell.nameLabel.text = favoritesArray![indexPath.row].name
        cell.addressLabel.text = favoritesArray![indexPath.row].address
        
        return cell
    }
}

