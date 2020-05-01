import Foundation
import CoreBluetooth
import Combine

class PeripheralManager:ObservableObject {
    
    let manager = CBPeripheralManager()
    let delegate = CBPeripheralManagerDelegateWrapper()
    var centrals:[Central] = []
    
    @Published var isAdvertising = false
    @Published var state:CBManagerState = .unknown
    
    init(){
        self.manager.delegate = delegate
        listenToState()
        listenToWrite()
        listenToRead()
        listenToSubscribers()
    }
    
    private var subPub:AnyCancellable?
    private var unsubPub:AnyCancellable?
    func listenToSubscribers(){
        subPub = delegate.didSubscribeToCharacteristic.sink { central, chars in
            if !self.centrals.contains(where: { $0.central == central }) {
                self.centrals.append(Central(manager: self, central: central))
            }
        }
        unsubPub = delegate.didUnsubscribeFromCharacteristic.sink { central, char in
            self.centrals.removeAll(where: { $0.central.identifier == central.identifier })
        }
    }
    
    private var statePub:AnyCancellable?
    func listenToState(){
        if statePub == nil {
            statePub = delegate.didUpdateState.assign(to: \.state, on: self)
        }
    }
    
    private var advertiseSub:AnyCancellable?
    func startAdvertising(_ advertisementData: [String: Any]? = nil) {
        manager.startAdvertising(advertisementData)
        
        if advertiseSub == nil {
            advertiseSub = delegate.didStartAdvertising.sink { _ in
                self.isAdvertising = true
            }
        }
    }
    
    func stopAdvertising() {
        manager.stopAdvertising()
        isAdvertising = false
    }
    
    var tempData:[CBUUID: Data] = [:]
    let recievedWrite = PassthroughSubject<(char:CBCharacteristic, data: Data), Never>()
    
    func send(_ data:Data, to char:CBMutableCharacteristic) {
        for central in centrals {
            central.send(data, to: char)
        }
    }
    
    var writeSub:AnyCancellable?
    func listenToWrite() {
        if writeSub == nil {
            writeSub = delegate.didRecieveWrite.sink {
                for req in $0 {
                    if let data = req.value {
                        if "EOM".data == data {
                            self.recievedWrite.send((req.characteristic, self.tempData[req.characteristic.uuid]!))
                            self.tempData[req.characteristic.uuid] = Data()
                        } else {
                            if self.tempData.index(forKey: req.characteristic.uuid) == nil {
                                self.tempData[req.characteristic.uuid] = Data()
                            }
                            self.tempData[req.characteristic.uuid]?.append(data)
                        }
                    }
                }
            }
        }
    }
    
    
    var reqValue:(CBUUID) -> Data? = {_ in nil}
    
    var readSub:AnyCancellable?
    func listenToRead() {
        if readSub == nil {
            readSub = delegate.didRecieveRead.sink {
                $0.value = self.reqValue($0.characteristic.uuid)
                self.manager.respond(to: $0, withResult: .success)
            }
        }
    }
    
    var serviceSub:AnyCancellable?
    func add(_ service:CBMutableService) {
        manager.add(service)
        
        if serviceSub == nil {
            serviceSub = delegate.didAddService
                .filter({$0.0.uuid == service.uuid})
                .sink { print("Added service", $0) }
        }
    }
    
    func remove(_ service:CBMutableService) {
        manager.remove(service)
    }
}
