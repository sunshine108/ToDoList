//
//  Category.swift
//  ToDoList
//
//  Created by LillyC on 10/30/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
