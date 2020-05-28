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
                                       url: (document.data()["url"] as! String))
                    print(r)
                    self.restaurants.append(r)
                }
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func checkOpen(with horaires: String) -> Bool{
        var currentHour = "\(Calendar.current.component(.hour, from: Date()))"
        if Calendar.current.component(.minute, from: Date()) < 10 {
            currentHour += "0\(Calendar.current.component(.minute, from: Date()))"
        }else{
            currentHour += "\(Calendar.current.component(.minute, from: Date()))"
        }
        
        let horaires = horaires.components(separatedBy: ":")
        for horaire in horaires {
            let array = horaire.components(separatedBy: "-")
            if let open = Int(array[0]), let close = Int(array[1]), let current = Int(currentHour) {
                if open < current && current < close {
                    return true
                }
            }
        }
        return false
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
                       dispo: checkOpen(with: horaires),
                       ticket: restaurant.ticket,
                       url: restaurant.url)
        
        return cell
    }
}




