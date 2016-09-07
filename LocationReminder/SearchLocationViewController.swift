//
//  SearchLocationViewController.swift
//  LocationReminder
//
//  Created by Yukai Ma on 7/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol AddNotifyDelegate
{
    func addLocation(coordinate:CLLocationCoordinate2D,locationName:String)
    func addNotifyPara(radius:Int,timing:String)
}

class SearchLocationViewController: UIViewController,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate,HandleMapSearch{
    
    @IBOutlet weak var searchLocationBar: UISearchBar!

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var entryLeavingSegmentController: UISegmentedControl!
    
    
    @IBOutlet weak var radiusSegmentController: UISegmentedControl!
    
    
    //search location variables
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    var addNotifyDelegate: AddNotifyDelegate?
    
    //geofencing variables
    var notifyTiming:String = "entry"
    var notifyRadius:Int = 50
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add save button to navigation bar
        let saveBtn : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchLocationViewController.OnSaveClicked))
        
        self.navigationItem.setRightBarButtonItem(saveBtn, animated: false)
        
        //set locationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("SearchLocationTable") as! SearchLocationTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        //set default notify timing
        entryLeavingSegmentController.selectedSegmentIndex = 0
        
        //set default notify radius
        entryLeavingSegmentController.selectedSegmentIndex = 0

        
    }
    
    @IBAction func notifyTimingClicked(sender: AnyObject) {
        
        if(entryLeavingSegmentController.selectedSegmentIndex == 0)
        {
            self.notifyTiming  =  "entry"
        }
        
        if(entryLeavingSegmentController.selectedSegmentIndex == 1)
        {
            self.notifyTiming  =  "leaving"
        }
    }
    
    @IBAction func notifyRadiusClicked(sender: AnyObject) {
        
        
        if(radiusSegmentController.selectedSegmentIndex == 0)
        {
            self.notifyRadius  =  50
        }
        
        if(radiusSegmentController.selectedSegmentIndex == 1)
        {
             self.notifyRadius  =  250
        }
        
        if(radiusSegmentController.selectedSegmentIndex == 2)
        {
            self.notifyRadius  =  1000
        }

    }
    
    func OnSaveClicked()
    {
        if (selectedPin == nil)
        {
            //alert
            let alertController = UIAlertController(title: "iOScreator", message: "Please select an adress!", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
        //add coordinate to category
        addNotifyDelegate?.addLocation(selectedPin!.coordinate,locationName: selectedPin!.name!)
        addNotifyDelegate?.addNotifyPara(self.notifyRadius, timing: self.notifyTiming)
        self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
//    func regionWithGeotification(coordinate:CLLocationCoordinate2D,radius:Int,notifyTiming:String) -> CLCircularRegion {
//        // 1
//        let region = CLCircularRegion(center: self.selectedPin!.coordinate, radius: self.notifyRadius,identifier:)
//        // 2
//        region.notifyOnEntry = (geotification.eventType == .
//            OnEntry)
//        region.notifyOnExit = !region.notifyOnEntry
//        return region
//    }
    
    func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let reuseId = "pin"
        guard let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView else { return nil }
        
        pinView.pinTintColor = UIColor.orangeColor()
        pinView.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        button.addTarget(self, action: #selector(self.getDirections), forControlEvents: .TouchUpInside)
        pinView.leftCalloutAccessoryView = button
        
        return pinView
    }
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
        
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print("error:: \(error)")
        }
        
        
        
        //HandleMapSearch
        func dropPinZoomIn(placemark: MKPlacemark){
            // cache the pin
            selectedPin = placemark
            
            // clear existing pins
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }


