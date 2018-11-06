//
//  Item.swift
//  ToDoList
//
//  Created by LillyC on 10/30/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")//invert rel
}
