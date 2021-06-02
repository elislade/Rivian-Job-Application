import Foundation
import CoreBluetooth
import Combine

class CBCentralManagerDelegateWrapper: NSObject, CBCentralManagerDelegate {
    
    
    // MARK: - Manager
    
    let didUpdateState = PassthroughSubject<CBManagerState, Never>()
    let willRestoreState = PassthroughSubject<[String: Any], Never>()
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        didUpdateState.send(central.state)
    }
    
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        willRestoreState.send(dict)
//    }
    
    
    // MARK: - Peripheral
    
    let didConnectPeripheral = PassthroughSubject<CBPeripheral, Never>()
    let didFailToConnectPeripheral = PassthroughSubject<(CBPeripheral, Error?), Never>()
    let didDisconnectPeripheral = PassthroughSubject<(CBPeripheral, Error?), Never>()
    let didDiscoverPeripheral = PassthroughSubject<(peripheral: CBPeripheral, advert: [String: Any], rssi: NSNumber), Never>()
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
       didConnectPeripheral.send(peripheral)
    }
   
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        didFailToConnectPeripheral.send((peripheral, error))
    }
   
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        didDisconnectPeripheral.send((peripheral, error))
    }
   
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        didDiscoverPeripheral.send((peripheral, advertisementData, RSSI))
    }
    
    
    //MARK: - iOS Only
    
    #if os(iOS)
    let didUpdateANCSAuthorizationForPeripheral = PassthroughSubject<CBPeripheral, Never>()
    
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        didUpdateANCSAuthorizationForPeripheral.send(peripheral)
    }
    
    let connectionEventDidOccur = PassthroughSubject<(CBConnectionEvent, CBPeripheral), Never>()
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        connectionEventDidOccur.send((event, peripheral))
    }
    #endif
}
