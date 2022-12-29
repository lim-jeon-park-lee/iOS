import GoogleMaps
import SwiftUI
import UIKit
import SwiftyJSON
import Alamofire

class MapViewController: UIViewController,GMSMapViewDelegate {
    
    let map = GMSMapView(frame: .zero)
    var isAnimating: Bool = false
    
    
    override func loadView() {
        super.loadView()
        self.view = map
        map.delegate = self
        
        _ = Timer.scheduledTimer(timeInterval: 2.0,
                                     target: self,
                                     selector: #selector(execute),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func execute() {
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJjb3JkZWxpYTI3M0BrYWthby5jb20iLCJuYW1lIjoi7IS57Iuc6re87Jyh64Ko7Jyk66-8IiwiY3JlYXRlZEF0IjoiMjAyMi0xMi0yOVQxMjozNjozNS4wMDBaIiwiaWF0IjoxNjcyMzMyNDg4LCJleHAiOjE2Nzc1MTY0ODh9.LXVo1xonCFOoJ3TEO05tP_jGQP9yQt3HKxrD_-c6ll0";
        
        let headers:HTTPHeaders = [
           "Authorization" : String(format: "Bearer: @%", token)
        ]
        AF.request("http://158.247.236.61:3000/status",headers: headers).responseJSON(completionHandler: { json in
            print(json)
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let swiftUIView = FightView()
        let viewCtrl = UIHostingController(rootView: swiftUIView)
        
        self.present(viewCtrl, animated: true)
        return true
    }
}

