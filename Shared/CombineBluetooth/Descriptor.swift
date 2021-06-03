import Foundation
import CoreBluetooth
import Combine

class Descriptor: ObservableObject {
    
    let descriptor: CBDescriptor
    weak var characteristic: Characteristic!
    
    @Published private(set) var value: Any?
    
    private var watch: Set<AnyCancellable> = []
    
    init(_ d: CBDescriptor, characteristic: Characteristic) {
        self.descriptor = d
        self.characteristic = characteristic
        
        self.characteristic.service.peripheral.delegate.didUpdateValueForDescriptor
            .filter({ $0.0.uuid == self.descriptor.uuid })
            .sink {
                self.value = $0.0.value
            }.store(in: &watch)
        
        self.characteristic.service.peripheral.delegate.didWriteValueForDescriptor
            .filter({ $0.0.uuid == self.descriptor.uuid })
            .sink { self.value = $0.0.value }
            .store(in: &watch)
    }
    
    func write(_ data: Data) {
        characteristic.service.peripheral.peripheral.writeValue(data, for: descriptor)
    }
}

extension Descriptor: Identifiable {}
