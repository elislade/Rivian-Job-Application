import SwiftUI
import MapKit

struct SelectedVehicle: View {
    
    @EnvironmentObject private var locManager: Location
    @ObservedObject var vehicle: VehicleHost
    
    func sendLocation() {
        guard let loc = self.locManager.location else { return }
        vehicle.update(location: loc)
    }

    var body: some View {
        VStack(spacing: 16) {
            ActionsView(actions: vehicle.actions, sendBack: vehicle.send)
            
            if locManager.location != nil {
                MapView(anno: locManager.location!)
                    .id(locManager.location!)
                    .cornerRadius(5)
                    .overlay(Button("Send Location", action: sendLocation).padding(), alignment: .topTrailing)
                    .onAppear {
                        if let loc = locManager.location {
                            vehicle.update(location: loc)
                        }
                    }
            }
        }
        .onAppear(perform: vehicle.setup)
        .padding()
    }
}

struct SelectedVehicle_Previews: PreviewProvider {
    static var previews: some View {
        SelectedVehicle(vehicle: .r1sHost)
            .environmentObject(Location())
            .frame(width: 400, height: 600)
    }
}
