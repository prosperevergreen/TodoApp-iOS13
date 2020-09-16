//
//  Item.swift
//  TodoApp
//
//  Created by Prosper Evergreen on 16.09.2020.
//  Copyright © 2020 proSPEC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String?
    @objc dynamic var createdItem: Date?
    @objc dynamic var isDone: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "childItem")
}
