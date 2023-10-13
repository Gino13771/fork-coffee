# 探索咖啡 
* 此為自學後第一個成功上架的作品
# 設計架構  
* 專案為MVC架構
* 使用到的套件為：PKHUD, RealmSwift
* UI主要是用xib來製作
* 套件使用cocoapods安裝
# 資料來源  
* https://cafenomad.tw/developers/docs/v1.2?source=post_page-----75cf8c06177c--------------------------------
# 首頁 (ViewController)
* tableView搭配 cell 顯示對應 UI
* 使用 UIPickerView 選擇城市進入搜索頁
* 使用 CafeTableViewCell 進入地圖搜索
* 預期的 UI 效果

* 使用在地推播的方式
  ```js
    func createDailyNotification() {
            let content = UNMutableNotificationContent()
            content.title = "探索咖啡"
            content.subtitle = "快來邂逅好咖啡吧～"
            content.body = "忙碌的生活也不忘來杯咖啡！"
            content.badge = 1
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 12
            dateComponents.minute = 0
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }```
# 我的最愛
* 使用RealmSwift資料庫
* 新增
  ```js
    func addFavorite(item: RLM_DataModel) {
        do {
            let config = Realm.Configuration(schemaVersion: 2, migrationBlock: { migration, oldSchemaVersion in
                
            })
            let realm = try Realm(configuration: config)
            
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
    ```
* 刪除
   ```js
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
    
    ```
