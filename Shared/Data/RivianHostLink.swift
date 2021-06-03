import Foundation
import CoreBluetooth
import CoreLocation
import Combine

class RivianHostLink {
    
    weak var vehicle: VehicleHost!
    
    private var watch: Set<AnyCancellable> = []
    private var manager: PeripheralManager { PeripheralManager.shared }
    
    init(_ vehicle: VehicleHost){
        self.vehicle = vehicle
        self.listenForActions()
        self.manager.reqValue = { char_id in
            guard
                char_id == .main_location_id(for: vehicle.model),
                let loc = self.vehicle.location
            else { return nil }
            
            return loc.data
        }
        
        self.manager.$centrals
            .sink{ c in
                self.vehicle.isConnected = c.count > 0
                
                if let loc = vehicle.location {
                    self.manager.send(loc.data, to: .main_location(for: vehicle.model))
                }
            }.store(in: &watch)
    }
    
    func setup() {
        addServices()
        advertise(vehicle)
        vehicle.isSetup = true
    }
    
    func teardown() {
        removeServices()
        stopAdvertise()
        vehicle.isSetup = false
    }
    
    func send(_ action: Vehicle.Action) {
        manager.send(action.data, to: .main_action(for: vehicle.model))
    }
    
    func update(location: CLLocation) {
        manager.send(location.data, to: .main_location(for: vehicle.model))
    }
    
    private func advertise(_ vehicle: Vehicle) {
        manager.stopAdvertising()
        manager.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [CBUUID.main_id(for: vehicle.model)] ,
            CBAdvertisementDataLocalNameKey: "Rivian " + vehicle.model.rawValue
        ])
    }
    
    private func stopAdvertise() {
        manager.stopAdvertising()
    }
    
    private func addServices() {
        let s = CBMutableService.main(for: vehicle.model)
        s.characteristics = [
            CBMutableCharacteristic.main_location(for: vehicle.model),
            CBMutableCharacteristic.main_action(for: vehicle.model)
        ]
        
        manager.add(s)
    }
    
    private func removeServices() {
        manager.manager.remove(.main(for: vehicle.model))
    }
    
    private func listenForActions() {
        manager.recievedWrite
            .filter({$0.char.uuid == .main_action_id(for: self.vehicle.model)})
            .sink { act in
                if let action = Vehicle.Action(act.data) {
                    self.vehicle.actions.append(action)
                    AudioManager.shared?.playAudio(for: action)
                }
            }.store(in: &watch)
    }
}
