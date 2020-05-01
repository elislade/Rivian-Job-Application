import Foundation
import CoreBluetooth
import Combine

class Descriptor:ObservableObject {
    
    let descriptor:CBDescriptor
    let characteristic:Characteristic
    
    @Published var value:Any?
    
    init(_ d:CBDescriptor, characteristic:Characteristic) {
        self.descriptor = d
        self.characteristic = characteristic
        listenToValueUpdate()
    }
    
    private var updateDataPub:AnyCancellable?
    func listenToValueUpdate() {
        if updateDataPub == nil {
            updateDataPub = characteristic.service.peripheral.delegate.didUpdateValueForDescriptor
                .filter({ $0.0.uuid == self.descriptor.uuid })
                .sink {
                    self.value = $0.0.value
                }
        }
    }
    
    private var writeDataPub:AnyCancellable?
    func write(_ data: Data) {
        characteristic.service.peripheral.peripheral.writeValue(data, for: descriptor)
        if writeDataPub == nil {
            writeDataPub = characteristic.service.peripheral.delegate.didWriteValueForDescriptor
                .filter({ $0.0.uuid == self.descriptor.uuid })
                .sink { self.value = $0.0.value }
        }
    }
}

extension Descriptor:Identifiable {}
