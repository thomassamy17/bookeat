//
//  RestaurantDetailsViewController.swift
//  BookEat
//
//  Created by Thomas Samy on 29/05/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import UIKit

class RestaurantDetailsViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dispo: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var monday: UILabel!
    @IBOutlet weak var tuesday: UILabel!
    @IBOutlet weak var wednesday: UILabel!
    @IBOutlet weak var thursday: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var saturday: UILabel!
    @IBOutlet weak var sunday: UILabel!
    @IBOutlet weak var ticket: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    
    //MARK: Properties
    
    var restaurant: Restaurant = Restaurant()
    
    //MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton(with: bookButton)
        initData()

    }
    
    //MARK: Functions
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    func initButton(with button: UIButton){
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func initData(){
        self.name.text = restaurant.name
        self.address.text = restaurant.address
        if let url = restaurant.url_img {
            setImage(from: url)
        }
        if restaurant.isOpen() {
            dispo.text = "Ouvert"
        }else{
            dispo.text = "Fermé"
            dispo.textColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0);
            bookButton.isHidden = true
            bookButton.isEnabled = false
        }
        self.monday.text = "Lundi \(restaurant.horaires![1] )"
        self.tuesday.text = "Mardi \(restaurant.horaires![2])"
        self.wednesday.text = "Mercredi \(restaurant.horaires![3])"
        self.thursday.text = "Jeudi \(restaurant.horaires![4])"
        self.friday.text = "Vendredi \(restaurant.horaires![5])"
        self.saturday.text = "Samedi \(restaurant.horaires![6])"
        self.sunday.text = "Dimanche \(restaurant.horaires![0])"
        self.ticket.text = restaurant.ticket! ? "Accepte les titres restaurant" : ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToBook" {
            let successVC = segue.destination as! BookViewController
            successVC.restaurant = restaurant
        }
    }

    //MARK: Actions
    
    @IBAction func book(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToBook", sender: nil)
    }

}
