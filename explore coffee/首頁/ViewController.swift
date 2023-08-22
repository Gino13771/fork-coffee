//
//  ViewController.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/5/23.
//

import UIKit
import PKHUD
import RealmSwift
import UserNotifications
import CoreLocation


class ViewController: UIViewController{
    
    let cityTranslations: [String: String] = [
        "taipei": "台北",
        "yilan": "宜蘭",
        "taoyuan": "桃園",
        "hsinchu": "新竹",
        "miaoli": "苗栗",
        "taichung": "台中",
        "changhua": "彰化",
        "Nantou": "南投",
        "Yunlin": "雲林",
        "Chiayi": "嘉義",
        "Tainan": "台南",
        "Kaohsiung": "高雄",
        "Pingtung": "屏東",
    ]
    
    var cafes = [CafeInfo]()
    var pickerView = UIPickerView()
    let cities = ["taipei","yilan","taoyuan","hsinchu","miaoli","taichung","changhua","Nantou","Yunlin","Chiayi","Tainan","Kaohsiung","Pingtung"]
    
    let apiUrlString = "https://cafenomad.tw/api/v1.2/cafes"
    var item: RLM_DataModel?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    
    @objc func saveToRealm(_ sender: UIButton) {
        let index = sender.tag
        let dataModel = cafes[index]
        
        if let latitude = dataModel.latitude, let longitude = dataModel.longitude {
            let data = RLM_DataModel(id: dataModel.id,
                                     name: dataModel.name,
                                     address: dataModel.address,
                                     open_time: dataModel.open_time,
                                     latitude: latitude,
                                     longitude: longitude)
            
            let realm = FavoritesManager()
            realm.addFavorite(item: data)
            cafes[index] = dataModel
            tableview.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField?.inputView = pickerView
        textField?.textAlignment = .center
        textField?.placeholder = "搜尋"
        
        tableview?.delegate = self
        tableview?.dataSource = self
        let nib = UINib(nibName:"CafeTableViewCell", bundle: nil)
        tableview?.register(nib, forCellReuseIdentifier: "CafeTableViewCell")
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        versionLabel?.text = "App版本: " + version
        createDailyNotification()
        
    }
    
    
    
    @IBAction func searchCity(_ sender: Any) {
        if let searchText = textField.text {
            let urlString = "\(apiUrlString)/\(searchText)"
            
            if let url = URL(string: urlString){
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    let decoder = JSONDecoder()
                    
                    if let data = data,let cafeResult=try?decoder.decode([CafeInfo].self, from: data){
                        self.cafes = cafeResult
                        print(cafeResult)
                        print(self.cafes.count)
                        
                        DispatchQueue.main.async {
                            self.tableview.reloadData()
                            
                            HUD.flash(.progress, delay: 1.0)
                        }
                    }
                }.resume()
            }
        }
    }
    func isCafeInDatabase(_ cafeId: String) -> Bool {
        let realm = try? Realm()
        if (realm?.object(ofType: RLM_DataModel.self, forPrimaryKey: cafeId)) != nil {
            return true
        } else {
            return false
        }
    }
}
//MARK: - TableViewController
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafes.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CafeTableViewCell", for: indexPath) as! CafeTableViewCell
        
        let cafeInfo = cafes[indexPath.row]
        cell.cafeNameLabel?.text = cafeInfo.name
        cell.cafeAddressLabel.text = cafeInfo.address 
        
        cell.collectBtn.addTarget(self, action: #selector(saveToRealm), for: .touchUpInside)
        cell.collectBtn.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cafeCell = cell as? CafeTableViewCell {
            let cafeInfo = cafes[indexPath.row]
            if isCafeInDatabase(cafeInfo.id) {
                cafeCell.collectBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                cafeCell.collectBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            if let indexpath = tableview.indexPathForSelectedRow {
                let vc=segue.destination as? DetailViewController
                vc?.cafeData = cafes[indexpath.row]
            }
        }
    }
    
}

//MARK: - PickerViewController
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let englishCity = cities[row]
        if let chineseCity = cityTranslations[englishCity] {
            return chineseCity
        } else {
            return englishCity
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = cities[row]
        textField.resignFirstResponder()
    }
}

extension ViewController {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            
            self.handleDelete(at: indexPath)
        }
        return [deleteAction]
    }
    
    
    func handleDelete(at indexPath: IndexPath) {
        let cafeInfo = cafes[indexPath.row]
        
        cafes.remove(at: indexPath.row)
        
        tableview.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    
}
