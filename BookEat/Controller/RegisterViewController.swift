//
//  RegisterViewControler.swift
//  BookEat
//
//  Created by Thomas Samy on 28/04/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    //MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initButton(with: registerButton)
        lastNameTextField.becomeFirstResponder()
    }
    
    //MARK: Functions
    
    func validateFields() -> User {
        let firstname = firstNameTextField.text!
        let lastname = lastNameTextField.text!
        let phone = phoneTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let confirm = confirmPassTextField.text!
        
        let u = User(firstName: firstname, lastname: lastname, email: email, phone: phone, password: password, confirmPass: confirm)
        
        return u
    }
    
    func displayAlertError(with message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    func initButton(with button: UIButton){
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        lastNameTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func validate(_ sender: UIButton) {
        
        let user = validateFields()
        switch user.status {
        case .rejected(let error):
            displayAlertError(with: error)
        
        case .accepted:
            Auth.auth().createUser(withEmail: user.email!, password: user.password!) { authResult, error in
                if error != nil  {
                    self.displayAlertError(with: "The email address is badly formatted")
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data:
                    ["uid":authResult!.user.uid,"firstname": user.firstName!,"lastname": user.lastname!,"phone":user.phone!]) { (error) in
                        if error != nil {
                            self.displayAlertError(with: "Error saving user data")
                        }else{
                            let centerVC = self.storyboard!.instantiateViewController(withIdentifier: "TabbarViewController") as! TabBarViewController
                            self.view.window?.rootViewController = centerVC
                            self.view.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
    }
    
    
}
