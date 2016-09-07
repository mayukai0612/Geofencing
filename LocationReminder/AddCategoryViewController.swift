//
//  AddCategoryViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 7/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit

protocol AddCategoryDelegate {
    
    func addCategory(category:Category)
    
}
class AddCategoryViewController: UIViewController,AddNotifyDelegate {

    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var chooseColorTab: UISegmentedControl!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
   

    
    var category:Category?
    
    var catogeryTitle:String?
    var categoryColor:String?
    var location:String?
    var lat:Double?
    var lgt: Double?
    var notifyRadius:Int?
    var notifyTiming:String?
    
    var addCategoryDelegate: AddCategoryDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add action on location text field
        locationTextField.addTarget(self, action: #selector(AddCategoryViewController.searchLocation(_:)), forControlEvents: UIControlEvents.TouchDown)
        

        //add save button to navigation bar
        let saveBtn : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddCategoryViewController.OnSaveClicked))
        
         self.navigationItem.setRightBarButtonItem(saveBtn, animated: false)

        //set default color
        chooseColorTab.selectedSegmentIndex = 3
        
        //set default notification status
        notificationSwitch.setOn(false, animated: false)
        
        
        
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
            initializeCategory()
            
            //add category to category list
            addCategoryDelegate?.addCategory(self.category!)
            
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
    
    func initializeCategory()
    {
    
        let categoryColor = self.categoryColor
        let categoryLocation = self.locationTextField.text!.trim()
        let categoryTitle = self.titleTextField.text!.trim()
        let notificationStatus = notificationSwitch.on
        self.category = Category(categoryTitle:categoryTitle,categoryColor:categoryColor!,categoryLocation:categoryLocation,notificationStatus:notificationStatus,lat:self.lat!,lgt:self.lgt!,notifyRadius: self.notifyRadius,notifyTiming: self.notifyTiming)
    }
    
    func searchLocation(textField: UITextField) {
        // user touch field
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("SearchLocation") as! SearchLocationViewController
        vc.addNotifyDelegate  = self
        self.navigationController?.pushViewController(vc
            , animated: true)
    
    }
    
    func addLocation(coordinate: CLLocationCoordinate2D,locationName:String) {
        
        self.location = locationName
        
        self.lat = coordinate.latitude
        self.lgt = coordinate.longitude
        self.locationTextField.text = locationName
        print(self.location!)
        print(self.lat!)
        print(self.lgt!)
        
    }
    
    func addNotifyPara(radius:Int,timing:String)
    {
        self.notifyTiming = timing
        self.notifyRadius = radius
        
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
    
    
}



extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
