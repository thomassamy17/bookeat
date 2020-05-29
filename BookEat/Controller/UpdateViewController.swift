//
//  UpdateViewController.swift
//  BookEat
//
//  Created by Thomas Samy on 01/05/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UpdateViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var newField: UITextField!
    @IBOutlet weak var validButton: UIButton!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var confirmPassLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var confirmPassField: UITextField!
    
    //MARK: Properties
    
    var documentUID: String?
    var delegate:UpdateDelegate?
    var sender:Sender?
    let db = Firestore.firestore()
    
    //MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton(with: validButton)
        if let sender = sender {
            switch sender {
            case .phone:
                updateLabel.text = "Numéro de téléphone"
            case .email:
                updateLabel.text = "Adresse mail"
            case .password:
                updateLabel.text = "Mot de passe"
                newField.isSecureTextEntry = true
                confirmPassLabel.isHidden = false
                confirmPassField.isHidden = false
                
            }
        }
    }
    
    //MARK: Functions

    fileprivate func updatePhone() {
        if let err = verifPhone(with: newField.text!) {
            self.isHidden(bool: false)
            self.displayAlertError(with: err)
        }else{
            self.db.collection("users").document(documentUID!).updateData([
                "phone": newField.text!
            ]) { err in
                if let err = err {
                    self.isHidden(bool: false)
                    self.displayAlertError(with: "Error updating phone: \(err)")
                } else {
                    self.delegate?.getResponse()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    fileprivate func updateEmail() {
        Auth.auth().currentUser?.updateEmail(to: self.newField.text!) { (err) in
            if let err = err {
                self.isHidden(bool: false)
                self.displayAlertError(with: err.localizedDescription)
            } else {
                self.delegate?.getResponse()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    fileprivate func updatePassword() {
        if let err = verifPassword(with: newField.text!, confirm: confirmPassField.text!) {
            self.isHidden(bool: false)
            self.displayAlertError(with: err)
        }else{
            Auth.auth().currentUser?.updatePassword(to: self.newField.text!) { (err) in
                if let err = err {
                    self.isHidden(bool: false)
                    self.displayAlertError(with: err.localizedDescription)
                } else {
                    self.delegate?.getResponse()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    func displayAlertError(with message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func isHidden(bool: Bool){
        self.validButton.isHidden = bool
        self.loadingActivityIndicator.isHidden = !bool
    }
    
    func initButton(with button: UIButton){
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    
    @IBAction func validate(_ sender: UIButton) {
        isHidden(bool: true)
        if newField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            self.displayAlertError(with: "Fill in field")
            isHidden(bool: false)
        }else{
            if let sender = self.sender {
                switch sender {
                case .phone:
                    self.updatePhone()
                case .email:
                    self.updateEmail()
                case .password:
                    self.updatePassword()
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        newField.resignFirstResponder()
        confirmPassField.resignFirstResponder()
    }
    
    
    
}
