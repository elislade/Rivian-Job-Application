import SwiftUI
import MapKit
import CoreLocation

struct LocationCharacteristicView: View {
    
    @ObservedObject var c: Characteristic
    @State private var location: CLLocation?
    
    var body: some View {
        Group {
            if location != nil {
                LocationView(location: location!)
            } else {
                ActivityIndicator()
            }
        }.onReceive(c.$value, perform: {
            if let d = $0 {
                location = CLLocation(d)
            }
        })
    }
}
