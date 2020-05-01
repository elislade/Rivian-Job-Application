import SwiftUI
import MapKit
import CoreLocation

struct LocationCharacteristicView: View {
    @ObservedObject var c:Characteristic
    @State var value:CLLocation?
    @State var address = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "map.fill")
                Text("Location").fontWeight(.semibold)
                Spacer()
                Text(address)
            }
            
            if value != nil {
                Text("Altitude: \(MKDistanceFormatter().string(fromDistance: value!.altitude))")
                MapView(anno: value!)
                    .aspectRatio(1.5, contentMode: .fill)
                    .cornerRadius(5)
            }
        }.onReceive(c.$value, perform: {
            if let d = $0 {
                if let l = CLLocation(d) {
                    self.value = l
                    l.address(binding: self.$address)
                }
            }
        })
    }
}
