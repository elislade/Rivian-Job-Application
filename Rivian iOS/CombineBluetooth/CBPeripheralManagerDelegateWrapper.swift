import Foundation
import CoreBluetooth
import Combine

class CBPeripheralManagerDelegateWrapper: NSObject, CBPeripheralManagerDelegate {
    
    
    // MARK: - Manager
    
    let didUpdateState = PassthroughSubject<CBManagerState, Never>()
    let isReadyToUpdateSubscribers = PassthroughSubject<Void, Never>()
    let didStartAdvertising = PassthroughSubject<Error?, Never>()
    let willRestoreState = PassthroughSubject<[String:Any], Never>()
    let didAddService = PassthroughSubject<(service:CBService, error:Error?), Never>()
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        didUpdateState.send(peripheral.state)
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        isReadyToUpdateSubscribers.send()
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        didStartAdvertising.send(error)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        willRestoreState.send(dict)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        didAddService.send((service, error))
    }
    
    
    // MARK: - Central
    
    let didSubscribeToCharacteristic = PassthroughSubject<(central:CBCentral, char:CBCharacteristic), Never>()
    let didUnsubscribeFromCharacteristic = PassthroughSubject<(central:CBCentral, char:CBCharacteristic), Never>()
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        didSubscribeToCharacteristic.send((central, characteristic))
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        didUnsubscribeFromCharacteristic.send((central, characteristic))
    }
    
    
    // MARK: - ATTRequest
    
    let didRecieveWrite = PassthroughSubject<[CBATTRequest], Never>()
    let didRecieveRead = PassthroughSubject<CBATTRequest, Never>()
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        didRecieveRead.send(request)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        didRecieveWrite.send(requests)
    }
    
    
    // MARK: - L2CAP
    
    let didOpenChannel = PassthroughSubject<(channel: CBL2CAPChannel?, error:Error?), Never>()
    let didPublishL2CAPChannel = PassthroughSubject<(channel: CBL2CAPPSM, error:Error?), Never>()
    let didUnpublishL2CAPChannel = PassthroughSubject<(channel: CBL2CAPPSM, error:Error?), Never>()

    func peripheralManager(_ peripheral: CBPeripheralManager, didOpen channel: CBL2CAPChannel?, error: Error?) {
        didOpenChannel.send((channel, error))
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didPublishL2CAPChannel PSM: CBL2CAPPSM, error: Error?) {
        didPublishL2CAPChannel.send((PSM, error))
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didUnpublishL2CAPChannel PSM: CBL2CAPPSM, error: Error?) {
        didUnpublishL2CAPChannel.send((PSM, error))
    }
}
