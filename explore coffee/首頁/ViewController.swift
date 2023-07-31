//
//  ViewController.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/5/23.
//

import UIKit
import PKHUD


class ViewController: UIViewController{
    var cafes = [CafeInfo]()
    var pickerView = UIPickerView()
    let cities = ["taipei","yilan","taoyuan","hsinchu","miaoli","taichung","changhua","Nantou","Yunlin","Chiayi","Tainan","Kaohsiung","Pingtung"]
    
    let apiUrlString = "https://cafenomad.tw/api/v1.2/cafes"
    var item: RLM_DataModel? // 假设你从其他地方传入了数据项
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.inputView = pickerView
        textField.textAlignment = .center
        textField.placeholder = "搜尋"
        
        tableview.delegate = self
        tableview.dataSource = self
        let nib = UINib(nibName:"CafeTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "CafeTableViewCell")
    }
    
    @objc func saveToRealm(_ sender: UIButton) {
        let index = sender.tag
        let dataModel = cafes[index]
        
//        dataModel.id // getFavorites.id
//        let favoritesArray = favoritesManager.getFavorites()
        
        
        
        // 將點選到的 cafes 存到 Realm 資料庫
        let data = RLM_DataModel(id: dataModel.id,
                                 name: dataModel.name,
                                 address: dataModel.address,
                                 open_time: dataModel.open_time)
        let realm = FavoritesManager()
        realm.addFavorite(item: data)
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
}
//MARK: - TableViewController
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"CafeTableViewCell", for: indexPath) as! CafeTableViewCell
        
        let cafeInfo = cafes[indexPath.row]
        cell.cafeNameLabel?.text = cafeInfo.name
        cell.cafeAddressLabel.text = cafeInfo.address
        
        let image = UIImage(systemName: "suit.heart.fill")
        cell.collectBtn.setImage(image, for: .normal)
        cell.collectBtn.addTarget(self, action: #selector(saveToRealm), for: .touchUpInside)
        cell.collectBtn.tag = indexPath.row
        
        return cell
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
extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = cities[row]
        textField.resignFirstResponder()
    }
    
    
}



