//
//  Capital.swift
//  Project 19
//
//  Created by LiangTzu Chun on 3/19/16.
//  Copyright © 2016 Jim. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var favorite: Bool
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, favorite: Bool) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.favorite = favorite
    }
}