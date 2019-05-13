//
//  Item.swift
//  Todoey
//
//  Created by Fiza Rasool on 11/05/19.
//  Copyright © 2019 Fiza Rasool. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable{
    
    
    var title : String = ""
    var done : Bool = false
}
