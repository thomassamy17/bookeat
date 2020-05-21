//
//  LoginViewController.swift
//  BookEat
//
//  Created by Thomas Samy on 28/04/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate  {

    //MARK: Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var connexionIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginRestaurantButton: UIButton!
    
    //MARK: Properties
    
    private var user: User!

    
    //MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton(with: loginButton)
        initButton(with: registerButton)
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            redirectIfUserConnect()
        }
    }
    
    //MARK: Functions
    
    func hideObjects(bool: Bool){
        loginButton.isHidden = bool
        registerButton.isHidden = bool
        connexionIndicator.isHidden = !bool
    }
    
    func displayAlertError(with message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func redirectIfUserConnect(){
        let centerVC = self.storyboard!.instantiateViewController(withIdentifier: "TabbarViewController") as! TabBarViewController
        self.view.window?.rootViewController = centerVC
        self.view.window?.makeKeyAndVisible()
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
    
    @IBAction func connexion(_ sender: UIButton) {
        hideObjects(bool: true)
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            displayAlertError(with: "Fill in all fields")
            hideObjects(bool: false)
        } else {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
                strongSelf.hideObjects(bool: false)
                if error != nil {
                    strongSelf.displayAlertError(with:"Incorrect email or password")
                }else{
                    strongSelf.redirectIfUserConnect()
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    
}
