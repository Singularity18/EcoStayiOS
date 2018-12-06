//
//  LeaseViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 11/19/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class LeaseViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    static var nameOfPlace = ""
    
    var auth: Auth = Auth.auth()
    var databaseReference: DatabaseReference = Database.database().reference()
    
    var currentUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        firstView.layer.cornerRadius = 10
        addressView.layer.cornerRadius = 10
        priceView.layer.cornerRadius = 10
        
        currentUID = auth.currentUser?.uid ?? ""
        databaseReference = databaseReference.child(currentUID)
        
    }
    
    @IBAction func onShareClicked(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        addressField.text = String((locValue.latitude)) + " " + String((locValue.longitude))
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: ((userLocation?.coordinate)!), latitudinalMeters: 600, longitudinalMeters: 600)
    }
    
    @IBAction func onNextClicked(_ sender: Any) {
        if (nameField.text?.count) ?? 0 >= 1 {
            LeaseViewController.nameOfPlace = nameField.text!
            databaseReference = databaseReference.child("Leased Places").child(nameField.text!)
        }
        if (descriptionField.text?.count ?? 0 > 25) {
            databaseReference.child("Description").setValue(descriptionField.text)
        }
        if addressField.text?.count ?? 0 >= 6 {
            databaseReference.child("Address").setValue(addressField.text)
        }
        if priceField.text?.count ?? 0 >= 1 {
            databaseReference.child("Price").setValue(priceField.text)
        }
    }
}
