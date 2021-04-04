import Foundation
import CoreBluetooth
import Combine

class Characteristic:ObservableObject {
    let characteristic:CBCharacteristic
    let service:Service
    
    var canSendWriteWithoutResponse:Bool {
        service.peripheral.peripheral.canSendWriteWithoutResponse
    }
    
    @Published var descriptors:[Descriptor] = []
    @Published var value:Data?
    
    init(_ char:CBCharacteristic, service:Service) {
        self.characteristic = char
        self.service = service
        self.discoverDescriptors()
        self.value = characteristic.value
        
        listenToValueUpdate()
        listenToWrite()
        
        if characteristic.properties.contains(.notify) {
            self.service.peripheral.peripheral.setNotifyValue(true, for: characteristic)
        }
        
        if characteristic.properties.contains(.read) {
            self.service.peripheral.peripheral.readValue(for: characteristic)
        }
    }
    
    private var discoverPub:AnyCancellable?
    func discoverDescriptors() {
        service.peripheral.peripheral.discoverDescriptors(for: characteristic)
        
        if discoverPub == nil {
            discoverPub = service.peripheral.delegate.didDiscoverDescriptorsForCharacteristic
                .filter({ $0.char.uuid == self.characteristic.uuid })
                .sink {
                    if let d = $0.char.descriptors {
                        self.descriptors = d.map { Descriptor($0, characteristic:self) }
                    }
                }
        }
    }
    
    func write(data:Data, type:CBCharacteristicWriteType) {
        let size = service.peripheral.peripheral.maximumWriteValueLength(for: type)
        for dataChunk in data.chunked(to: size) {
            service.peripheral.peripheral.writeValue(dataChunk, for: characteristic, type: type)
        }
    }
    
    private var didWritePub:AnyCancellable?
    func listenToWrite() {
        if didWritePub == nil {
            didWritePub = service.peripheral.delegate.didWriteValueForCharacteristic
                .filter({ $0.char.uuid == self.characteristic.uuid })
                .sink {
                    print("Did write:", $0.char.value?.debugDescription ?? "")
                }
        }
    }
    
    func cleanup() {
        if characteristic.isNotifying {
            service.peripheral.peripheral.setNotifyValue(false, for: characteristic)
        }
    }
    
    private var tempData = Data()
    
    private var updateValuePub:AnyCancellable?
    func listenToValueUpdate() {
        if updateValuePub == nil {
            updateValuePub = service.peripheral.delegate.didUpdateValueForCharacteristic
                .filter({ $0.char.uuid == self.characteristic.uuid })
                .sink {
                    
                    // NOTE: - Data Concatination
                    // Hard to distinguish between value updates that
                    // are chunked from sendUpdates or just whole data
                    // pieces that are from readRequests.
                    // For now just send every data piece to characteristic
                    // and chunked data will eventually overwrite
                    // partial data when concatinated
                    
                    self.value = $0.char.value
                    
                    if let data = $0.char.value {
                        if "EOM".data == data {
                            self.value = self.tempData
                            self.tempData = Data()
                        } else {
                            self.tempData.append(data)
                        }
                    }
                }
        }
    }

}

extension Characteristic:Identifiable {
    var id:CBUUID { characteristic.uuid }
}
