import Foundation
import CoreBluetooth
import Combine
import os

class Peripheral: ObservableObject {
    
    weak var manager: CentralManager!
    let peripheral: CBPeripheral
    let delegate = CBPeripheralDelegateWrapper()
    
    @Published private(set) var services: [Service] = []
    @Published var name: String = ""
    @Published var rssi: Int = 0
    
    private var watch: Set<AnyCancellable> = []
    
    init(_ manager: CentralManager, peripheral: CBPeripheral) {
        self.manager = manager
        self.peripheral = peripheral
        self.name = peripheral.name ?? ""
        self.peripheral.delegate = delegate
         
        delegate.didUpdateName
            .assign(to: \.name, on: self)
            .store(in: &watch)
        
        delegate.didDiscoverServices
            .flatMap({ Just($0.0.map { Service($0, peripheral: self) }) })
            .assign(to: \.services, on: self)
            .store(in: &watch)
        
        delegate.didModifyServices.sink { _ in
            self.discoverServices()
        }.store(in: &watch)
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

    func cleanup() {
        guard peripheral.state == .connected else { return }
        for service in services { service.cleanup() }
        disconnect()
    }
    
    func discoverServices(_ serviceUUIDS: [CBUUID]? = nil) {
        peripheral.discoverServices(serviceUUIDS)
    }
}

extension Peripheral: Hashable {
    static func == (lhs: Peripheral, rhs: Peripheral) -> Bool {
        lhs.peripheral == rhs.peripheral
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(peripheral)
    }
}
