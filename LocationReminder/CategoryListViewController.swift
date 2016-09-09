//
//  CategoryListViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 6/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit
//protocol CategorySelectionDelegate: class {
//    func categorySelected(newCategory: Category)
//}


class CategoryListViewController: UITableViewController ,UISplitViewControllerDelegate,AddCategoryDelegate{
    
    
    var categoryList = [Category]()
    
  //  var delegate: CategorySelectionDelegate?

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let lat = -37.870106
        let lgt = 145.041851
        let notifyRadius1: CLLocationDistance = 50
        let notifyRadius2: CLLocationDistance = 250
        let notifyRadius3: CLLocationDistance = 1000
        
        let reminder1 = Reminder(reminderTitle:"R1",note:"nnn",completed: false)
        let reminder2 = Reminder(reminderTitle:"R2",note:"note",completed: true)
        let reminder3 = Reminder(reminderTitle:"R3",note:"nn3",completed: false)

        var reminderList1 = [Reminder]()
        var reminderList2 = [Reminder]()
        var reminderList3 = [Reminder]()

        reminderList1.append(reminder1)
        reminderList1.append(reminder2)
        
        
        reminderList2.append(reminder2)
        reminderList2.append(reminder3)

        reminderList3.append(reminder1)
        reminderList3.append(reminder3)

        let category1 = Category(categoryTitle:"test",categoryColor:"red",categoryLocation:"loc",notificationStatus:true,lat:lat,lgt: lgt,notifyRadius:notifyRadius1 ,notifyTiming: "On Entry")
        
        let category2 = Category(categoryTitle:"test1",categoryColor:"yellow",categoryLocation:"loc",notificationStatus:true,lat:lat,lgt: lgt,notifyRadius:notifyRadius2 ,notifyTiming: "On Entry")

        let category3 = Category(categoryTitle:"test2",categoryColor:"green",categoryLocation:"loc",notificationStatus:false,lat:lat,lgt: lgt,notifyRadius:notifyRadius3 ,notifyTiming: "On Leaving")

        category1.reminderList = reminderList1
        category2.reminderList = reminderList2
        category3.reminderList = reminderList3

        self.categoryList.append(category1)
        self.categoryList.append(category2)
        self.categoryList.append(category3)

//    self.categoryList.append(Category(categoryId: 1,categoryTitle:"test",categoryColor:"red",categoryLocation:"test",notificationStatus:true,notifyDistance:100))
//        
//          self.categoryList.append(Category(categoryId: 2,categoryTitle:"test2",categoryColor:"red",categoryLocation:"test",notificationStatus:true,notifyDistance:100))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
//              //get current location
//        //show current location
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        // using only when application is in use
//        // self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        
        //change tableView row height
        self.splitViewController?.delegate = self
        
        //make master and detail view to be visible all the time
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        
        self.tableView.rowHeight = 100
        
        self.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func addCategoryBtn(sender: AnyObject) {
        
//                if let detailViewController  ==  CategoryDetailViewController() {
//                    splitViewController?.showDetailViewController(detailViewController, sender: nil)
        
        let navigationController = self.splitViewController?.viewControllers.last as! UINavigationController
    
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("addCategory") as! AddCategoryViewController
            vc.addCategoryDelegate = self
           navigationController.pushViewController(vc, animated: true)
       
        
        
    }

    
    @IBAction func viewMapBtn(sender: AnyObject) {
        
        let navigationController = self.splitViewController?.viewControllers.last as! UINavigationController
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("categoryMap") as! CategoryMapViewController
        vc.categoryList = self.categoryList
        navigationController.pushViewController(vc, animated: true)
        
        
    }
    
    func addCategory(category: Category) {
        self.categoryList.append(category)
        self.tableView.reloadData()
    }
    
    
    //TableView
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return categoryList.count
    }
 
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let category = self.categoryList[indexPath.row]
        cell.textLabel?.text = category.categoryTitle
        
        if (category.categoryColor == "red")
        {
            cell.backgroundColor = UIColor.redColor()

        }
        if (category.categoryColor == "yellow")
        {
            cell.backgroundColor = UIColor.yellowColor()
        }
        if (category.categoryColor == "green")
        {
            cell.backgroundColor = UIColor.greenColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
    
        
        let edit = UITableViewRowAction(style: .Normal, title: "Edit") { action, index in
            print("favorite button tapped")
        }
        edit.backgroundColor = UIColor.orangeColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("share button tapped")
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let selectedCategory = self.categoryList[indexPath.row]
        self.performSegueWithIdentifier("showDetail", sender: self)

//        if let detailViewController = self.delegate as? CategoryDetailViewController {
//            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        
        
        }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            let index = self.tableView.indexPathForSelectedRow! as NSIndexPath
            
            let nav = segue.destinationViewController as! UINavigationController
            
            let vc = nav.viewControllers[0] as! ReminderDetailViewController
            
            vc.reminderList = self.categoryList[index.row].reminderList
            
            
            self.tableView.deselectRowAtIndexPath(index, animated: true)
            
        }
        
      

        
    }
    
    //make the master view to collapse the detail view in small devices
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
    

    

    

