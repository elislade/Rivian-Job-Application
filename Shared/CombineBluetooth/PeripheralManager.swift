import Foundation
import CoreBluetooth
import Combine

class PeripheralManager: ObservableObject {
    
    static let shared = { PeripheralManager() }()
    
    let manager = CBPeripheralManager()
    let delegate = CBPeripheralManagerDelegateWrapper()
    var centrals: [Central] = []
    
    @Published var isAdvertising = false
    @Published var state: CBManagerState = .unknown
    
    private var watch: Set<AnyCancellable> = []
    
    init(){
        self.manager.delegate = delegate
        listenToState()
        listenToWrite()
        listenToRead()
        listenToSubscribers()
    }

    func listenToSubscribers() {
        delegate.didSubscribeToCharacteristic.sink { central, chars in
            if !self.centrals.contains(where: { $0.central == central }) {
                self.centrals.append(Central(manager: self, central: central))
            }
        }.store(in: &watch)
        
        delegate.didUnsubscribeFromCharacteristic.sink { central, char in
            self.centrals.removeAll(where: { $0.central.identifier == central.identifier })
        }.store(in: &watch)
    }
    
    func listenToState(){
        delegate.didUpdateState
            .assign(to: \.state, on: self)
            .store(in: &watch)
    }
    
    func startAdvertising(_ advertisementData: [String: Any]? = nil) {
        manager.startAdvertising(advertisementData)
        
        delegate.didStartAdvertising.sink { _ in
            self.isAdvertising = true
        }.store(in: &watch)
    }
    
    func stopAdvertising() {
        manager.stopAdvertising()
        isAdvertising = false
    }
    
    var tempData: [CBUUID: Data] = [:]
    let recievedWrite = PassthroughSubject<(char: CBCharacteristic, data: Data), Never>()
    
    func send(_ data: Data, to char: CBMutableCharacteristic) {
        for central in centrals {
            central.send(data, to: char)
        }
    }
    
    func listenToWrite() {
        delegate.didRecieveWrite.sink {
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
        }.store(in: &watch)
    }
    
    
    var reqValue: (CBUUID) -> Data? = {_ in nil}
    
    func listenToRead() {
        delegate.didRecieveRead.sink {
            $0.value = self.reqValue($0.characteristic.uuid)
            self.manager.respond(to: $0, withResult: .success)
        }.store(in: &watch)
    }
    
    func add(_ service: CBMutableService) {
        manager.add(service)
        
        delegate.didAddService
            .filter({$0.0.uuid == service.uuid})
            .sink { print("Added service", $0) }
            .store(in: &watch)
    }
    
    func remove(_ service: CBMutableService) {
        manager.remove(service)
    }
}
