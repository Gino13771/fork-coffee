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
    var favoritesArray: [RLM_DataModel]? // 修改为 [RLM_DataModel] 类型
    
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
            // Migration code here
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

        // 設定委託
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cafeInfo = favoritesArray?[indexPath.row] {
            // 創建地圖頁面
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

            // 傳遞資料，將未使用的屬性設置為 nil
            detailViewController.cafeData = CafeInfo(id: cafeInfo.id,
                                                     name: cafeInfo.name,
                                                     address: cafeInfo.address,
                                                     limited_time: nil,
                                                     latitude: nil,
                                                     longitude: nil,
                                                     open_time: cafeInfo.open_time)

            // 將地圖頁面推入導航堆疊，實現跳轉到地圖頁面
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

// 確保 FavoritesViewController 也採納了 FavoritesTableViewCellDelegate 協議
extension FavoritesViewController: FavoritesTableViewCellDelegate {
    // 實作委託方法，在點擊事件中跳轉到地圖頁面
    func didSelectCell(_ cell: FavoritesTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell), let cafeInfo = favoritesArray?[indexPath.row] {
            // 創建地圖頁面
            let cafeInfoForMap = CafeInfo(id: cafeInfo.id,
                                          name: cafeInfo.name,
                                          address: cafeInfo.address,
                                          limited_time: nil,
                                          latitude: cafeInfo.latitude,
                                          longitude: cafeInfo.longitude,
                                          open_time: cafeInfo.open_time)
            let detailViewController = DetailViewController.make(dataModel: cafeInfoForMap)
            // 將地圖頁面推入導航堆疊，實現跳轉到地圖頁面
            self.present(detailViewController, animated: true)
        }
    }
}





