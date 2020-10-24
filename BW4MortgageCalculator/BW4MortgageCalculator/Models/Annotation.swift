//
//  HomeAnnotation.swift
//  BW4MortgageCalculator
//
//  Created by Waseem Idelbi on 10/20/20.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    //MARK: - Properties -
    var title: String?
    var coordinate: CLLocationCoordinate2D
    let subtitle: String?
    
    //MARK: - Initializer -
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        
        var possibleTitle = "No Title"
        var possibleSubtitle = "No Subtitle"
        
        if let title = title {
            possibleTitle = title
        }
        if let subtitle = subtitle {
            possibleSubtitle = subtitle
        }
                
        self.title = possibleTitle
        self.subtitle = possibleSubtitle
        self.coordinate = coordinate
    }
    
}
