//
//  HomeViewController.swift
//  BookEat
//
//  Created by Thomas Samy on 28/04/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties

    var restaurants = [Restaurant]()
    var currentRestaurant: Restaurant?

    //MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: Functions
    
    func loadData() {
        let db = Firestore.firestore()
        db.collection("restaurant").getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let r = Restaurant(name: (document.data()["name"] as! String),
                                       horaires: (document.data()["horaires"] as! [String]),
                                       ticket: (document.data()["ticket"] as! Bool),
                                       address: (document.data()["address"] as! String),
                                       url_img: (document.data()["url_img"] as! String),
                                       url_site: (document.data()["url_site"] as! String))
                    self.restaurants.append(r)
                }
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetails" {
            let successVC = segue.destination as! RestaurantDetailsViewController
            successVC.restaurant = currentRestaurant!
        }
    }
    
}

//MARK: Extension TableView

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as? RestaurantTableViewCell else {
            return UITableViewCell()}
        
        let restaurant = self.restaurants[indexPath[1]]
        let horaires = restaurant.horaires![Calendar.current.component(.weekday, from: Date())-1]
        cell.configure(name: restaurant.name,
                       horaires: horaires,
                       dispo: restaurant.isOpen(),
                       ticket: restaurant.ticket,
                       url: restaurant.url_img)
        
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
        currentRestaurant = restaurants[indexPath[1]]
        performSegue(withIdentifier: "segueToDetails", sender: nil)
    }
    
    
}




