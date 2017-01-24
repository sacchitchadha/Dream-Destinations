//
//  ViewController.swift
//  destinations
//
//  Created by Sacchit Chadha  on 06/06/16.
//  Copyright © 2016 Sacchit Chadha . All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if place == -1
        {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        }
            
        else
        {
            var latitude:Double = 0
            var longitude:Double = 0
            if places[place]["latitude"] != nil
            {
                latitude = NSString(string: places[place]["latitude"]!).doubleValue
            }
            if places[place]["longitude"] != nil
            {
                longitude = NSString(string: places[place]["longitude"]!).doubleValue
            }
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let latDelta:CLLocationDegrees = 0.01
            let lonDelta:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            self.map.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[place]["name"]
            self.map.addAnnotation(annotation)
            
            
        }
        
        
        let userGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.action(_:)))
        map.addGestureRecognizer(userGesture)
    }
    
    func action(_ gestureRecognizer:UIGestureRecognizer)
    {
        //if (gestureRecognizer.state == UIGestureRecognizerState.Began)
        //{
        let point = gestureRecognizer.location(in: self.map)
        let newCoordinate = map.convert(point, toCoordinateFrom: self.map)
        let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            var title = ""
            
            if (error == nil)
            {
                if let p = placemarks?[0]
                {
                    var subThoroughFare = ""
                    var thoroughFare = ""
                    
                    if p.subThoroughfare != nil
                    {
                        subThoroughFare = p.subThoroughfare!
                    }
                    if p.thoroughfare != nil
                    {
                        thoroughFare = p.thoroughfare!
                    }
                    title = "\(subThoroughFare) \(thoroughFare)"
                }
            }
            
            if title == ""
            {
                title = "Added \(Date())"
            }
            
            places.append(["name":title, "latitude":"\(newCoordinate.latitude)", "longitude":"\(newCoordinate.longitude)"])
            //print("\(places)\n")
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinate
            annotation.title = title
            self.map.addAnnotation(annotation)
            
            UserDefaults.standard.set(places, forKey: "places")
            
        })
        
        //}
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.map.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

