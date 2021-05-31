import SwiftUI
import CoreBluetooth

struct SelectedVehicle: View {
    
    @EnvironmentObject private var btManager: PeripheralManager
    @EnvironmentObject private var locManager: Location
    @ObservedObject var vehicle: Vehicle

    func addServices() {
        let s = CBMutableService.main(for: vehicle)
        s.characteristics = [
            CBMutableCharacteristic.main_location(for: vehicle),
            CBMutableCharacteristic.main_action(for: vehicle)
        ]
        
        btManager.add(s)
        vehicle.isSetup = true
    }
    
    func removeServices() {
        btManager.manager.remove(.main(for: vehicle))
        vehicle.isSetup = false
    }
    
    func sendLocation() {
        guard let data = self.locManager.location?.data else { return }
        btManager.send(data, to: .main_location(for: vehicle))
    }
    
    func advertise() {
        btManager.stopAdvertising()
        btManager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [CBUUID.main_id(for: vehicle)] ,
            CBAdvertisementDataLocalNameKey: "Rivian " + vehicle.name
        ])
        vehicle.isAdvert = true
    }
    
    func stopAdvertise() {
        self.btManager.stopAdvertising()
        self.vehicle.isAdvert = false
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if locManager.location != nil {
                MapView(anno: locManager.location!)
                    .cornerRadius(5)
                    .overlay(Button("Send Location", action: sendLocation).padding(5), alignment: .topTrailing)
            }
            
            ActionsView(vehicle: vehicle, actions: vehicle.actions)
        }
        .navigationTitle(vehicle.name)
        .toolbar(content: {
            if vehicle.isAdvert {
                Button("Stop Advert", action: stopAdvertise)
            } else {
                Button("Advertise", action: advertise)
            }
            
            if vehicle.isSetup {
                Button("Remove Services", action: removeServices)
            } else {
                Button("Add Services", action: addServices)
            }
        })
        .onAppear {
            self.btManager.reqValue = { char_id in
                guard
                    char_id == .main_location_id(for: self.vehicle),
                    let loc = self.locManager.location
                else { return nil }
                return loc.data
            }
        }
        .onReceive(
            btManager.recievedWrite.filter({$0.char.uuid == .main_action_id(for: self.vehicle)}),
        perform: {
            if let action = Vehicle.Action($0.data) {
                self.vehicle.actions.append(action)
                AudioManager.shared?.playAudio(for: action)
            }
        })
    }
}

struct SelectedVehicle_Previews: PreviewProvider {
    static var previews: some View {
        SelectedVehicle(vehicle: .r1s)
            .environmentObject(PeripheralManager())
            .environmentObject(Location())
            .frame(width: 400, height: 600)
    }
}
