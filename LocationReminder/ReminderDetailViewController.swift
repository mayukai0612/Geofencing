

import UIKit
import CoreData

protocol AddReminderToMOCDelegate{
    func addReminderToMOC(reminder:Reminder)
}

class ReminderDetailViewController: UITableViewController,AddReminderListDelegate,EditReminderDelegate{
    
    var managedObjectContext:NSManagedObjectContext?
    var addReminderToMOCDelegate:AddReminderToMOCDelegate?
    
    var reminderList = [Reminder]()
    var selectedRow: Int?
    

    
    
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
        if(self.managedObjectContext == nil)
        {
            errorAlert("No Category",msg: "Please Create a category first.")
            return
        }
        else{
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ReminderPopUp") as! AddReminderViewController
        popOverVC.addReminderDelegate = self
        popOverVC.editOrAddFlag = "add"
        popOverVC.managedObjectContext = self.managedObjectContext
        self.addChildView(popOverVC)
        }

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
        addReminderToMOCDelegate?.addReminderToMOC(reminder)
        self.reminderList.append(reminder)
        self.tableView.reloadData()
    }
    



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
        if(reminder.reminderTime == nil){
            cell.reminderTimeLabel.text = ""
        }else{
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        cell.reminderTimeLabel.text = dateFormatter.stringFromDate(reminder.reminderTime!)
            
        }
        
        
        if(reminder.completed == false)
        {
          cell.completedSwitch.setOn(true, animated: false)
        }
        else{
            cell.completedSwitch.setOn(false, animated: false)
        }
        
        //add event to switch
        cell.completedSwitch.tag = indexPath.row
        cell.completedSwitch.addTarget(self,action: #selector(ReminderDetailViewController.switchIsChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
   
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
         
            
            //delete in the managedObjectContext
            
            //delete select reminder from managedObjectContext
            self.managedObjectContext!.deleteObject(self.reminderList[indexPath.row] as NSManagedObject)
            //Save the ManagedObjectContext
            do
            {
                try self.managedObjectContext!.save()
            }
            catch let error
            {
                print("Could not save Deletion \(error)")
            }
            
            self.reminderList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            tableView.reloadData()
            
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                let reminder = self.reminderList[indexPath.row]
        
        self.selectedRow = indexPath.row
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ReminderPopUp") as! AddReminderViewController
        popOverVC.editReminderDelegate = self
        popOverVC.reminder = reminder
        popOverVC.managedObjectContext = self.managedObjectContext
        popOverVC.editOrAddFlag = "edit"
        

        self.addChildView(popOverVC)
        


        
    }
    
    func errorAlert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func editReminder(reminder:Reminder)
    {
        //delete select reminder from managedObjectContext
        managedObjectContext!.deleteObject(self.reminderList[selectedRow!] as NSManagedObject)
       
        
        //table view change
        self.reminderList.removeAtIndex(selectedRow!)
        self.reminderList.append(reminder)
        self.tableView.reloadData()
        
       //add reminder to managedObjectcontext
        addReminderToMOCDelegate?.addReminderToMOC(reminder)
        
       
    }
    
    
    //action when switch is changed
    func switchIsChanged(sender:UISwitch)
    {
        let index = sender.tag
        self.reminderList[index].completed = sender.on
        //change the reminder in ManagedObjectContext
        
        
    }
    
}
