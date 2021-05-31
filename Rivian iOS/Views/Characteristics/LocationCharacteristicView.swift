import SwiftUI
import MapKit
import CoreLocation

struct LocationCharacteristicView: View {
    
    @ObservedObject var c: Characteristic
    @State private var location: CLLocation?
    
    var body: some View {
        ZStack {
            Color.clear
            
            if location != nil {
                LocationView(location: location!)
            } else {
                ActivityIndicator()
            }
        }
        .aspectRatio(1.6, contentMode: .fit)
        .onReceive(c.$value, perform: {
            if let d = $0 {
                location = CLLocation(d)
            }
        })
    }
}
