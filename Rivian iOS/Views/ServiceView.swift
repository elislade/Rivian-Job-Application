import SwiftUI
import CoreBluetooth
import CoreLocation

struct ServiceView: View {
    
    @ObservedObject var service: Service
    
    func discoverCharacteristics() {
        service.discoverCharacteristics(withUUIDS:
            [.r1t_main_location_id, .r1t_main_action_id]
        )
    }
    
    var body: some View {
        VStack(spacing: 16){
            ForEach(service.characteristics) {
                CharacteristicView(c: $0)
            }
        }
        .padding()
        .background(LinearGradient.riv_blue.drawingGroup())
        .colorScheme(.dark)
        .onAppear(perform: discoverCharacteristics)
    }
}
