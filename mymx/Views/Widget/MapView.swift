import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var shopCoordinate = CLLocationCoordinate2D(latitude: 30.281439, longitude: 120.095027)
    
    let polygonPoints = [
        CLLocationCoordinate2D(latitude: 30.278341, longitude: 120.048466),
        CLLocationCoordinate2D(latitude: 30.286790, longitude: 120.049753),
        CLLocationCoordinate2D(latitude: 30.300871, longitude: 120.059280),
        CLLocationCoordinate2D(latitude: 30.319674, longitude: 120.101402),
        CLLocationCoordinate2D(latitude: 30.319748, longitude: 120.108891),
        CLLocationCoordinate2D(latitude: 30.313246, longitude: 120.115156),
        CLLocationCoordinate2D(latitude: 30.294943, longitude: 120.139961),
        CLLocationCoordinate2D(latitude: 30.272707, longitude: 120.154467),
        CLLocationCoordinate2D(latitude: 30.269631, longitude: 120.155368),
        CLLocationCoordinate2D(latitude: 30.259438, longitude: 120.120134),
        CLLocationCoordinate2D(latitude: 30.249503, longitude: 120.072842),
        CLLocationCoordinate2D(latitude: 30.278341, longitude: 120.048466)
    ]
    
    var body: some View {
        
        Map{
            Marker("猫与猫寻", systemImage: "gift.fill", coordinate: shopCoordinate)
                .foregroundStyle(.button)
            MapPolygon(coordinates: polygonPoints)
                .foregroundStyle(Color(hex: "00aaff").opacity(0.2))
                .stroke(Color(hex: "00aaff").opacity(0.5), lineWidth: 1)

        }
//        .mapStyle(.hybrid(elevation: .realistic))
        .mapControls {
//            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
    }
}
