//
//  LocationHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 5/28/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import CoreLocation
protocol LocationHandlerDelegate:class {
    func locationHandlerSucceed()
    func locationHandlerFailed(msg:String)
    
}
class LocationHandler: NSObject,CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    var isWaitingForLocation = true
    static public var latitude:Double = 0
    static public var longitude:Double = 0
    weak var delegate:LocationHandlerDelegate?
    public func createManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000
        //
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        if CLLocationManager.authorizationStatus() == .restricted {
            self.delegate?.locationHandlerFailed(msg: "It seems that there is restrication in location services related the app")
        }else if CLLocationManager.authorizationStatus() == .denied {
//            if let loc = locationManager.location
//            {
//            
//            }else
//            {
                self.delegate?.locationHandlerFailed(msg: "To re-enable, please go to Settings and turn on Location Service for this app.")

//            }
        } else
        {

        }
    }
    class func isThereCashedLocation() ->Bool
    {
        let defaults = UserDefaults.standard
        
        
        if let lat = defaults.object(forKey: "userLat") as? Double,let lng = defaults.object(forKey: "userLng")  as? Double {
            latitude = lat
            longitude = lng
            return true
        }
        return false
    }
    fileprivate class func setLatLng(_ cordinates:CLLocationCoordinate2D)
    {
        let defaults = UserDefaults.standard
        //
        let lat = Double((cordinates.latitude))
        latitude = lat
        defaults.set(lat, forKey: "userLat")
        //
        let lng = Double((cordinates.longitude))
        longitude = lng
        defaults.set(lng, forKey: "userLng")
        //
        defaults.synchronize()
    }

    func manualLocation(_ cordinates:CLLocationCoordinate2D)
    {
        LocationHandler.setLatLng(cordinates)
        if isWaitingForLocation
        {
            isWaitingForLocation = false
            self.delegate?.locationHandlerSucceed()
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last?.coordinate else{
            return
        }
        manualLocation(lastLocation)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if isWaitingForLocation
        {
            self.delegate?.locationHandlerFailed(msg: "Please Enable GPS")
        }
    }
    
}
