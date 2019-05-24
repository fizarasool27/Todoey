//
//  Category.swift
//  Todoey
//
//  Created by Fiza Rasool on 21/05/19.
//  Copyright © 2019 Fiza Rasool. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc  dynamic var name : String = ""
    
    let items = List<Item>()
    
}
