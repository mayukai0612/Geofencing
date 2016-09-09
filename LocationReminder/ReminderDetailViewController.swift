//
//  ReminderDetailViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 9/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class ReminderDetailViewController: UITableViewController ,AddReminderListDelegate{

    var reminderList = [Reminder]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
        
        
        //add Add button to navigation bar
        let addBtn : UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ReminderDetailViewController.OnAddClicked))
        
        self.navigationItem.setRightBarButtonItem(addBtn, animated: false)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func OnAddClicked()
    {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ReminderPopUp") as! AddReminderViewController
        popOverVC.addReminderDelegate = self
        self.addChildView(popOverVC)

   // self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    
    }
    
    func addChildView(popUpView: UIViewController)
    {
        //convert AnyClass to specific type
  
        self.addChildViewController(popUpView)
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMoveToParentViewController(self)
    }
    
    
    func addReminder(reminder:Reminder)
    {
        self.reminderList.append(reminder)
        self.tableView.reloadData()
    }
    
    
//    @IBAction func addCategoryBtn(sender: AnyObject) {
//        
//        //                if let detailViewController  ==  CategoryDetailViewController() {
//        //                    splitViewController?.showDetailViewController(detailViewController, sender: nil)
//        
//        let navigationController = self.splitViewController?.viewControllers.last as! UINavigationController
//        
//        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("addCategory") as! AddCategoryViewController
//        vc.addCategoryDelegate = self
//        navigationController.pushViewController(vc, animated: true)
//        
//        
//        
//    }
//    


    //TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return reminderList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! ReminderCell
        
        let reminder = self.reminderList[indexPath.row]
        
        cell.reminderTitleLabel.text = reminder.reminderTitle
        cell.reminderDescLabel.text = reminder.note
        if(reminder.time == nil){
            cell.reminderTimeLabel.text = ""
        }else{
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        cell.reminderTimeLabel.text = dateFormatter.stringFromDate(reminder.time!)
            
        }
        
        
        if(reminder.completed == false)
        {
          cell.completedSwitch.setOn(true, animated: false)
        }
        else{
            cell.completedSwitch.setOn(false, animated: false)
        }

        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        
        let reminder = self.reminderList[indexPath.row]
        var compeleted: UITableViewRowAction?
        if(reminder.completed == false)
        {
            compeleted = UITableViewRowAction(style: .Normal, title: "Uncompleted") { action, index in
                print("uncompleted button tapped")
            }
        }
        else{
            compeleted = UITableViewRowAction(style: .Normal, title: "Completed") { action, index in
                print("completed button tapped")
            }
        }
        
        compeleted!.backgroundColor = UIColor.orangeColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("share button tapped")
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete, compeleted!]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let selectedCategory = self.categoryList[indexPath.row]
        //self.performSegueWithIdentifier("showDetail", sender: self)
        
        //        if let detailViewController = self.delegate as? CategoryDetailViewController {
        //            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        
        
    }
    

    
}
