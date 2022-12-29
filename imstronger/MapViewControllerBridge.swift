
import GoogleMaps
import SwiftUI

struct MapViewControllerBridge: UIViewControllerRepresentable {

    
    @Binding var markers: [GMSMarker]
    @Binding var selectedMarker: GMSMarker?
    @Binding var currentLocation: CLLocationCoordinate2D?
    @Binding var selectedCircle: GMSCircle?
    
    func makeUIViewController(context: Context) -> MapViewController {
        // Replace this line
        return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        // Update the map for each marker
        markers.forEach { $0.map = uiViewController.map }
        selectedMarker?.map = uiViewController.map
        selectedCircle?.map = uiViewController.map
        animateToSelectedMarker(viewController: uiViewController)
    }
    
    var onAnimationEnded: () -> ()
    
    private func animateToSelectedMarker(viewController: MapViewController) {
        guard let selectedMarker = selectedMarker else {
            return
        }
        
        let map = viewController.map
        if map.selectedMarker != selectedMarker {
            map.selectedMarker = selectedMarker
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                map.animate(toZoom: kGMSMinZoomLevel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    map.animate(with: GMSCameraUpdate.setTarget(selectedMarker.position))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        map.animate(toZoom: 16)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            // Invoke onAnimationEnded() once the animation sequence completes
                            onAnimationEnded()
                        })
                    })
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(currentLocation: $currentLocation)
    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        @Binding var currentLocation: CLLocationCoordinate2D?
        var locationManager: CLLocationManager!

        init(currentLocation: Binding<CLLocationCoordinate2D?>) {
            self._currentLocation = currentLocation
            super.init()
            

            locationManager = CLLocationManager()
            locationManager.delegate = self
            //위치추적권한요청 when in foreground
            self.locationManager.requestWhenInUseAuthorization()
            //베터리에 맞게 권장되는 최적의 정확도
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            currentLocation = locValue
        }
    }
    
}
