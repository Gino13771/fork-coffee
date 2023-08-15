//
//  DetailViewController.swift
//  explore coffee
//
//  Created by 凱聿蔡凱聿 on 2023/6/1.
//

import Foundation
import MapKit
import RealmSwift


class DetailViewController: UIViewController {
    static func make(dataModel: CafeInfo) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: DetailViewController = storyboard.instantiateViewController(withIdentifier: "mapIdentity") as! DetailViewController
        
        vc.cafeData = dataModel
        
        return vc
    }
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cafeName: UILabel!
    @IBOutlet weak var cafeAddress: UILabel!
    @IBOutlet weak var openTime: UILabel!
    
    var latitude = 0.0
    var longitude = 0.0
    var cafeData: CafeInfo?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        settingCafeAnnotation()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        if let cafeData = cafeData {
            cafeName.text = cafeData.name
            cafeAddress.text = cafeData.address
            openTime.text = cafeData.open_time
            
            guard let latitudeString = cafeData.latitude, let longitudeString = cafeData.longitude else {
                print("latitude 或 longitude 為 nil。")
                return
            }
            
            guard let latitudeValue = Double(latitudeString), let longitudeValue = Double(longitudeString) else {
                print("無法轉換 latitude 或 longitude 為 Double。")
                return
            }
            
            latitude = latitudeValue
            longitude = longitudeValue
        } else {
            print("cafeData 為 nil。")
        }
    }
    
    // MARK: - Map Annotation Setup
    private func settingCafeAnnotation() {
        guard let mapView = mapView, let cafeData = cafeData else {
            print("mapView 或 cafeData 為 nil。")
            return
        }
        
        guard let latitudeString = cafeData.latitude, let longitudeString = cafeData.longitude else {
            print("latitude 或 longitude 為 nil。")
            return
        }
        
        guard let latitudeValue = Double(latitudeString), let longitudeValue = Double(longitudeString) else {
            print("無法轉換 latitude 或 longitude 為 Double。")
            return
        }
        
        latitude = latitudeValue
        longitude = longitudeValue
        
        let studioAnnotation = MKPointAnnotation()
        studioAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        studioAnnotation.title = cafeData.name
        studioAnnotation.subtitle = cafeData.address
        mapView.setCenter(studioAnnotation.coordinate, animated: true)
        mapView.setRegion(MKCoordinateRegion(center: studioAnnotation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
        mapView.addAnnotation(studioAnnotation)
    }
    
    // MARK: - Navigation
    @IBAction func navigateToCafe(_ sender: Any) {
        let targetLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let targetPlacemark = MKPlacemark(coordinate: targetLocation)
        
        let targetItem = MKMapItem(placemark: targetPlacemark)
        
        
        let userMapItem = MKMapItem.forCurrentLocation()
        
        let routes = [userMapItem, targetItem]
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
