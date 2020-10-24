//
//  SettingsViewController.swift
//  BW4MortgageCalculator
//
//  Created by Clayton Watkins on 10/22/20.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - Properties
    let mortgageController = MortgageController.shared
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Welcome, " + mortgageController.currentUser! + "!"
        logOutButton.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    // MARK: - Private Methods
    private func updateViews() {
        let switchState = UserDefaults.standard.bool(forKey: "animation")
        if switchState {
            animationSwitch.setOn(true, animated: false)
        } else {
            animationSwitch.setOn(false, animated: false)
        }
    }
    
    // MARK: - IBActions
    @IBAction func switchFlipped(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: "animation")
        } else {
            UserDefaults.standard.setValue(false, forKey: "animation")
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        self.mortgageController.currentUser = nil
        self.mortgageController.loggedInBool = false
        
        UserDefaults.standard.setValue(self.mortgageController.loggedInBool, forKey: "loggedIn")
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        
        
    }
}
