//
//  Category.swift
//  To-Do-List
//
//  Created by Yatharth on 9/25/20.
//  Copyright © 2020 Yatharth Mahawar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
