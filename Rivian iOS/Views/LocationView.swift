import SwiftUI
import MapKit
import CoreLocation

struct LocationView: View {
    let location: CLLocation
    
    @State private var address: String?
    
    var body: some View {
        MapView(anno: location)
            .aspectRatio(1.6, contentMode: .fit)
            .overlay(HStack {
                Text(address ?? "Address").fontWeight(.bold)
                Spacer()
                Text(MKDistanceFormatter().string(fromDistance: location.altitude)).opacity(0.6)
            }.padding().background(Color.black.opacity(0.8)), alignment: .top)
            .cornerRadius(14)
            .onAppear {
                location.address(completion: {
                    self.address = $0
                })
            }
    }
}
