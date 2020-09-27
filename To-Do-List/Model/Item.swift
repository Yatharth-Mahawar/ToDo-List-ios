//
//  Items.swift
//  To-Do-List
//
//  Created by Yatharth on 9/25/20.
//  Copyright © 2020 Yatharth Mahawar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    var parentCategory = LinkingObjects(fromType:Category.self,property:"items")
}
