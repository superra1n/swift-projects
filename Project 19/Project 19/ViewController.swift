//
//  ViewController.swift
//  Project 19
//
//  Created by LiangTzu Chun on 3/19/16.
//  Copyright © 2016 Jim. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var capitals = [Capital]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.", favorite: false)
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.", favorite: false)
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.", favorite: false)
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", favorite: false)
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", favorite: false)
        let taipei = Capital(title: "Taipei", coordinate: CLLocationCoordinate2D(latitude: 25.0911, longitude: 121.5598), info: "大台北", favorite: false)
        let taichung = Capital(title: "Taichung", coordinate: CLLocationCoordinate2D(latitude: 24.1469000, longitude: 120.6839000), info: "台中", favorite: false)
        
        capitals.append(london)
        capitals.append(oslo)
        capitals.append(paris)
        capitals.append(rome)
        capitals.append(washington)
        capitals.append(taipei)
        capitals.append(taichung)
        
        mapView.addAnnotations(capitals)
        
        mapView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: "changeMapType")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        let identifier = "Capital"
        
        // 2
        if annotation.isKindOfClass(Capital.self) {
            // 3
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView

            if annotationView == nil {
                //4
                
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
                
                let favBtn = UIButton(type: .ContactAdd)
                annotationView!.leftCalloutAccessoryView = favBtn
                
            } else {
                // 6
                let capital = annotation as! Capital
                if capital.favorite {
                    annotationView!.pinTintColor = UIColor.purpleColor()
                    let unFavBtn = UIButton(type: .DetailDisclosure)
                    unFavBtn.tag = 1
                    annotationView!.leftCalloutAccessoryView = unFavBtn
                }
                else {
                    annotationView!.pinTintColor = UIColor.redColor()
                    let favBtn = UIButton(type: .ContactAdd)
                    annotationView!.leftCalloutAccessoryView = favBtn
                }
            }
            
            return annotationView
        }
        
        // 7
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let capital = view.annotation as! Capital
        if control == view.rightCalloutAccessoryView {
            let placeName = capital.title
            let placeInfo = capital.info
            let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            var alertTitle = "Favorite"
            if control.tag == 1 {
                alertTitle = "Remove favorite"
            }
            let ac = UIAlertController(title: alertTitle, message: "", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: ({ _ in
                for city in self.capitals {
                    if city.title == capital.title {
                        mapView.removeAnnotation(city)
                        city.favorite = !city.favorite
                        mapView.addAnnotation(city)
                    }
                }
            })))
            
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func changeMapType() {
        let ac = UIAlertController(title: "Choose map type", message: "", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Satellite", style: .Default, handler: {ac in self.mapView.mapType = .Satellite}))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
}

