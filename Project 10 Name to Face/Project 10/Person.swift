//
//  Person.swift
//  Project 10
//
//  Created by LiangTzu Chun on 3/10/16.
//  Copyright © 2016 Jim. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
