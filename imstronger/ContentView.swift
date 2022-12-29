

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
                MapContainerView(zoomInCenter: $zoomInCenter, markers: $markers, selectedMarker: $selectedMarker, currentLocation: $currentLocation, selectedCircle: $currentCircle)
                Button(action: {
                    guard let loc = currentLocation else {return}
                    print(loc)
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
                
                // Cities List
                //                CitiesList(markers: $markers) { (marker) in
                //                    guard self.selectedMarker != marker else { return }
                //                    self.selectedMarker = marker
                //                    self.zoomInCenter = false
                //                    self.expandList = false
                //                }  handleAction: {
                //                    self.expandList.toggle()
                //                }.background(Color.white)
                //                    .clipShape(RoundedRectangle(cornerRadius: 10))
                //                    .offset(
                //                        x: 0,
                //                        y: geometry.size.height - (expandList ? scrollViewHeight + 150 : scrollViewHeight)
                //                    )
                //                    .offset(x: 0, y: self.yDragTranslation)
                //                    .animation(.spring())
                //                    .gesture(
                //                        DragGesture().onChanged { value in
                //                            self.yDragTranslation = value.translation.height
                //                        }.onEnded { value in
                //                            self.expandList = (value.translation.height < -240)
                //                            self.yDragTranslation = 0
                //                        }
                //                    )
                //                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                
            }
        }
    }
}

struct CitiesList: View {
    
    @Binding var markers: [GMSMarker]
    var buttonAction: (GMSMarker) -> Void
    var handleAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                
                // List Handle
                HStack(alignment: .center) {
                    Rectangle()
                        .frame(width: 25, height: 4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(10)
                        .opacity(0.25)
                        .padding(.vertical, 8)
                }
                .frame(width: geometry.size.width, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    handleAction()
                }
                
                // List of Cities
                List {
                    ForEach(0..<self.markers.count) { id in
                        let marker = self.markers[id]
                        Button(action: {
                            buttonAction(marker)
                        }) {
                            Text(marker.title ?? "")
                        }
                    }
                }.frame(maxWidth: .infinity)
            }
        }
    }
}

struct MapContainerView: View {
    
    @Binding var zoomInCenter: Bool
    @Binding var markers: [GMSMarker]
    @Binding var selectedMarker: GMSMarker?
    @Binding var currentLocation: CLLocationCoordinate2D!
    @Binding var selectedCircle: GMSCircle?
    
    var body: some View {
        GeometryReader { geometry in
            let diameter = zoomInCenter ? geometry.size.width : (geometry.size.height * 2)
            MapViewControllerBridge(markers: $markers,selectedMarker: $selectedMarker, currentLocation: $currentLocation, selectedCircle: $selectedCircle,onAnimationEnded: {
                self.zoomInCenter = true;
            })
            
            .animation(.easeIn)
            .background(Color(red: 254.0/255.0, green: 1, blue: 220.0/255.0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

