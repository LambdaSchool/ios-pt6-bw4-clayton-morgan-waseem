//
//  Mortgage.swift
//  BW4MortgageCalculator
//
//  Created by Waseem Idelbi on 10/13/20.
//

import Foundation

struct Mortgage {
    
    /// Properties
    let term: Double
    let interestRate: Double
    let principal: Double
    let downPayment: Double
    
    var monthlyPayment: Double {
        
        /// Please be patient as you read through this code, there's a lot of math happening here
        /// This is the formula, so I'll try my best to make the code look like everything being plugged into it
        
        //     P [ i(1 + i)^n ]
        //     -----------------       <---- This is all one big fraction or division
        //      (1 + i)^n – 1
        
        let mathematicalRate = interestRate / 100
        
        // P = principal loan amount
        // i = monthly interest rate
        // n = number of months required to repay the loan
        
        let p = principal
        let n = term * 12
        let i = mathematicalRate / 12
        
        /// Solving for the top side first
        
        let topParentheses = (p * pow((i * (1 + i)), n) )
        let bottomParentheses = pow((1 + i), n - 1)
        let result = topParentheses / bottomParentheses
        
        return result
    }
    
    
    var totalCost: Double {
        let n = term * 12
        let result = n * monthlyPayment
        return result
    }
    
    init(term: Double, interestRate: Double, principal: Double, downPayment: Double) {
        self.term = term
        self.interestRate = interestRate
        self.principal = principal
        self.downPayment = downPayment
    }
    
} //End of struct
