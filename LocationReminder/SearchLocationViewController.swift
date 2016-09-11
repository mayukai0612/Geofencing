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
    func addNotifyPara(radius:CLLocationDistance,timing:String)
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
    var notifyTiming:String = "On Entry"
    var notifyRadius:CLLocationDistance = 50
    var geofencing: Geofencing?

    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add save button to navigation bar
        let saveBtn : UIBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchLocationViewController.OnSaveClicked))
        
        self.navigationItem.setRightBarButtonItem(saveBtn, animated: false)
        
        mapView.delegate = self
        
        //set locationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        self.locationManager.startUpdatingLocation()
        self.mapView!.showsUserLocation = true
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("SearchLocationTable") as! SearchLocationTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        
        //search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
        //add action on segment controller
        entryLeavingSegmentController.addTarget(self, action: #selector(SearchLocationViewController.notifyTimingChanged(_:)), forControlEvents: UIControlEvents.AllEvents)

        radiusSegmentController.addTarget(self,action:#selector(SearchLocationViewController.notifyRadiusChanged(_:)), forControlEvents: UIControlEvents.AllEvents)

        loadViews()
     

        
    }
    
    @IBAction func notifyTimingClicked(sender: AnyObject) {
        
       getTiming()
    }
    
    @IBAction func notifyRadiusClicked(sender: AnyObject) {
        
        
       getRadius()

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
    
    //timing changed
    func notifyTimingChanged(segmentController:UISegmentedControl)
    {
        if (self.geofencing == nil){
            
            errorAlert("No place chosen!",msg: "Please search an address first!")
        }else{
        getTiming()
        addAnnotation(self.geofencing!)
        self.geofencing?.notifyTiming = self.notifyTiming
        }
    }
    
    //radius changed
    func notifyRadiusChanged(segmentController:UISegmentedControl)
    {
        if (self.geofencing == nil){
            
            errorAlert("No place chosen!",msg: "Please search an address first!")
        }else{
        getRadius()
        removeRadiusOverlay()
        self.geofencing?.radius = self.notifyRadius
        addRadiusCircleForGeofencing(self.geofencing!)
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
    
    func errorAlert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func getRadius()
    {
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
    
    func getTiming()
    {
        
        if(entryLeavingSegmentController.selectedSegmentIndex == 0)
        {
            self.notifyTiming  =  "On Entry"
        }
        
        if(entryLeavingSegmentController.selectedSegmentIndex == 1)
        {
            self.notifyTiming  =  "On Leaving"
        }

    }
    
    
    func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
//        
//        guard !(annotation is MKUserLocation) else { return nil }
//        
//        let reuseId = "pin"
//        guard let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView else { return nil }
//        
//        pinView.pinTintColor = UIColor.orangeColor()
//        pinView.canShowCallout = true
//        let smallSquare = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
//        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
//        button.addTarget(self, action: #selector(self.getDirections), forControlEvents: .TouchUpInside)
//        pinView.leftCalloutAccessoryView = button
//        
//        return pinView
//    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer!{
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = UIColor.greenColor()
            circleRenderer.fillColor = UIColor.greenColor().colorWithAlphaComponent(0.4)
            return circleRenderer
        }
        return nil
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
        
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            let span = MKCoordinateSpanMake(0.5, 0.5)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.locationManager.stopUpdatingLocation()
            mapView.setRegion(region, animated: false)
        }
        
        func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print("error:: \(error)")
        }
        
        
        
        //HandleMapSearch
        func dropPinZoomIn(placemark: MKPlacemark){
            // cache the pin
            selectedPin = placemark
            
            //geofencing
            self.geofencing = Geofencing(coordinate: placemark.coordinate, radius: self.notifyRadius, identifier:NSUUID().UUIDString , notifyTiming: self.notifyTiming)
            removeRadiusOverlay()
            addAnnotation(self.geofencing!)
            
            //add circle overlay
            addRadiusCircleForGeofencing(self.geofencing!)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            mapView.setRegion(region, animated: true)
            
        }
    
    func addAnnotation(geofencing:Geofencing)
    {
    
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        //annotations
        let annotation = MKPointAnnotation()
        annotation.coordinate = geofencing.coordinate!
        annotation.title = self.selectedPin?.name
        
        //
        let radius = self.notifyRadius
        let timing = self.notifyTiming
        annotation.subtitle = "Radius:\(radius) \(timing)"
        
        //add annotation
        mapView.addAnnotation(annotation)

    }
    
    //remove overlay from map view
    func removeRadiusOverlay() {
        if let overlays = mapView?.overlays {
            if(overlays.count > 0){
            mapView?.removeOverlay(overlays[0])
            }
        }
    }
    
    func addRadiusCircleForGeofencing(geofencing:Geofencing ) {
        self.mapView.addOverlay(MKCircle(centerCoordinate: geofencing.coordinate!, radius: geofencing.radius!))
    }
    
    func loadViews() {
        if(self.geofencing != nil)
        {
            
            addAnnotation(self.geofencing!)
            addRadiusCircleForGeofencing(self.geofencing!)
            //add circle overlay
            addRadiusCircleForGeofencing(self.geofencing!)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(self.geofencing!.coordinate!, span)
            mapView.setRegion(region, animated: true)

            switch self.geofencing!.notifyTiming! {
            case "On Entry":
                entryLeavingSegmentController.selectedSegmentIndex = 0
            case "On Leaving":
                entryLeavingSegmentController.selectedSegmentIndex = 1
            default:
                
                entryLeavingSegmentController.selectedSegmentIndex = 0

            }
            
            switch Int((self.geofencing?.radius)!) {
            case 50:
                radiusSegmentController.selectedSegmentIndex = 0

            case 250:
                radiusSegmentController.selectedSegmentIndex = 1

            case 1000:
                radiusSegmentController.selectedSegmentIndex = 2
            default:
                
                radiusSegmentController.selectedSegmentIndex = 0
            }
        }
        else{
            //set default notify timing
            entryLeavingSegmentController.selectedSegmentIndex = 0
            
            //set default notify radius
            radiusSegmentController.selectedSegmentIndex = 0
        
        
        }
    }

}


