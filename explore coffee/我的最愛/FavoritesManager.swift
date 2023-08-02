//
//  FavoritesManager.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/7/25.
//


import UIKit
import RealmSwift

class FavoritesManager {

    func addFavorite(item: RLM_DataModel) {
        do {
            let realm = try Realm()
            let id = item.id
            let predicate = NSPredicate(format: "id == %@", id)
            let existingFavorite = realm.objects(RLM_DataModel.self).filter(predicate).first
            
            if existingFavorite == nil {
                try realm.write {
                    realm.add(item)
                }
            } else {
                print("Item with ID \(id) already exists in favorites.")
            }
        } catch {
            print("Error saving favorite: \(error.localizedDescription)")
        }
    }
    
    func removeFavorite(itemID: String) {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "id == %@", itemID)
            let favoriteToDelete = realm.objects(RLM_DataModel.self).filter(predicate).first
            
            if let favorite = favoriteToDelete {
                try realm.write {
                    realm.delete(favorite)
                    print("删除成功")
                }
            } else {
                print("未找到要删除的数据")
            }
        } catch {
            print("Error removing favorite: \(error.localizedDescription)")
        }
    }
    
    func getFavorites() -> [RLM_DataModel]? {
        do {
            let realm = try Realm()
            return Array(realm.objects(RLM_DataModel.self))
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Results {
    func toArray() -> [Element] {
        return self.map { $0 }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // ... 其他代理方法保持不變 ...
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let favorite = favoritesArray?[indexPath.row] {
                let favoritesManager = FavoritesManager()
                favoritesManager.removeFavorite(itemID: favorite.id)
                favoritesArray?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
    
