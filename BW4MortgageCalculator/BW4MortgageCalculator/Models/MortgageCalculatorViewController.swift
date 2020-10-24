//
//  MortgageCalculatorViewController.swift
//  BW4MortgageCalculator
//
//  Created by Clayton Watkins on 10/13/20.
//

import UIKit

class MortgageCalculatorViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mortgageAmountTextField: UITextField!
    @IBOutlet weak var mortgageAmountLabel: UILabel!
    @IBOutlet weak var downPaymentLabel: UILabel!
    @IBOutlet weak var downPaymentTextField: UITextField!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var interestRateSlider: UISlider!
    @IBOutlet weak var loanTermLabel: UILabel!
    @IBOutlet weak var totalMortgageLabel: UILabel!
    @IBOutlet weak var monthlyPaymentLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var loanTermButton: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    let loanTerms = [15, 20, 30]
    let mortgageController = MortgageController.shared
    
    // Variables to keep track of user input for later calculation
    var chosenPrincipal: Int32?
    var chosenTerm: Int32?
    var chosenInterest: Double = 0
    var chosenDownPayment: Int32 = 0
    
    // Variable to keep track of current created Mortgage
    var currentMortgage: Mortgage?
    
     
    
    // Variables that store UIAlertControllers that are ready to be presented at any time
    var interestAlertController: UIAlertController {
        let alert = UIAlertController(title: "Please adjust the interest rate slider",
                                      message: "Please choose an interest rate option that is greater than 0",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        return alert
    }
    var noPrincipalAlertController: UIAlertController {
        let title = "Please enter principal amount"
        let message = "We cannot proceed with calculating anything without knowing your mortgage principal"
        let action = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        return alert
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        makeViewLookGood()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeViewLookGood()
        if mortgageController.animationsDisabled == false {
            animateViews()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetView()
    }
    
    // MARK: - IBActions
    @IBAction func interestRateSilderChanged(_ sender: UISlider) {
        // Rounding the slider value
        sender.setValue(Float(roundf(interestRateSlider.value * 4.0) / 4.0), animated: true)
        chosenInterest = Double(sender.value)
        updateViews()
    }
    
    @IBAction func selectLoanTermButtonPressed(_ sender: Any) {
        // Programatically presenting a UIPickerView
        picker.delegate = self
        picker.backgroundColor = ColorsHelper.LaurelGreen
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barTintColor = ColorsHelper.LaurelGreen
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @IBAction func calculateMortgageButtonPressed(_ sender: Any) {
        // Error Handling
        
        if chosenPrincipal == nil {
            present(noPrincipalAlertController, animated: true)
            return
        }
        
        if chosenDownPayment > chosenPrincipal! {
            let alert = UIAlertController(title: "Error", message: "Down payment is larger than Mortgage Amount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if chosenTerm == nil {
            let alert = UIAlertController(title: "Missing Loan Term", message: "Please select a loan term", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        // Creating a mortgage
        guard let term = chosenTerm, let principal = chosenPrincipal else { return }
        guard chosenInterest != 0 else {
            present(interestAlertController, animated: true)
            return
        }
        let myMortgage = Mortgage(term: term, name:"", principal: principal, interestRate: chosenInterest, downPayment: chosenDownPayment, montlyPayment: 0, totalCost: 0)
        self.currentMortgage = myMortgage
        // Calculating a mortgage payment
        let myMortgagePayment = mortgageController.calculateMortgagePayment(principal: myMortgage.principal,
                                                                            downPayment: myMortgage.downPayment,
                                                                            term: myMortgage.term,
                                                                            interestRate: myMortgage.interestRate)
        
        // Running Calculations if everyting is good
        myMortgage.monthlyPayment = Double(myMortgagePayment)
        
        let totalCost = mortgageController.calculateTotalMortgageCost(mortgage: myMortgage)
        
        myMortgage.totalCost = Double(totalCost)
        
        // Updating and revealing the payment and total labels
        monthlyPaymentLabel.isHidden = false
        totalMortgageLabel.isHidden = false
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedMonthlyPayment = numberFormatter.string(from: NSNumber(value: myMortgage.monthlyPayment))!
        let formattedTotalCost = numberFormatter.string(from: NSNumber(value: myMortgage.totalCost))!
        
        monthlyPaymentLabel.text = "$" + formattedMonthlyPayment + " per month"
        totalMortgageLabel.text  = "$" + formattedTotalCost
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any){
        guard let mortgage = currentMortgage else { print("No current mortgage to be found"); return}
        
        // Error Handling
        if mortgage.downPayment > mortgage.principal {
            let alert = UIAlertController(title: "Error", message: "Down payment is larger than Mortgage Amount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        // Adding a name to your Mortgage
        let alert = UIAlertController(title: "Give your Mortgage a name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Mortgage Name"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] _ in
            let textField = alert?.textFields![0]
            if let text = textField!.text, !text.isEmpty {
                self.currentMortgage!.name = text
                self.mortgageController.savedMortgages.append(mortgage)
                self.mortgageController.saveToPersistentStore()
                self.resetView()
            } else {
                let alert = UIAlertController(title: "Mortgage Not Saved", message: "Please enter a name for your mortgage", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true) {
            print("Presented")
        }
        
    }
    
    
    // MARK: - Private
    private func updateViews() {
        // Updating interest rate label with slider value and getting the last two decimal places
        let interestRate = String(format: "%.2f", interestRateSlider.value)
        interestRateLabel.text = "%" + interestRate
    }
    
    private func makeViewLookGood() {
        // Parent View
        self.view.backgroundColor = ColorsHelper.DarkSlateGreen
        
        // Upper most view on viewController
        firstView.layer.cornerRadius = 10
        firstView.backgroundColor = ColorsHelper.Nickel
        firstView.layer.shadowColor = UIColor.black.cgColor
        firstView.layer.shadowOpacity = 0.6
        firstView.layer.shadowOffset = CGSize(width: -10, height: 10)
        firstView.layer.shadowRadius = 5
        
        // Middle most view on viewController
        secondView.layer.cornerRadius = 10
        secondView.backgroundColor = ColorsHelper.Nickel
        secondView.layer.shadowColor = UIColor.black.cgColor
        secondView.layer.shadowOpacity = 0.6
        secondView.layer.shadowOffset = CGSize(width: -10, height: 10)
        secondView.layer.shadowRadius = 5
        
        // Lower most view on viewController
        thirdView.layer.cornerRadius = 10
        thirdView.backgroundColor = ColorsHelper.Nickel
        thirdView.layer.shadowColor = UIColor.black.cgColor
        thirdView.layer.shadowOpacity = 0.6
        thirdView.layer.shadowOffset = CGSize(width: -10, height: 10)
        thirdView.layer.shadowRadius = 5
        
        // Buttons
        loanTermButton.layer.cornerRadius = 15
        loanTermButton.backgroundColor = ColorsHelper.DarkSlateGreen
        calculateButton.layer.cornerRadius = 15
        calculateButton.backgroundColor = ColorsHelper.DarkSlateGreen
        saveButton.layer.cornerRadius = 15
        saveButton.backgroundColor = ColorsHelper.DarkSlateGreen
        
        // TextFields
        mortgageAmountTextField.backgroundColor = ColorsHelper.LightGrey
        downPaymentTextField.backgroundColor = ColorsHelper.LightGrey
        
        // Slider
        interestRateSlider.tintColor = ColorsHelper.LaurelGreen
        
    }
    
    // Once done with PickerView, Done button removes the picker
    @objc private func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    private func animateViews() {
        let views = [firstView, secondView, thirdView]
        let viewControllerHeight = self.view.bounds.size.height
        for view in views{
            view!.transform = CGAffineTransform(translationX: 0, y: viewControllerHeight)
        }
        var delayCounter = 0
        for view in views {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                view!.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
    }
    
    private func resetView() {
        mortgageAmountLabel.text = "$0.00"
        mortgageAmountTextField.text = ""
        downPaymentLabel.text = "$0.00"
        downPaymentTextField.text = ""
        interestRateLabel.text = ""
        interestRateSlider.value = 0
        loanTermLabel.text = ""
        totalMortgageLabel.text = ""
        monthlyPaymentLabel.text = ""
    }
}

// MARK: - Extension -

extension MortgageCalculatorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // After pressing return/enter textfield will harvest info, check if it's empty, and checks if value is a double
        if let number = downPaymentTextField.text, !number.isEmpty, number.isDouble{
            // This formats the string so that the string will only return a number with two decimal places
            let downPayment = Double(downPaymentTextField.text!)
            chosenDownPayment = Int32(downPayment!)
            
            // Formats number to look nicer and adds commas
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value: chosenDownPayment))!
            
            downPaymentLabel.text = "$" + String(formattedNumber)
            downPaymentTextField.resignFirstResponder()
        }
        
        if let mortgage = mortgageAmountTextField.text, !mortgage.isEmpty, mortgage.isDouble {
            // This formats the string so that the string will only return a number with two decimal places
            let mortgageAmount = Double(mortgageAmountTextField.text!)
            chosenPrincipal = Int32(mortgageAmount!)
            
            // Formats number to look nicer and adds commas
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value: chosenPrincipal!))!
            
            mortgageAmountLabel.text = "$" + String(formattedNumber)
            
            if mortgageAmountTextField.isFirstResponder {
                downPaymentTextField.becomeFirstResponder()
            }
            
        }
        return true
    }
}

extension MortgageCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loanTerms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(loanTerms[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentTerm = loanTerms[row]
        chosenTerm = Int32(currentTerm)
        loanTermLabel.text = "\(currentTerm) years"
    }
    
}

// Extension to check if string is a double
extension String {
    var isDouble: Bool {
        Double(self) != nil
    }
}

// This extension handles adding a 'done' button to any keyboard that appears when a textField is highlighted
extension UITextField {
    
    @IBInspectable var doneAccessory: Bool {
        
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
