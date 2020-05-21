//
//  User.swift
//  BookEat
//
//  Created by Thomas Samy on 29/04/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import Foundation

struct User{
    var firstName: String?
    var lastname: String?
    var email: String?
    var phone: String?
    var password: String?
    var confirmPass: String?
    
    enum Status {
        case accepted
        case rejected(String)
    }
    
    var status: Status {

        if lastname!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastname!.count < 1{
            return .rejected("Fill in lastname")
        }
        
        if firstName!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || firstName!.count < 1{
            return .rejected("Fill in firstname")
        }
        
        if email!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return .rejected("Fill in email address")
        }
        
        if phone!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return .rejected("Fill in phone number")
        }else if phone!.range(of: "^0[1-9][0-9]{8}$",options: .regularExpression) == nil{
            return .rejected("Phone number is invalid")
        }
        
        if password!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return .rejected("Fill in password")
        }else if password!.trimmingCharacters(in: .whitespacesAndNewlines).count < 8{
            return .rejected("Password must be at least 8 characters long")
        }else if password!.rangeOfCharacter(from: .whitespacesAndNewlines) != nil{
            return .rejected("Spaces in password are not allowed")
        }else if password != confirmPass{
            return .rejected("Passwords not matching")
        }
        return .accepted
    }
}

