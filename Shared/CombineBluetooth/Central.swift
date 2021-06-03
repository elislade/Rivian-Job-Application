import Foundation
import CoreBluetooth
import Combine

class Central {
    
    weak var manager: PeripheralManager!
    let central: CBCentral
    var characteristics: [CBMutableCharacteristic] = []
    
    private var watch: Set<AnyCancellable> = []
    
    init(manager: PeripheralManager, central: CBCentral) {
        self.manager = manager
        self.central = central
        self.manager.delegate.isReadyToUpdateSubscribers
            .sink { self.processQueue() }
            .store(in: &watch)
    }
    
    func send(_ data: Data, to char: CBMutableCharacteristic) {
        let size = central.maximumUpdateValueLength
        sendDataQueue.append((char, data.chunked(to: size)))
        processQueue()
    }
    
    private var sendDataQueue: [(char: CBMutableCharacteristic, chunks: [Data])] = []
    
    private func processQueue() {
        if !self.sendDataQueue.isEmpty {
            // process first data on queue
            let first = self.sendDataQueue[0]
            
            if let data = self.sendDataQueue[0].chunks.first {
                let didSend = self.manager.manager.updateValue(
                    data, for: first.char, onSubscribedCentrals: [self.central]
                )
                
                if didSend {
                    self.sendDataQueue[0].chunks.removeFirst()
                    processQueue()
                }
            } else {
                self.sendDataQueue.removeFirst()
            }
        }
    }
}

extension Central: Hashable {
    static func == (lhs: Central, rhs: Central) -> Bool {
        lhs.central == rhs.central
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(central)
    }
}
