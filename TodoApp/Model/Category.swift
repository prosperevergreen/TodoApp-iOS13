//
//  Category.swift
//  TodoApp
//
//  Created by Prosper Evergreen on 16.09.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String?
    @objc dynamic var createdCategory: Date?
    @objc dynamic var backgroundColor: String?
    var childItem = List<Item>()
}
