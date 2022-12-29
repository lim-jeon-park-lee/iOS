

import GoogleMaps
import SwiftUI

struct ContentView: View {
    static let cities = [
        City(name: "유저1", coordinate: CLLocationCoordinate2D(latitude: 37.52157247392546, longitude: 126.88639885527422)),
        City(name: "유저2", coordinate: CLLocationCoordinate2D(latitude: 37.52056247092546, longitude: 126.88738885327422)),
        City(name: "유저3", coordinate: CLLocationCoordinate2D(latitude: 37.51955247592546, longitude: 126.88836885127422)),
    ]
    
    /// State for markers displayed on the map for each city in `cities`
    @State var markers: [GMSMarker] = cities.map {
        let marker = GMSMarker(position: $0.coordinate)
        marker.title = $0.name
        marker.icon = UIImage(systemName: "figure.cooldown")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large))
            .withTintColor(.red, renderingMode: .alwaysOriginal)
        return marker
    }
    
    @State var zoomInCenter: Bool = false
    @State var expandList: Bool = false
    @State var selectedMarker: GMSMarker?
    @State var currentCircle: GMSCircle?
    @State var yDragTranslation: CGFloat = 0
    @State var currentLocation: CLLocationCoordinate2D!
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .top) {
                
                // Map - TODO add the map here
                MapViewControllerBridge(markers: $markers,selectedMarker: $selectedMarker, currentLocation: $currentLocation, selectedCircle: $currentCircle,onAnimationEnded: {
                    self.zoomInCenter = true;
                })
                
                Button(action: {
                    guard let loc = currentLocation else {return}
//                    print(loc)
                    let marker = GMSMarker(position: loc)
                    marker.title = "나의 위치"
                    
                    marker.icon = UIImage(systemName: "figure.boxing")?
                        .withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large))
                        .withTintColor(.red, renderingMode: .alwaysOriginal)
                    
                    
                    let circle = GMSCircle(position: loc, radius: 1000)
                    circle.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.1)
                    circle.strokeColor = .gray
                    circle.strokeWidth = 5
                    
                    self.currentCircle = circle
                    self.selectedMarker = marker
                }) {
                    Image(systemName: "plus.circle")
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                }
                .offset(x:geometry.size.width/2 - 36, y:geometry.size.height - 64)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

