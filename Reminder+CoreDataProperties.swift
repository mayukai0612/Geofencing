//
//  Reminder+CoreDataProperties.swift
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

extension Reminder {

    @NSManaged var reminderTitle: String?
    @NSManaged var note: String?
    @NSManaged var reminderTime: NSDate?
    @NSManaged var completed: NSNumber?
    @NSManaged var category: Category?

}
