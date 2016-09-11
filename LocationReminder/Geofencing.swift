//
//  Geotification.swift
//  Geotify
//
//  Created by Ken Toh on 24/1/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation




class Geofencing: NSObject {
    var coordinate: CLLocationCoordinate2D?
    var radius: CLLocationDistance?
    var identifier: String?
    var notifyTiming:String?
    var notification:String?
    

    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, notifyTiming: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.notifyTiming = notifyTiming
    }
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, notifyTiming: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.notifyTiming = notifyTiming
    }
 
}
