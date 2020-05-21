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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfSections section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as? RestaurantTableViewCell else {
            return UITableViewCell()}
        
        cell.configure(name: "Bistrot régent", horaires: "11h30 - 23h", dispo: false, ticket: "Accepte les titres resto")
        return cell
    }
    
        
}


