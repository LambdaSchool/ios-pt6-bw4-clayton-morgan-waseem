//
//  MortgageTableViewCell.swift
//  BW4MortgageCalculator
//
//  Created by Clayton Watkins on 10/22/20.
//

import UIKit

class MortgageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var mortgageName: UILabel!
    
    // MARK: - Properties
    static let reuseIdentifier = "MortgageCell"
    var mortgage: Mortgage? {
        didSet{
            updateViews()
        }
    }
    
    // MARK: - Initalizers
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
        
    // MARK: - Private Methods
    private func updateViews() {
        guard let mortgage = mortgage else { return }
        mortgageName.text = mortgage.name
    }
    
}
