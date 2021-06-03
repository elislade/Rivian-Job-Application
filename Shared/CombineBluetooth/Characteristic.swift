import Foundation
import CoreBluetooth
import Combine

class Characteristic: ObservableObject {
    
    let characteristic: CBCharacteristic
    
    weak var service: Service!
    
    var canSendWriteWithoutResponse: Bool {
        service.peripheral.peripheral.canSendWriteWithoutResponse
    }
    
    @Published private(set) var descriptors: [Descriptor] = []
    @Published private(set) var value: Data?
    
    private var watch: Set<AnyCancellable> = []
    private var tempData = Data()
    
    init(_ char: CBCharacteristic, service: Service) {
        self.characteristic = char
        self.service = service
        self.discoverDescriptors()
        self.value = characteristic.value
        
        if characteristic.properties.contains(.notify) {
            self.service.peripheral.peripheral.setNotifyValue(true, for: characteristic)
        }
        
        if characteristic.properties.contains(.read) {
            self.service.peripheral.peripheral.readValue(for: characteristic)
        }
        
        self.service.peripheral.delegate.didDiscoverDescriptorsForCharacteristic
            .filter({ $0.char.uuid == self.characteristic.uuid })
            .sink {
                if let d = $0.char.descriptors {
                    self.descriptors = d.map { Descriptor($0, characteristic: self) }
                }
            }.store(in: &watch)
        
        self.service.peripheral.delegate.didWriteValueForCharacteristic
            .filter({ $0.char.uuid == self.characteristic.uuid })
            .sink {
                print("Did write:", $0.char.value?.debugDescription ?? "")
            }.store(in: &watch)
        
        self.service.peripheral.delegate.didUpdateValueForCharacteristic
            .filter({ $0.char.uuid == self.characteristic.uuid })
            .map({ $0.char.value })
            .sink(receiveValue: didUpdate)
            .store(in: &watch)
    }
    
    func discoverDescriptors() {
        service.peripheral.peripheral.discoverDescriptors(for: characteristic)
    }
    
    func write(data: Data, type: CBCharacteristicWriteType) {
        let size = service.peripheral.peripheral.maximumWriteValueLength(for: type)
        for dataChunk in data.chunked(to: size) {
            service.peripheral.peripheral.writeValue(dataChunk, for: characteristic, type: type)
        }
    }
    
    func cleanup() {
        if characteristic.isNotifying {
            service.peripheral.peripheral.setNotifyValue(false, for: characteristic)
        }
    }
    
    private func didUpdate(_ value: Data?) {
       
        // NOTE: - Data Concatination
        // Hard to distinguish between value updates that
        // are chunked from sendUpdates or just whole data
        // pieces that are from readRequests.
        // For now just send every data piece to characteristic
        // and chunked data will eventually overwrite
        // partial data when concatinated
        
        self.value = value
        
        if let data = value {
            if "EOM".data == data {
                self.value = self.tempData
                self.tempData = Data()
            } else {
                self.tempData.append(data)
            }
        }
    }

}

extension Characteristic: Identifiable {
    var id: CBUUID { characteristic.uuid }
}
