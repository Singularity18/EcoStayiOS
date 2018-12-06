//
//  SearchViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 12/5/18.
//  Copyright © 2018 Akash Veerappan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Place {
    var amenities: [Amenity] = []
    var name: String = ""
    var address: String = ""
    var desc: String = ""
    var price: String = ""
    var rating: String = ""
    var ratingNum: String = ""
}

class PlacesCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingVal: UILabel!
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var placesTableView: UITableView!
    
    var databaseReference: DatabaseReference = Database.database().reference()
    var auth: Auth = Auth.auth()
    var uid: String = ""
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = (auth.currentUser?.uid)!
        self.databaseReference = databaseReference.child(uid)
        getData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlacesCell
        cell?.addressLabel.text = places[indexPath.row].address
        cell?.nameLabel.text = places[indexPath.row].name
        cell?.priceLabel.text = places[indexPath.row].price
        cell?.ratingVal.text = places[indexPath.row].rating
        cell?.ratingLabel.text = places[indexPath.row].ratingNum
        return cell!
    }
    
    func getData() {
        databaseReference.observe(.value) { (snapshot) in
            if let val = snapshot.value as? [String:Any?] {
                if val["Leased Places"] != nil {
                    self.databaseReference = self.databaseReference.child("Leased Places")
                    self.databaseReference.observe(.value, with: { (snapshot) in
                        for c in snapshot.children {
                            var place: Place = Place()
                            place.name = (c as? DataSnapshot)?.key ?? ""
                            self.databaseReference = self.databaseReference.child(place.name)
                            print(self.databaseReference)
                            self.databaseReference.observe(.value, with: { (snapshot) in
                                print(snapshot)
                                if let val = snapshot.value as? [String:Any?] {
                                    place.desc = val["Description"] as! String
                                    place.address = val["Address"] as! String
                                    place.ratingNum = val["Address"] as! String
                                    place.rating = val["Rating"] as! String
                                    place.price = val["Price"] as! String
                                    self.places.append(place)
                                    DispatchQueue.main.async(execute: {
                                        self.placesTableView.reloadData()
                                    })
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
}
