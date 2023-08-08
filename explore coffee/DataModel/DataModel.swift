//
//  Data.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/7/29.
//

import Foundation


struct CafeInfo: Codable {
    let id: String
    let name: String
    let address: String
    let limited_time: String?
    let latitude: String?
    let longitude: String?
    let open_time: String
}
