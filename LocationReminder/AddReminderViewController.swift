

import UIKit
import CoreData

protocol AddReminderListDelegate
{
    func addReminder(reminder:Reminder)

}

protocol EditReminderDelegate {
    func editReminder(reminder:Reminder)
}


class AddReminderViewController: UIViewController,UIActionSheetDelegate{
    
    @IBOutlet weak var closeBtn: UIImageView!
  
    @IBOutlet weak var displayedView: UIView!
    
    
    @IBAction func saveBtn(sender: AnyObject) {
       
    if (checkInput()){
        if(self.editOrAddFlag == "add")
        {
            addReminderDelegate?.addReminder(getReminderFromInput())
                
        }
        else if (self.editOrAddFlag == "edit")
        {
                editReminderDelegate?.editReminder(getReminderFromInput())
            
        }
        self.view.removeFromSuperview()
    }
}
    
    
    @IBOutlet weak var titleLabel: UITextField!
    
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var addReminderDelegate: AddReminderListDelegate?
    var editReminderDelegate:EditReminderDelegate?
    var managedObjectContext:NSManagedObjectContext?
    
    
    var datePicker: UIDatePicker?
    
    
    var reminder:Reminder?
    var reminderDate:NSDate?
  
    var editOrAddFlag:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.displayedView.layer.cornerRadius = 5
        self.displayedView.layer.masksToBounds = true
        
        self.showAnimate()
        
        
        
        addActionOnCloseBtn()
        addActionToTimeLabel()
        
        
        // tap view to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddReminderViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //observe keyboard to change the view's frame
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddReminderViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddReminderViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        

        //load initial views
        loadInitialViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    @IBAction func ClosePopUpWindow(sender: AnyObject) {
    //        self.removeAnimate()
    //        //self.view.removeFromSuperview()
    //    }
    //
    
    
    func getReminderFromInput() -> Reminder
    {
        let title = self.titleLabel.text
        
        let note = self.noteTextView.text.trim()
       
        //add new reminder 
        //A new, autoreleased, fully configured instance of "Reminder" for the entity named "Reminder". The instance has its entity description set and is inserted it into context.
 
        let newReminder: Reminder = (NSEntityDescription.insertNewObjectForEntityForName("Reminder",
            inManagedObjectContext: self.managedObjectContext!) as? Reminder)!

        
        if(self.reminderDate != nil)
        {
            newReminder.reminderTitle  = title
            newReminder.note  = note
            newReminder.reminderTime = self.reminderDate
            newReminder.completed = 0
            
        }else{
            
            newReminder.reminderTitle  = title
            newReminder.note  = note
            newReminder.completed = 0

        }
    
        
        return newReminder
    
    }
    
    //check input and return boolean
    func checkInput() -> Bool
    {
        var validated: Bool = false
        
       if (self.titleLabel.text?.trim() == "")
       {
        
        //alert
        let alertController = UIAlertController(title: "iOScreator", message: "Please enter a title!", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        }
       else{
        
            validated = true
        }
        
        return  validated
        
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }

    
    //close btn atction
    func  addActionOnCloseBtn() {
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(AddReminderViewController.tapDetected)))
        singleTap.numberOfTapsRequired = 1
        closeBtn.userInteractionEnabled = true
        closeBtn.addGestureRecognizer(singleTap)
    }
    
    func tapDetected()
    {
        self.view.removeFromSuperview()
        
    }
    
    //
    func loadInitialViews()
    {
        if(self.reminder != nil)
        {
                self.titleLabel.text = self.reminder?.reminderTitle
            if(reminder?.reminderTime != nil){
                self.timeLabel.text = dateformatterDateTime((self.reminder?.reminderTime)!) as String
            }
            if(reminder?.note != nil){
                self.noteTextView.text  = self.reminder?.note
            }
        }
        
    }
    
    
    
    //date picker
    func createDatePickerViewWithAlertController()
    {
        let viewDatePicker: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        viewDatePicker.backgroundColor = UIColor.clearColor()
        
        
        self.datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        self.datePicker!.datePickerMode = UIDatePickerMode.DateAndTime
        self.datePicker!.addTarget(self, action: #selector(AddReminderViewController.datePickerSelected), forControlEvents: UIControlEvents.ValueChanged)
        
        viewDatePicker.addSubview(self.datePicker!)
        
        
        if(UIDevice.currentDevice().systemVersion >= "8.0")
        {
            
            let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            alertController.view.addSubview(viewDatePicker)
            
            
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
            { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Done", style: .Default)
            { (action) in
                
                self.dateSelected()
            }
            
            alertController.addAction(OKAction)
            
            /*
             let destroyAction = UIAlertAction(title: "Destroy", style: .Destructive)
             { (action) in
             println(action)
             }
             alertController.addAction(destroyAction)
             */
            
            
            if let presenter = alertController.popoverPresentationController {
                presenter.sourceView = self.view
                presenter.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)


            }
            
            self.presentViewController(alertController, animated: true)
            {
                // ...
            }
            
        }
        else
        {
            let actionSheet = UIActionSheet(title: "\n\n\n\n\n\n\n\n\n\n", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Done")
            actionSheet.addSubview(viewDatePicker)
            actionSheet.showInView(self.view)
        }
        
    }
    
    
    func datePickerSelected()
    {
        
        
    }
    
    func dateSelected()
    {
        
      let selectedDate =  self.dateformatterDateTime(self.datePicker!.date) as String
            self.timeLabel.text =  selectedDate
    }
    
    
    func dateformatterDateTime(date: NSDate) -> NSString
    {
        self.reminderDate = date
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func addActionToTimeLabel()
    {
        //departure time
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(AddReminderViewController.singleTapDetected)))
        singleTap.numberOfTapsRequired = 1
        timeLabel.userInteractionEnabled = true
        timeLabel.addGestureRecognizer(singleTap)

    }
    

    func singleTapDetected()
        
    {
        createDatePickerViewWithAlertController()
        
    }
    
     func showAlert() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alertController = UIAlertController(title: "iOScreator", message:
                "Return date should be later than depart date!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2 - 10
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height/2 - 10
            }
            else {
                
            }
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            if (self.reminder == nil){
                textView.text = nil
            }
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your notes here.."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}
