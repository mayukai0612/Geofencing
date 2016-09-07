//
//  CategoryListViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 6/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

//protocol CategorySelectionDelegate: class {
//    func categorySelected(newCategory: Category)
//}

class CategoryListViewController: UITableViewController ,UISplitViewControllerDelegate,AddCategoryDelegate{
    
    
    var categoryList = [Category]()
    
  //  var delegate: CategorySelectionDelegate?

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
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
            
            let vc = nav.viewControllers[0] as! CategoryDetailViewController
            
            vc.category = self.categoryList[index.row]
            
            
            self.tableView.deselectRowAtIndexPath(index, animated: true)
            
        }
        
    }
    
    //make the master view to collapse the detail view in small devices
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
    

    

    

