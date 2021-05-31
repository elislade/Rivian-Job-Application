import Foundation
import CoreBluetooth
import Combine
import os

class Peripheral: ObservableObject {
    
    unowned let manager: CentralManager
    let peripheral: CBPeripheral
    let delegate = CBPeripheralDelegateWrapper()
    
    @Published private(set) var services: [Service] = []
    @Published var name: String = ""
    @Published var rssi: Int = 0
    
    init(_ manager:CentralManager, peripheral: CBPeripheral) {
        self.manager = manager
        self.peripheral = peripheral
        self.name = peripheral.name ?? ""
        self.peripheral.delegate = delegate
        listenToName()
    }
    
    func discover() {
        if peripheral.state == .connected {
            self.discoverServices()
        }
    }
    
    func disconnect() {
        manager.disconnect(peripheral)
        cleanup()
    }
    
    var nameChangePub:AnyCancellable?
    func listenToName(){
        nameChangePub = delegate.didUpdateName.assign(to: \.name, on: self)
    }

    func cleanup() {
        guard case .connected = peripheral.state else { return }
        
        for service in services { service.cleanup() }
        disconnect()
    }
    
    var servicesPub:AnyCancellable?
    var modServicesPub:AnyCancellable?
    func discoverServices(_ serviceUUIDS: [CBUUID]? = nil){
        peripheral.discoverServices(serviceUUIDS)
        if servicesPub == nil {
            servicesPub = delegate.didDiscoverServices.flatMap({
                Just($0.0.map { Service($0, peripheral: self) })
            }).assign(to: \.services, on: self)
        }
        
        if servicesPub == nil {
            modServicesPub = delegate.didModifyServices.sink { _ in
                self.discoverServices()
            }
        }
    }
}

extension Peripheral: Hashable {
    static func == (lhs: Peripheral, rhs: Peripheral) -> Bool {
        lhs.peripheral == rhs.peripheral
    }
    
    func hash(into hasher: inout Hasher) {
        peripheral.hash(into: &hasher)
    }
}
