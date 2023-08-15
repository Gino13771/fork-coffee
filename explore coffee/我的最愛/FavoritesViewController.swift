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
    var favoritesArray: [RLM_DataModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName:"FavoritesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FavoritesTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = Realm.Configuration(schemaVersion: 2, migrationBlock: { migration, oldSchemaVersion in
            
        })
        Realm.Configuration.defaultConfiguration = config
        
        let favoritesManager = FavoritesManager()
        favoritesArray = favoritesManager.getFavorites()
        tableView.reloadData()
    }
}

extension FavoritesViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        cell.nameLabel.text = favoritesArray?[indexPath.row].name
        cell.addressLabel.text = favoritesArray?[indexPath.row].address
        
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cafeInfo = favoritesArray?[indexPath.row] {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            
            
            detailViewController.cafeData = CafeInfo(id: cafeInfo.id,
                                                     name: cafeInfo.name,
                                                     address: cafeInfo.address,
                                                     limited_time: nil,
                                                     latitude: nil,
                                                     longitude: nil,
                                                     open_time: cafeInfo.open_time)
            
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}


extension FavoritesViewController: FavoritesTableViewCellDelegate {
    
    func didSelectCell(_ cell: FavoritesTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell), let cafeInfo = favoritesArray?[indexPath.row] {
            
            let cafeInfoForMap = CafeInfo(id: cafeInfo.id,
                                          name: cafeInfo.name,
                                          address: cafeInfo.address,
                                          limited_time: nil,
                                          latitude: cafeInfo.latitude,
                                          longitude: cafeInfo.longitude,
                                          open_time: cafeInfo.open_time)
            let detailViewController = DetailViewController.make(dataModel: cafeInfoForMap)
            
            self.present(detailViewController, animated: true)
        }
    }
}





