//
//  Restaurant.swift
//  BookEat
//
//  Created by Thomas Samy on 28/05/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import Foundation

struct Restaurant {
    var name: String?
    var horaires: [String]?
    var ticket: Bool?
    var address: String?
    var url_img: String?
    var url_site: String?
    
    func isOpen() -> Bool{
        var currentHour = "\(Calendar.current.component(.hour, from: Date()))"
        if Calendar.current.component(.minute, from: Date()) < 10 {
            currentHour += "0\(Calendar.current.component(.minute, from: Date()))"
        }else{
            currentHour += "\(Calendar.current.component(.minute, from: Date()))"
        }
        
        let horaires = self.horaires?[Calendar.current.component(.weekday, from: Date())-1].components(separatedBy: "/")
        for horaire in horaires! {
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
