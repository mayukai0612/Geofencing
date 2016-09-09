//
//  Reminder.swift
//  LocationReminder
//
//  Created by Yukai Ma on 9/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class Reminder: NSObject {
    
    var reminderTitle:String?
    var note:String?
    var time:NSDate?
    var completed:Bool?
    
    
    init(reminderTitle:String,note:String,time:NSDate,completed:Bool) {
        
        self.reminderTitle = reminderTitle
        self.note = note
        self.time = time

    }

    
    init(reminderTitle:String,note:String,completed:Bool) {
        
        self.reminderTitle = reminderTitle
        self.note = note
        
    }
}
