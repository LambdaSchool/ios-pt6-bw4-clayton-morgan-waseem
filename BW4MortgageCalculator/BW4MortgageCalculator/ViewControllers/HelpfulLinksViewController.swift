//
//  HelpfulLinksViewController.swift
//  BW4MortgageCalculator
//
//  Created by Waseem Idelbi on 10/16/20.
//

import UIKit
import SafariServices

class HelpfulLinksViewController: UIViewController {

    //MARK: - Properties -
    
    // This url is for an article, it's a First-Time Homebuyer's Guide
    let buyerGuideURL = URL(string: "https://www.investopedia.com/updates/first-time-home-buyer/")!
    // This url is for a Quiz: Am I Ready To Buy A House?
    let quizURL = URL(string: "https://www.sofi.com/learn/content/should-you-buy-or-rent-a-home-quiz/")!
    // This url is for a YouTube video: 10 Cheapest States to Buy a Home in America
    let videoURL = URL(string: "https://www.youtube.com/watch?v=h2kHXlj2PXU&ab_channel=WorldAccordingToBriggs")!
    // This url is for .....
    let loansAndProgramsURL = URL(string: "https://www.nerdwallet.com/article/mortgages/programs-help-first-time-homebuyers")!
    // This url is for .....
    let buyerKnowledgeURL = URL(string: "https://porch.com/resource/first-time-homebuyers-quiz")!
    // This url is for .....
    let daveRamseyVideoURL = URL(string: "https://www.youtube.com/watch?v=d7tshuaQynA&ab_channel=TheDaveRamseyShow")!
    
    //MARK: - IBOutlets -
    @IBOutlet weak var buyerGuideButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var loansAndProgramsButton: UIButton!
    @IBOutlet weak var buyerKnowledgeButton: UIButton!
    @IBOutlet weak var daveRamseyVideoButton: UIButton!
    
    //MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        buyerGuideButton.layer.cornerRadius = 15
        quizButton.layer.cornerRadius = 15
        videoButton.layer.cornerRadius = 15
        loansAndProgramsButton.layer.cornerRadius = 15
        buyerKnowledgeButton.layer.cornerRadius = 15
        daveRamseyVideoButton.layer.cornerRadius = 15
    }
    
    //MARK: - IBActions -

    @IBAction func guideButtonTapped(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: buyerGuideURL)
        present(safariVC, animated: true)
    }
    
    @IBAction func quizButtonTapped(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: quizURL)
        present(safariVC, animated: true)
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: videoURL)
        present(safariVC, animated: true)
    }
    
    @IBAction func loansAndProgramsButtonTapped(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: loansAndProgramsURL)
        present(safariVC, animated: true)
    }
    
    @IBAction func buyerKnowledgeButtonTapped(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: buyerKnowledgeURL)
        present(safariVC, animated: true)
    }
    
    @IBAction func daveRamseyVideoButtonTapped(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: daveRamseyVideoURL)
        present(safariVC, animated: true)
    }
    
}
