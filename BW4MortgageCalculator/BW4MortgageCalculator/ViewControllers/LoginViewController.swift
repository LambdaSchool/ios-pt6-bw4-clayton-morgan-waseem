//
//  LoginViewController.swift
//  BW4MortgageCalculator
//
//  Created by Clayton Watkins on 10/22/20.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Properties
    let defaults = UserDefaults.standard
    let mortgageController = MortgageController.shared
    var alert: UIAlertController {
        let alert = UIAlertController(title: "No Username", message: "Please enter a username", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        return alert
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 15
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segueIfUsernameExists()
    }
    
    
    // MARK: - Private Methods
    private func segueIfUsernameExists() {
        if UserDefaults.standard.bool(forKey: "loggedIn") && mortgageController.currentUser != nil{
            performSegue(withIdentifier: "LoginSegue", sender: self)
            nameTextField.text = ""
          }
      }
    
    // MARK: - IBAction
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = nameTextField.text, !username.isEmpty else { self.present(alert, animated: true, completion: nil); return}
        mortgageController.currentUser = username
        mortgageController.loggedInBool = true
        UserDefaults.standard.setValue(mortgageController.loggedInBool, forKey: "loggedIn")
        UserDefaults.standard.setValue(false, forKey: "animations")
        segueIfUsernameExists()
    }
    
    @IBAction func unwind( _seg: UIStoryboardSegue) {
    }
}
