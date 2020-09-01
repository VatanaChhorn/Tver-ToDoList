//
//  Categories.swift
//  Tver-ToDoList
//
//  Created by Vatana Chhorn on 01/09/2020.
//

import Foundation
import RealmSwift

class Catagories: Object {
    @objc dynamic var name : String = ""
    let items = List<Items>()
}
