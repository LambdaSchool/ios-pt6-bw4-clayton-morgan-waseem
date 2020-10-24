//
//  SavedMortgagesTableViewController.swift
//  BW4MortgageCalculator
//
//  Created by Clayton Watkins on 10/14/20.
//

import UIKit

class SavedMortgagesTableViewController: UITableViewController {

    // MARK: - Properties
    let mortgageController = MortgageController.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorsHelper.DarkSlateGreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if mortgageController.animationsDisabled == false {
            animateTable()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mortgageController.savedMortgages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MortgageTableViewCell.reuseIdentifier, for: indexPath) as? MortgageTableViewCell else { return UITableViewCell()}
        cell.mortgage = mortgageController.savedMortgages[indexPath.row]
       
        cell.cellView.layer.cornerRadius = 15
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let mortgage = mortgageController.savedMortgages[indexPath.row]
            mortgageController.deleteFromPersistentStore(mortgage: mortgage)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Private Methods
    
    // Animate Cells
    private func animateTable() {
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: -tableViewHeight)
        }
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MortgageDetailSegue" {
            let detailVC = segue.destination as! MortgageDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedMortgage = mortgageController.savedMortgages[indexPath.row]
            detailVC.mortgage = selectedMortgage
        }
        
    }
    
}
