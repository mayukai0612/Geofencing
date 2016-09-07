//
//  Category.swift
//  LocationReminder
//
//  Created by Yukai Ma on 6/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class Category: NSObject {
    
    var categoryId:Int?
    var categoryTitle:String?
    var categoryColor: String?
    var categoryLocation: String?
    var notificationStatus: Bool?
    var lat: Double?
    var lgt: Double?
    var notifyRadius:Int?
    var notifyTiming:String?
    
    
    override init() {
        
    }
    
    init(categoryId: Int,categoryTitle:String,categoryColor:String,categoryLocation:String,notificationStatus:Bool,notifyDistance:Int,
         lat:Double,lgt:Double) {
        self.categoryId = categoryId
        self.categoryTitle = categoryTitle
        self.categoryColor = categoryColor
        self.categoryLocation = categoryLocation
        self.notificationStatus = notificationStatus
        self.lgt  = lgt
        self.lat = lat
    }
    
    init(categoryTitle:String,categoryColor:String,categoryLocation:String,notificationStatus:Bool,
         lat:Double,lgt:Double,notifyRadius:Int?,notifyTiming:String?) {
        self.categoryTitle = categoryTitle
        self.categoryColor = categoryColor
        self.categoryLocation = categoryLocation
        self.notificationStatus = notificationStatus
        self.lgt  = lgt
        self.lat = lat
        self.notifyTiming = notifyTiming
        self.notifyRadius = notifyRadius
    }

    
}

