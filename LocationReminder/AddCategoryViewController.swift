//
//  AddCategoryViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 7/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol AddCategoryDelegate {
    
    func addCategory(category:Category)
    
}

protocol EditCategoryDelegate
{

    func editCategory(category:Category)
}

class AddCategoryViewController: UIViewController,AddNotifyDelegate {

    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var chooseColorTab: UISegmentedControl!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
   

    
    var category: Category?
    var managedObjectContext: NSManagedObjectContext
    var addCategoryDelegate: AddCategoryDelegate?
    var editCategoryDelegate:EditCategoryDelegate?
    
    var catogeryTitle:String?
    var categoryColor:String?
    var location:String?
    var lat:Double?
    var lgt: Double?
    var notifyRadius:CLLocationDistance?
    var notifyTiming:String?
    
    var editOrAddFlag:String?
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        if(self.category == nil){
         self.category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext:
            self.managedObjectContext) as? Category
        }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add action on location text field
        locationTextField.addTarget(self, action: #selector(AddCategoryViewController.searchLocation(_:)), forControlEvents: UIControlEvents.TouchDown)
        

        //add save button to navigation bar
        let saveBtn : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddCategoryViewController.OnSaveClicked))
        
         self.navigationItem.setRightBarButtonItem(saveBtn, animated: false)

        //load views
        loadViews()
        
        
        
        // tap view to dismiss keyboard
                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCategoryViewController.dismissKeyboard))
                view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
    @IBAction func colorPicked(sender: AnyObject) {
        
        
        if(chooseColorTab.selectedSegmentIndex == 0)
        {
            self.categoryColor  = "red"
        }
        
        if(chooseColorTab.selectedSegmentIndex == 1)
        {
            self.categoryColor  = "yellow"
        }
        
        if(chooseColorTab.selectedSegmentIndex == 2)
        {
            self.categoryColor  = "green"
        }
        
        if(chooseColorTab.selectedSegmentIndex == 3)
        {
            self.categoryColor  = "white"
        }
    }
    
    
    
    func OnSaveClicked()
    {
        //check input
        if (checkInput() == true)
        {
            //initialize category
            initializeCategoryAndAddToList()
            
            //navigate to previous page
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
        
            //alert
            let alertController = UIAlertController(title: "iOScreator", message: "Don't leave title and location blank!", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)

        }
        
       
    
    }
    
    //pass category to detail view
    func passCategoryToDetailView()
    {
        let detailNavigationController = splitViewController!.viewControllers.last as! UINavigationController
        let  viewControllers = detailNavigationController.viewControllers
        let detailViewController = viewControllers[0] as! CategoryDetailViewController
        
        detailViewController.category = self.category
        detailViewController.refreshUI()
    }
    
    func initializeCategoryAndAddToList()
    {
    
        var categoryColor = self.categoryColor
        let categoryLocation = self.locationTextField.text!.trim()
        let categoryTitle = self.titleTextField.text!.trim()
        let notificationStatus = notificationSwitch.on
        //let category = Category()
        if(self.categoryColor == nil)
        {
            categoryColor = "white"
        }
      
        
        
        
        if(editOrAddFlag ==  "add"){
            //for add category
            //1
            self.category!.categoryTitle = categoryTitle
            //2
            self.category!.cateogryLoctation = categoryLocation
            //3
            self.category!.categoryColor = categoryColor
            //4
            if(notificationStatus == true)
            {
                self.category!.notificationStatus = 1
            }else{
                self.category!.notificationStatus = 0
            }
            //5
            self.category!.lat = self.category!.lat
            //6
            self.category!.lgt = self.category!.lgt
            //7
            self.category!.notifyRadius = self.category!.notifyRadius!
            //8
            self.category!.notifyTiming = self.category!.notifyTiming
            

            self.addCategoryDelegate!.addCategory(self.category!)
        }
        else if (editOrAddFlag == "edit")
        {
            //For edit category
            let newCategory: Category = (NSEntityDescription.insertNewObjectForEntityForName("Category",
                inManagedObjectContext: self.managedObjectContext) as? Category)!
            
            //1
            newCategory.categoryTitle = categoryTitle
            //2
            newCategory.cateogryLoctation = categoryLocation
            //3
            newCategory.categoryColor = categoryColor
            //4
            if(notificationStatus == true)
            {
                newCategory.notificationStatus = 1
            }else{
                newCategory.notificationStatus = 0
            }
            //5
            newCategory.lat = self.category!.lat
            //6
            newCategory.lgt = self.category!.lgt
            //7
            newCategory.notifyRadius = self.category!.notifyRadius!
            //8
            newCategory.notifyTiming = self.category!.notifyTiming
            self.editCategoryDelegate!.editCategory(newCategory)
        }
        
    }
    
    func searchLocation(textField: UITextField) {
        // user touch field
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("SearchLocation") as! SearchLocationViewController
        vc.addNotifyDelegate  = self
        if(self.category?.cateogryLoctation != nil){
//            if(self.category!.lat != nil || self.lat != nil)
//            {
                let coordinate = CLLocationCoordinate2D(latitude: Double((self.category!.lat!)),longitude:Double((self.category!.lgt!)))
                vc.geofencing = Geofencing(coordinate: coordinate, radius: Double(self.category!.notifyRadius!), notifyTiming: self.category!.notifyTiming!)
            //}
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    //addNotify delegate: addLocation
    func addLocation(coordinate: CLLocationCoordinate2D,locationName:String) {
        
        self.location = locationName
        
        self.lat = coordinate.latitude
        self.lgt = coordinate.longitude
        self.category!.lat = coordinate.latitude
        self.category!.lgt = coordinate.longitude

        self.locationTextField.text = locationName
     
        print(self.location!)
        print(self.lat!)
        print(self.lgt!)
        
    }
    
    //addNotify delegate: addNotifyPara
    func addNotifyPara(radius:CLLocationDistance,timing:String)
    {
        self.notifyTiming = timing
        self.notifyRadius = radius
        self.category!.notifyTiming = timing
        self.category!.notifyRadius = NSNumber(double: radius)
    }
    
    
    func checkInput() -> Bool
    {
        var validteInput:Bool?
        
        if(locationTextField.text!.trim() == "" || titleTextField.text?.trim() == "")
        {
            
            validteInput = false
        }
        else{
        
            validteInput = true
        }
        
        return validteInput!
    
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func loadViews()
    {
        //load view for editing category
        if (self.category != nil && editOrAddFlag == "edit")
        {
            self.titleTextField.text = self.category!.categoryTitle
            self.locationTextField.text = self.category!.cateogryLoctation
            if(self.category!.notificationStatus == 1){
                self.notificationSwitch.setOn(true, animated: false)
            }
            else{
            self.notificationSwitch.setOn(false, animated: false)
            }
            switch self.category!.categoryColor! {
            case "red":
                self.chooseColorTab.selectedSegmentIndex = 0
            case "green":
                self.chooseColorTab.selectedSegmentIndex = 1
            case "yellow":
                self.chooseColorTab.selectedSegmentIndex = 2
            default:
                chooseColorTab.selectedSegmentIndex = 3
            }
        
        }
        else
        {
            //set default color
            chooseColorTab.selectedSegmentIndex = 3
            
            //set default notification status
            notificationSwitch.setOn(false, animated: false)
        
        }
    
    }
    
}



extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
