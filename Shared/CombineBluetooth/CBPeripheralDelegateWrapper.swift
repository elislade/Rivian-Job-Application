import Foundation
import CoreBluetooth
import Combine

class CBPeripheralDelegateWrapper: NSObject, CBPeripheralDelegate {

    
    // MARK: - Peripheral
    
    let didUpdateName = PassthroughSubject<String, Never>()
    let isReadyToWriteWithoutResponse = PassthroughSubject<Void, Never>()
    let didDiscoverServices = PassthroughSubject<(services:[CBService], error:Error?), Never>()
    let didReadRSSI = PassthroughSubject<(rssi: NSNumber, error:Error?), Never>()
    let didOpenChannel = PassthroughSubject<(channel: CBL2CAPChannel?, error:Error?), Never>()
    let didModifyServices = PassthroughSubject<[CBService], Never>()

    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        didUpdateName.send(peripheral.name ?? "")
    }
    
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        isReadyToWriteWithoutResponse.send()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        didDiscoverServices.send((peripheral.services ?? [], error))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        didReadRSSI.send((RSSI, error))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didOpen channel: CBL2CAPChannel?, error: Error?) {
        didOpenChannel.send((channel, error))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        didModifyServices.send(invalidatedServices)
    }
    
    
    // MARK: - Services
    
    let didDiscoverCharateristicForService = PassthroughSubject<(service:CBService, error:Error?), Never>()
    let didDiscoverIncludedServices = PassthroughSubject<(service:CBService, error:Error?), Never>()
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        didDiscoverCharateristicForService.send((service, error))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        didDiscoverIncludedServices.send((service, error))
    }
    
    
    // MARK: - Characteristics
    
    let didWriteValueForCharacteristic = PassthroughSubject<(char:CBCharacteristic, error:Error?), Never>()
    let didUpdateValueForCharacteristic = PassthroughSubject<(char:CBCharacteristic, error:Error?), Never>()
    let didDiscoverDescriptorsForCharacteristic = PassthroughSubject<(char:CBCharacteristic, error:Error?), Never>()
    let didUpdateNotificationStateForCharacteristic = PassthroughSubject<(char:CBCharacteristic, error:Error?), Never>()
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        didWriteValueForCharacteristic.send((characteristic, error))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
         didUpdateValueForCharacteristic.send((characteristic, error))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        didDiscoverDescriptorsForCharacteristic.send((characteristic, error))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        didUpdateNotificationStateForCharacteristic.send((characteristic, error))
    }
    
    
    // MARK: - Descriptors
    
    let didWriteValueForDescriptor = PassthroughSubject<(desc:CBDescriptor, error:Error?), Never>()
    let didUpdateValueForDescriptor = PassthroughSubject<(desc:CBDescriptor, error:Error?), Never>()
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        didWriteValueForDescriptor.send((descriptor, error))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        didUpdateValueForDescriptor.send((descriptor, error))
    }
}
