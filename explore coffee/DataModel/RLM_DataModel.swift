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
    // 其他数据相关的属性
    
    convenience init(id: String, name: String, address: String, open_time: String) {
        self.init()
        self.id = id
        self.name = name
        self.address = address
        self.open_time = open_time
    }
}


