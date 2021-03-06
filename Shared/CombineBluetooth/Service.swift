import Foundation
import CoreBluetooth
import Combine

class Service: ObservableObject {
    
    let service: CBService
    weak var peripheral: Peripheral!
    
    @Published private(set) var includedServices: [Service] = []
    @Published private(set) var characteristics: [Characteristic] = []
    
    private var watch: Set<AnyCancellable> = []
    
    init(_ service: CBService, peripheral: Peripheral) {
        self.service = service
        self.peripheral = peripheral
        self.discoverCharacteristics()
        self.discoverIncServices()
        
        self.peripheral.delegate.didDiscoverIncludedServices
            .filter({ $0.service.uuid == self.service.uuid })
            .map({ $0.service.includedServices ?? [] })
            .map({ $0.map { Service($0, peripheral: self.peripheral) } })
            .assign(to: \.includedServices, on: self)
            .store(in: &watch)
        
        self.peripheral.delegate.didDiscoverCharateristicForService
            .filter({ $0.service.uuid == self.service.uuid })
            .sink {
                if let c = $0.service.characteristics {
                    self.characteristics = c.map {
                        Characteristic($0, service: self)
                    }
                }
            }.store(in: &watch)
    }
    
    func cleanup() {
        for c in characteristics { c.cleanup() }
    }
    
    func discoverIncServices(_ serviceUUIDS: [CBUUID]? = nil) {
        peripheral.peripheral.discoverIncludedServices(serviceUUIDS, for: service)
    }
    
    func discoverCharacteristics(withUUIDS: [CBUUID]? = nil) {
        peripheral.peripheral.discoverCharacteristics(withUUIDS, for: service)
    }
}

extension Service: Identifiable {}
