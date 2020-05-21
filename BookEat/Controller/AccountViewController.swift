//
//  AccountViewController.swift
//  BookEat
//
//  Created by Thomas Samy on 01/05/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController, UpdateDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastname: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loadDataActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var updatePhoneButton: UIButton!
    @IBOutlet weak var updateMailButton: UIButton!
    @IBOutlet weak var updatePasswordButton: UIButton!
    
    //MARK: Properties

    var documentUID: String?
    var sender: Sender?
    
    //MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initButton(with: logoutButton)
        self.initData(with: Auth.auth().currentUser!)
    }
    
    //MARK: Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueForUpdate" {
            let updatePhoneVC = segue.destination as! UpdateViewController
            updatePhoneVC.delegate = self
            updatePhoneVC.sender = self.sender
            updatePhoneVC.documentUID = self.documentUID
        }
    }
    
    func initButton(with button: UIButton){
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func initData(with u: FirebaseAuth.User){
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: u.uid).getDocuments(){(query, err) in
            if let err = err {
                self.displayAlertError(with: "Error getting documents: \(err)")
            } else {
                for document in query!.documents {
                    self.firstnameLabel.text = (document.data()["firstname"] as! String)
                    self.lastnameLabel.text = (document.data()["lastname"] as! String)
                    self.phoneLabel.text = (document.data()["phone"] as! String)
                    self.mailLabel.text = u.email
                    self.documentUID = document.documentID
                    self.showElements(with: true)
                }
            }
        }
    }
    
    func showElements(with bool: Bool){
        firstname.isHidden = !bool
        firstnameLabel.isHidden = !bool
        lastname.isHidden = !bool
        lastnameLabel.isHidden = !bool
        phone.isHidden = !bool
        phoneLabel.isHidden = !bool
        email.isHidden = !bool
        mailLabel.isHidden = !bool
        password.isHidden = !bool
        passwordLabel.isHidden = !bool
        logoutButton.isHidden = !bool
        updatePhoneButton.isHidden = !bool
        updateMailButton.isHidden = !bool
        updatePasswordButton.isHidden = !bool
        loadDataActivityIndicator.isHidden = bool
    }
    
    func displayAlertError(with message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    //MARK: UpdateDelegate
    
    func getResponse() {
        self.showElements(with: false)
        self.initData(with: Auth.auth().currentUser!)
    }
    
    //MARK: Actions

    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        let centerVC = self.storyboard!.instantiateViewController(withIdentifier: "navigationController") as! NavigationViewController
        self.view.window?.rootViewController = centerVC
        self.view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func goToPhoneUpdate(_ sender: UIButton) {
        self.sender = .phone
        performSegue(withIdentifier: "segueForUpdate", sender: nil)
        
    }
    
    @IBAction func goToMailUpdate(_ sender: UIButton) {
        self.sender = .email
        performSegue(withIdentifier: "segueForUpdate", sender: nil)
    }
    
    @IBAction func goToPasswordUpdate(_ sender: UIButton) {
        self.sender = .password
        performSegue(withIdentifier: "segueForUpdate", sender: nil)
    }


}

protocol UpdateDelegate
{
    func getResponse()
}


