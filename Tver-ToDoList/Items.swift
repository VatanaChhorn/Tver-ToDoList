//
//  Items.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 01/09/2020.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var date: String = "" 
    @objc dynamic var id: Int = 0
    var parentCatagory = LinkingObjects(fromType: Catagories.self, property: "items")
}

