//
//  CategoryDetailViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 6/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleColorLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var category: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if( category != nil){
         refreshUI()
        }
        else{
        
            let titleFrame = CGRect(x: 100, y: 110, width: 400, height: 50)
            
            //create title
            let title = UILabel(frame:titleFrame)
            title.text = "Category to be added"
            title.font = UIFont (name: "AmericanTypewriter-Bold", size: 30)
            title.textColor = UIColor.blackColor()

            
            view.subviews.forEach({ $0.removeFromSuperview() })

            self.view.addSubview(title)
            
        }
        
        
        
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func refreshUI() {
        titleLabel?.text = category!.categoryTitle
        titleColorLabel?.text = category!.categoryColor
        locationLabel?.text = category!.categoryLocation
        notificationSwitch.setOn((category?.notificationStatus)!, animated: false)
        
    }
    
    
    

}


//extension CategoryDetailViewController:  CategorySelectionDelegate{
//    func categorySelected(newCategory: Category) {
//        category  = newCategory
//    }
//}
