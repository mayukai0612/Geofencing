//
//  CategoryListViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 6/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit
import CoreData
//protocol CategorySelectionDelegate: class {
//    func categorySelected(newCategory: Category)
//}


class CategoryListViewController: UITableViewController ,UISplitViewControllerDelegate,AddCategoryDelegate,EditCategoryDelegate,AddReminderToMOCDelegate{
    
    
    var categoryList = [Category]()
    var categoryListFromMOC: CategoryList?
    var managedObjectContext: NSManagedObjectContext
    var selectedCategory: Category?
    var index:Int?
  //  var delegate: CategorySelectionDelegate?

    
    required init(coder aDecoder: NSCoder) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        super.init(coder: aDecoder)!

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

        //fetch data from managed object context
        fetchFromManagedObjectContext()
        
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
            vc.managedObjectContext  = self.managedObjectContext
            vc.editOrAddFlag = "add"

           navigationController.pushViewController(vc, animated: true)
       
        
        
    }

    

    @IBAction func viewMap(sender: AnyObject) {
        let navigationController = self.splitViewController?.viewControllers.last as! UINavigationController
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("categoryMap") as! CategoryMapViewController
        vc.categoryList = self.categoryList
        let lat = self.categoryList[0].lat
        print("test\(lat)")
        navigationController.pushViewController(vc, animated: true)
        
        
    }
    
    func addCategory(category: Category) {
        self.categoryListFromMOC!.addCategory(category)
        self.categoryList = NSArray(array: (categoryListFromMOC!.categories?.allObjects as! [Category])) as! [Category]
        self.tableView.reloadData()
        //Save the ManagedObjectContext
        do
        {
            try self.managedObjectContext.save()
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
        

    }
    
    
    func updateGeofencingCount() {
     //   title = "Geotifications (\(geotifications.count))"
        //addCategoryBtn.enabled = (geotifications.count < 20)  // Add this line
    }
    
    func editCategory(category:Category)
    {
        managedObjectContext.deleteObject(categoryList[index!] as NSManagedObject)
        self.categoryListFromMOC!.addCategory(category)
        
        self.categoryList[index!] =  category
        self.tableView.reloadData()

        //Save the ManagedObjectContext
        do
        {
            try self.managedObjectContext.save()
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
    
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
        cell.detailTextLabel?.text = category.cateogryLoctation
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
            let navigationController = self.splitViewController?.viewControllers.last as! UINavigationController
            
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("addCategory") as! AddCategoryViewController
            vc.editCategoryDelegate = self
            vc.managedObjectContext  = self.managedObjectContext
            vc.category = self.categoryList[indexPath.row]
            vc.editOrAddFlag = "edit"
            navigationController.pushViewController(vc, animated: true)

        }
        edit.backgroundColor = UIColor.orangeColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            // Delete the row from the data source
            self.managedObjectContext.deleteObject(self.categoryList[indexPath.row] as NSManagedObject)
            self.categoryList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.reloadData()
            
            //Save the ManagedObjectContext
            do
            {
                try self.managedObjectContext.save()
            }
            catch let error
            {
                print("Could not save Deletion \(error)")
            }
        
            }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, edit]
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                   forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(categoryList[indexPath.row] as NSManagedObject)
            self.categoryList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.reloadData()
            
            //Save the ManagedObjectContext
            do
            {
                try self.managedObjectContext.save()
            }
            catch let error
            {
                print("Could not save Deletion \(error)")
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("showDetail", sender: self)
        self.index = indexPath.row

        
        }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            let index = self.tableView.indexPathForSelectedRow! as NSIndexPath
            
            let nav = segue.destinationViewController as! UINavigationController
            
            let vc = nav.viewControllers[0] as! ReminderDetailViewController
            
            vc.managedObjectContext = self.managedObjectContext
            vc.addReminderToMOCDelegate = self
            
            let category = self.categoryList[index.row] as Category
            
            //get the instance of Category Class which represents category entity
            self.selectedCategory = category
            let reminderList = category.reminders?.allObjects as! [Reminder]
             //let reminderList = NSArray(array: (category.reminders?.allObjects as! [Reminder])) as! [Reminder]
            
            //pass reminderlist to reminderList View
            vc.reminderList = reminderList
            self.tableView.deselectRowAtIndexPath(index, animated: true)
            
        }
        
      

        
    }
    
    func addReminderToMOC(reminder: Reminder) {
        
        //write the relationship between Category entity and Reminder entity
        self.selectedCategory?.addReminder(reminder)
    
        //update selected category
       // self.categoryList[self.index!] = self.selectedCategory!
        
        //refresh view
       // self.tableView.reloadData()
        
        //Save the ManagedObjectContext
        do
        {
            try self.managedObjectContext.save()
        }
        catch let error
        {
            print("Could not save Deletion \(error)")
        }
        
        
    }
    
    //make the master view to collapse the detail view in small devices
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    func fetchFromManagedObjectContext()
    {
    
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("CategoryList", inManagedObjectContext:
            self.managedObjectContext)
        fetchRequest.entity = entityDescription
        
        var result = NSArray?()
        do
        {
            result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            if result!.count == 0
            {
                self.categoryListFromMOC = CategoryList.init(entity: NSEntityDescription.entityForName("CategoryList", inManagedObjectContext:
                    self.managedObjectContext)!, insertIntoManagedObjectContext: self.managedObjectContext)
            }
            else
            {
                self.categoryListFromMOC = result![0] as? CategoryList
                self.categoryList = NSArray(array: (categoryListFromMOC!.categories?.allObjects as! [Category])) as! [Category]
            }
        }
        catch
        {
            let fetchError = error as NSError
            print(fetchError)
        }
    
    }
    
}
    

    

    

