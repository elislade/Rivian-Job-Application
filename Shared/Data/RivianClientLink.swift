import Foundation
import CoreBluetooth
import CoreLocation
import Combine

class RivianClientLink {
    
    weak var vehicle: VehicleClient!
    
    var connectedPeriph: Peripheral?
    var services: [Service] = []
    var characteristics: [Characteristic] = []
    var actionChar: Characteristic?
    var locationChar: Characteristic?
    
    private var watch: Set<AnyCancellable> = []
    private var central: CentralManager { CentralManager.shared }
    
    var scannedPeriph: ScannedPeripheral? {
        RivianScanner.shared.peripherals.first
    }
    
    init(_ vehicle: VehicleClient){
        self.vehicle = vehicle
    }
    
    func send(action: Vehicle.Action) {
        guard let act = actionChar else { print("nil action char"); return }
        if act.canSendWriteWithoutResponse {
            act.write(data: action.data, type: .withoutResponse)
        }
    }
    
    func connect() {
        guard let scan = scannedPeriph else { print("no scan available"); return }
        
        central.connect(scan.peripheral.peripheral, options: nil)
        central.$connectedPeripherals.sink(receiveValue: { periphs in
            if let p = periphs.first {
                self.vehicle.isConnected = true
                self.connectedPeriph = p
                self.setupPeripheral()
            } else {
                self.vehicle.isConnected = false
            }
        }).store(in: &watch)
    }
    
    func disconnect() {
        connectedPeriph?.disconnect()
    }
    
    private func setupPeripheral() {
        guard let periph = connectedPeriph else { return }
        
        discoverServices()
        
        periph.$services.sink(receiveValue: { servs in
            self.services = servs
            self.discoverCharacteristics()
        }).store(in: &watch)
    }
    
    private func discoverServices() {
        connectedPeriph?.discoverServices([ .main_id(for: vehicle.model) ])
    }
    
    private func discoverCharacteristics() {
        guard let s = services.first else { return }
        
        let act: CBUUID = .main_action_id(for: vehicle.model)
        let loc: CBUUID = .main_location_id(for: vehicle.model)
        
        s.discoverCharacteristics(withUUIDS: [act, loc])
        s.$characteristics.sink{ chars in
            for c in chars {
                if c.id == loc {
                    self.locationChar = c
                } else if c.id == act {
                    self.actionChar = c
                }
            }
            self.listenToLocationChange()
        }.store(in: &watch)
    }
    
    private func listenToLocationChange() {
        guard let loc = locationChar else { return }
        
        loc.$value.sink { loc in
            self.vehicle.location = CLLocation(loc ?? Data())
        }.store(in: &watch)
    }
}
