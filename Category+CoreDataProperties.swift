//
//  Category+CoreDataProperties.swift
//  LocationReminder
//
//  Created by Yukai Ma on 10/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var categoryTitle: String?
    @NSManaged var categoryTime: NSDate?
    @NSManaged var cateogryLoctation: String?
    @NSManaged var lat: NSNumber?
    @NSManaged var lgt: NSNumber?
    @NSManaged var notifyRadius: NSNumber?
    @NSManaged var notifyTiming: String?
    @NSManaged var categoryColor: String?
    @NSManaged var notificationStatus: NSNumber?
    @NSManaged var reminders: NSSet?
    @NSManaged var categoryList: CategoryList?

}
