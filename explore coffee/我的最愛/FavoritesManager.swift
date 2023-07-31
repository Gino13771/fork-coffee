//
//  FavoritesManager.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/7/25.
//

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
    
    func getFavorites() -> Results<RLM_DataModel>? {
        do {
            let realm = try Realm()
            let favorites = realm.objects(RLM_DataModel.self)
            return favorites
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            return nil
        }
    }
}
