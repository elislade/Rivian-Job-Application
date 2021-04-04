import Foundation
import CoreBluetooth
import Combine

class Service: ObservableObject {
    let service:CBService
    let peripheral:Peripheral
    
    @Published var includedServices:[Service] = []
    @Published var characteristics:[Characteristic] = []
    
    init(_ service: CBService, peripheral: Peripheral) {
        self.service = service
        self.peripheral = peripheral
        self.discoverCharacteristics()
        self.discoverIncServices()
    }
    
    func cleanup() {
        for c in characteristics { c.cleanup() }
    }
    
    var incServicesPub:AnyCancellable?
    func discoverIncServices(_ serviceUUIDS: [CBUUID]? = nil){
        peripheral.peripheral.discoverIncludedServices(serviceUUIDS, for: service)
        if incServicesPub == nil {
            incServicesPub = peripheral.delegate.didDiscoverIncludedServices
                .filter({ $0.service.uuid == self.service.uuid })
                .map({ $0.service.includedServices ?? [] })
                .map({ $0.map { Service($0, peripheral: self.peripheral) } })
                .assign(to: \.includedServices, on: self)
        }
    }
    
    var discoverPub:AnyCancellable?
    func discoverCharacteristics(withUUIDS: [CBUUID]? = nil) {
        peripheral.peripheral.discoverCharacteristics(withUUIDS, for: service)
        if discoverPub == nil {
            discoverPub = peripheral.delegate.didDiscoverCharateristicForService
                .filter({ $0.service.uuid == self.service.uuid })
                .sink {
                    if let c = $0.service.characteristics {
                        self.characteristics = c.map {
                            Characteristic($0, service: self)
                        }
                    }
                }
        }
    }
}

extension Service:Identifiable {}
