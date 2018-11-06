//
//  File.swift
//  ToDoList
//
//  Created by LillyC on 10/29/18.
//  Copyright © 2018 LillyC. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
