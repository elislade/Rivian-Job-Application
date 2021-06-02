import SwiftUI
import CoreBluetooth

struct SelectedVehicle: View {
    
    @EnvironmentObject private var locManager: Location
    @ObservedObject var vehicle: VehicleHost
    
    func sendLocation() {
        guard let loc = self.locManager.location else { return }
        vehicle.update(location: loc)
    }
    
    var header: some View {
        Group {
            if vehicle.isSetup {
                Button("Teardown", action: vehicle.teardown)
            } else {
                Button("Setup", action: vehicle.setup)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(vehicle.name).font(.title.bold())
                Spacer()
                header
            }.padding([.horizontal, .top])
            
            if locManager.location != nil {
                MapView(anno: locManager.location!)
                    .cornerRadius(5)
                    .overlay(Button("Send Location", action: sendLocation).padding(), alignment: .topTrailing)
                    .padding()
            }
            
            ActionsView(vehicle: vehicle, actions: vehicle.actions)
        }
    }
}

struct SelectedVehicle_Previews: PreviewProvider {
    static var previews: some View {
        SelectedVehicle(vehicle: .r1sHost)
            .environmentObject(Location())
            .frame(width: 400, height: 600)
    }
}
