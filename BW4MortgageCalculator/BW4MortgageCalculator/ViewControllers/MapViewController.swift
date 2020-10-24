//
//  MapViewController.swift
//  BW4MortgageCalculator
//
//  Created by Clayton Watkins on 10/14/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - Properties -
    var userAnnotation: MKAnnotation? {
        didSet {
            showUserLocation()
        }
    }
    var fetchingAlert: UIAlertController {
        let title = "Fetching..."
        let message = "Please wait while we fetch your location"
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    var fetchFailAlert: UIAlertController {
        let title = "Could not fetch location"
        let message = "Sorry, but it seems that we were unable to fetch your location. Please check your internet connection and location services"
        let action = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        return alert
    }
    var fetchingAlertIsPresent = false
    
    var houseAnnotations: [MKAnnotation] = [
        Annotation(title: "7542 Rainbow Dr", subtitle: "Single Family Home", coordinate: CLLocationCoordinate2D(latitude: 37.300522, longitude: -122.037075)),
        Annotation(title: "20567 Cedarbrook Ter,", subtitle: "Townhome", coordinate: CLLocationCoordinate2D(latitude: 37.339490, longitude: -122.033656)),
        Annotation(title: "8055 Park Villa Cir", subtitle: "Townhome", coordinate: CLLocationCoordinate2D(latitude: 37.315545, longitude: -122.050798)),
        Annotation(title: "11387 Lindy Pl", subtitle: "Single Family Home", coordinate: CLLocationCoordinate2D(latitude: 37.302715, longitude: -122.059076)),
        Annotation(title: "20749 Celeste Cir", subtitle: "Condo", coordinate: CLLocationCoordinate2D(latitude: 37.335470, longitude: -122.036387)),
    ]

    // MARK: - IBOutlets -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selfLocationButton: UIButton!
    
    // MARK: - Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchBar.delegate = self
        configureLocationButton()
    }
    
    func fetchUserLocation() {
        
        if userAnnotation != nil {
            showUserLocation()
            return
        }
        
        present(fetchingAlert, animated: true)
        fetchingAlertIsPresent = true
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    func configureLocationButton() {
        selfLocationButton.layer.cornerRadius = 10
        selfLocationButton.layer.borderWidth = 0.5
        selfLocationButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    func showUserLocation() {
        if let userAnnotation = userAnnotation {
            mapView.showAnnotations([userAnnotation], animated: true)
        } else {
            print("Could not add or show user's location annotation, location not found!")
        }
    }
    
    //MARK: - IBActions -
    @IBAction func selfLocationButtonTapped(_ sender: UIButton) {
        fetchUserLocation()
    }
    
} //End of class

//MARK: - Extensions -

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") {
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "annotation")
            return annotationView
        }
        else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "annotation")
            return annotationView
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! Annotation
        let coordinate = annotation.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = annotation.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let userAnnotation = Annotation(title: "You :)", subtitle: "This is your location", coordinate: coordinate)
        self.userAnnotation = userAnnotation
        
        DispatchQueue.main.async {
            self.fetchingAlertIsPresent = false
            self.dismiss(animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if self.fetchingAlertIsPresent == true {
            
            DispatchQueue.main.async {
                self.fetchingAlertIsPresent = false
                self.dismiss(animated: true)
                self.present(self.fetchFailAlert, animated: true)
            }
            
        } else if fetchingAlertIsPresent == false {
            
            self.present(self.fetchFailAlert, animated: true)
            
        }
    }
    
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if userAnnotation != nil {
            houseAnnotations.append(userAnnotation!)
        }
        
        mapView.showAnnotations(houseAnnotations, animated: true)
        searchBar.resignFirstResponder()
    }
    
}
