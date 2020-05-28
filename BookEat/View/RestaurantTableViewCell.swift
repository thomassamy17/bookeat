//
//  RestaurantTableViewCell.swift
//  BookEat
//
//  Created by Thomas Samy on 29/04/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var nameRestoLabel: UILabel!
    @IBOutlet weak var horairesRestoLabel: UILabel!
    @IBOutlet weak var dispoRestoLabel: UILabel!
    @IBOutlet weak var ticketRestoLabel: UILabel!
    @IBOutlet weak var imageViewResto: UIImageView!
    
    //MARK: init
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Functions

    func configure(name: String, horaires: String, dispo: Bool, ticket: Bool, url: String){
        nameRestoLabel.text = name
        horairesRestoLabel.text = horaires
        if dispo {
            dispoRestoLabel.text = "Ouvert maintenant"
        }else{
            dispoRestoLabel.text = "Fermé"
            dispoRestoLabel.textColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0);
        }
        ticketRestoLabel.text = ticket ? "Accepte les titres restaurants" : ""
        setImage (from: url )
        
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageViewResto.image = image
            }
        }
    }
    
}
