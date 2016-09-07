//
//  Geotification.swift
//  Geotify
//
//  Created by Ken Toh on 24/1/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

import UIKit
import MapKit



//enum EventType: Int {
//    case OnEntry = 0
//    case OnExit
//}

class Geofencing: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var notifyTiming:String
    //  var eventType: EventType
    

    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, notifyTiming: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.notifyTiming = notifyTiming
    }
    
    // MARK: NSCoding
//    
//    required init?(coder decoder: NSCoder) {
//        let latitude = decoder.decodeDoubleForKey(kGeotificationLatitudeKey)
//        let longitude = decoder.decodeDoubleForKey(kGeotificationLongitudeKey)
//        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        radius = decoder.decodeDoubleForKey(kGeotificationRadiusKey)
//        identifier = decoder.decodeObjectForKey(kGeotificationIdentifierKey) as! String
//        note = decoder.decodeObjectForKey(kGeotificationNoteKey) as! String
//        eventType = EventType(rawValue: decoder.decodeIntegerForKey(kGeotificationEventTypeKey))!
//    }
//    
//    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeDouble(coordinate.latitude, forKey: kGeotificationLatitudeKey)
//        coder.encodeDouble(coordinate.longitude, forKey: kGeotificationLongitudeKey)
//        coder.encodeDouble(radius, forKey: kGeotificationRadiusKey)
//        coder.encodeObject(identifier, forKey: kGeotificationIdentifierKey)
//        coder.encodeObject(note, forKey: kGeotificationNoteKey)
//        coder.encodeInt(Int32(eventType.rawValue), forKey: kGeotificationEventTypeKey)
//    }
}
