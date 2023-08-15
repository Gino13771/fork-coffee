//
//  Data.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/5/31.
//

import Foundation
import RealmSwift

class RLM_DataModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var open_time: String = ""
    @objc dynamic var latitude: String = ""
    @objc dynamic var longitude: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, name: String, address: String, open_time: String, latitude: String, longitude:String) {
        self.init()
        self.id = id
        self.name = name
        self.address = address
        self.open_time = open_time
        self.latitude = latitude
        self.longitude = longitude
        
    }
}

