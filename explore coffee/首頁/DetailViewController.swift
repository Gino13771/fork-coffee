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
    
 
    
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude = 0.0
    
    var longitude = 0.0
    
    var cafeData:CafeInfo?
    
    @IBOutlet weak var cafeName: UILabel!
    
    @IBOutlet weak var cafeAddress: UILabel!
    
    @IBOutlet weak var openTime: UILabel!
    
    //@IBOutlet weak var collect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let cafeData = cafeData{
            
            latitude = Double(cafeData.latitude)!
            longitude = Double(cafeData.longitude)!
            
            
            cafeName.text = cafeData.name
            cafeAddress.text = cafeData.address
            openTime.text = "\(cafeData.open_time)"
            
        }
        
        settingcafeAnnotation()
        
        print(latitude)
        print(longitude)
    }
    @IBAction func navv(_ sender: Any) {
        map()
    }
    
    
    func settingcafeAnnotation() {
        let studioAnnotation = MKPointAnnotation()
        studioAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        studioAnnotation.title = cafeData?.name
        studioAnnotation.subtitle = cafeData?.address
        mapView.setCenter(studioAnnotation.coordinate, animated: true)
        
        mapView.setRegion(MKCoordinateRegion(center: studioAnnotation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
        mapView.addAnnotation(studioAnnotation)
    }
    
    func map(){
        
        if let cafeData = cafeData{
            
            latitude = Double(cafeData.latitude)!
            longitude = Double(cafeData.longitude)!
            
            cafeName.text = cafeData.name
            cafeAddress.text = cafeData.address
            openTime.text = "\(cafeData.open_time)"
            
        }
        
        print(latitude)
        print(longitude)
        
        let targetLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let targetPlacemark = MKPlacemark(coordinate: targetLocation)
        
        let targetItem = MKMapItem(placemark: targetPlacemark)
        
        let userMapItem = MKMapItem.forCurrentLocation()
        
        print(userMapItem)
        let routes = [userMapItem,targetItem]
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
        
        
    }
}

