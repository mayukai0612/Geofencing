//
//  CategoryMapViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 8/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit

class CategoryMapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var categoryList = [Category]()
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D?
    var annotationAdded:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate  = self
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
       // self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //get current location by using this delegate method
            self.locationManager.startUpdatingLocation()
    }
        self.mapView!.showsUserLocation = true

        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //get current location
    //      let userLocation:CLLocation = locations[0]
      //    self.currentLocation = userLocation.coordinate
        
      
        
        //show current location on map
        let location = locations.last

        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude,location!.coordinate.longitude)
        
        let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.5, 0.5))
        
        self.mapView!.setRegion(region, animated: false)
        
        self.locationManager.stopUpdatingLocation()
        
        self.currentLocation =  locations.last!.coordinate

        
        //add annotations after get the current locations
        if(annotationAdded == false){
            self.addAnnotations(self.categoryList)
            self.annotationAdded = true
        }
    }
    
    
    func addAnnotations(categoryList:[Category])
    {
        var annotationView:MKPinAnnotationView!
        var pointAnnoation:CustomPointAnnotation!
        
        
        //covert categoryList to annotations
        for (category) in categoryList
        {
            
            pointAnnoation = CustomPointAnnotation()
            
            pointAnnoation.pinCustomImageName = "Pin"
            
            pointAnnoation.category = category
            
            //intialize coordinate
            
            let coordinate = CLLocationCoordinate2D(latitude: category.lat!,longitude:category.lgt!)
            
            pointAnnoation.coordinate = coordinate
            
            //Title of annotation
            pointAnnoation.title = "\(category.categoryTitle!)"
            
            //calculate distance between current loc and animal loc
            let distance = calculateDistanceInKM(self.currentLocation!,secondLocation: coordinate)
            //Subtitle of annotation
            pointAnnoation.subtitle =  "\(distance) km from current location"
            
            annotationView = MKPinAnnotationView(annotation: pointAnnoation, reuseIdentifier: "pin")
            
            //Add annotations to map
            self.mapView!.addAnnotation(annotationView.annotation!)
            
            addRadiusCircleForGeofencing(coordinate,radius: category.notifyRadius!)
        }
        

    }

    
    //delegate  method for annotations
    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        let reuseIdentifier = "pin"
        
        
        //create a annotationn view using identifier
        var v = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        if v == nil {
            v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = true
        }
        else {
            v!.annotation = annotation
        }
        //set img for call out
        let btn = UIButton(type: .DetailDisclosure)
        v!.rightCalloutAccessoryView = btn
        
        if (annotation is MKUserLocation) {
            return nil
        }else{
            let customPointAnnotation = annotation as! CustomPointAnnotation
            v!.image = UIImage(named:customPointAnnotation.pinCustomImageName)
            
            return v
        }
        
    }
    
    //delegate method for callout
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as!CustomPointAnnotation
        let reminderList = annotation.category?.reminderList
        
        
        let reminderListView = self.storyboard!.instantiateViewControllerWithIdentifier("reminderList") as! ReminderDetailViewController
            reminderListView.reminderList = reminderList!
        self.navigationController!.pushViewController(reminderListView, animated: true)
        
    }
    
    //delegate method for overlay
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer!{
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = UIColor.brownColor()
            circleRenderer.fillColor = UIColor.brownColor().colorWithAlphaComponent(0.4)
            return circleRenderer
        }
        return nil
    }
    
    
    func addRadiusCircleForGeofencing(coordinate:CLLocationCoordinate2D,radius:CLLocationDistance ) {
        self.mapView.addOverlay(MKCircle(centerCoordinate: coordinate, radius:radius))
    }
    
    func calculateDistanceInKM(firstLocation:CLLocationCoordinate2D,secondLocation:CLLocationCoordinate2D) -> Double{
        
        let fisrtLoc = CLLocation(latitude: firstLocation.latitude,longitude: firstLocation.longitude)
        let secondLoc = CLLocation(latitude: secondLocation.latitude,longitude: secondLocation.longitude)
        
        //one decimal for double
        let x = fisrtLoc.distanceFromLocation(secondLoc)/1000
        let y = Double(round(10*x)/10)
        return y
        
    }

}

    
//    // MARK: Functions that update the model/associated views with geotification changes
//    
//    func addGeofencing(geotification: Geotification) {
//        geotifications.append(geotification)
//        mapView.addAnnotation(geotification)
//        addRadiusOverlayForGeotification(geotification)
//        updateGeotificationsCount()
//    }
//    
//    func removeGeotification(geotification: Geotification) {
//        if let indexInArray = geotifications.indexOf(geotification) {
//            geotifications.removeAtIndex(indexInArray)
//        }
//        
//        mapView.removeAnnotation(geotification)
//        removeRadiusOverlayForGeotification(geotification)
//        updateGeotificationsCount()
//    }
//    
////    func updateGeotificationsCount() {
////        title = "Geotifications (\(geotifications.count))"
////    }
//    
//    //  func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
//    //    // 1
//    //    let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
//    //    // 2
//    //    region.notifyOnEntry = (geotification.eventType == .OnEntry)
//    //    region.notifyOnExit = !region.notifyOnEntry
//    //    return region
//    //  }
//    
//    
//    // MARK: AddGeotificationViewControllerDelegate
//    
//    func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
//        controller.dismissViewControllerAnimated(true, completion: nil)
//        // Add geotification
//        let geotification = Geotification(coordinate: coordinate, radius: radius, identifier: identifier, note: note, eventType: eventType)
//        addGeotification(geotification)
//        saveAllGeotifications()
//    }
//    
//    // MARK: MKMapViewDelegate
//    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
//        let identifier = "myGeotification"
//        if annotation is Geotification {
//            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
//            if annotationView == nil {
//                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView?.canShowCallout = true
//                let removeButton = UIButton(type: .Custom)
//                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
//                removeButton.setImage(UIImage(named: "DeleteGeotification")!, forState: .Normal)
//                annotationView?.leftCalloutAccessoryView = removeButton
//            } else {
//                annotationView?.annotation = annotation
//            }
//            return annotationView
//        }
//        return nil
//    }
//    
//    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
//        if overlay is MKCircle {
//            let circleRenderer = MKCircleRenderer(overlay: overlay)
//            circleRenderer.lineWidth = 1.0
//            circleRenderer.strokeColor = UIColor.purpleColor()
//            circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
//            return circleRenderer
//        }
//        return nil
//    }
//    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        // Delete geotification
//        let geotification = view.annotation as! Geotification
//        removeGeotification(geotification)
//        saveAllGeotifications()
//    }
//    
//    // MARK: Map overlay functions
//    
//    func addRadiusOverlayForGeotification(geotification: Geotification) {
//        mapView?.addOverlay(MKCircle(centerCoordinate: geotification.coordinate, radius: geotification.radius))
//    }
//    
//    func removeRadiusOverlayForGeotification(geotification: Geotification) {
//        // Find exactly one overlay which has the same coordinates & radius to remove
//        if let overlays = mapView?.overlays {
//            for overlay in overlays {
//                if let circleOverlay = overlay as? MKCircle {
//                    let coord = circleOverlay.coordinate
//                    if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
//                        mapView?.removeOverlay(circleOverlay)
//                        break
//                    }
//                }
//            }
//        }
//    }
//
//    

    
    

