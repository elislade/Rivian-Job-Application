import Foundation
import CoreBluetooth
import Combine
import os

class CentralManager: ObservableObject {
    
    static var shared: CentralManager = { CentralManager() }()
    
    let manager: CBCentralManager!
    let delegate = CBCentralManagerDelegateWrapper()
    
    @Published private(set) var state: CBManagerState = .unknown
    @Published private(set) var scannedPeripherals: Set<ScannedPeripheral> = []
    @Published private(set) var connectedPeripherals: Set<Peripheral> = []
    @Published private(set) var isScanning = false
    
    private var watch: Set<AnyCancellable> = []
    private var scanDuration: TimeInterval = 4
    private var scanInterval: TimeInterval = 1.0
    private var lastScanStartDate = Date()
    
    init() {
        self.manager = CBCentralManager(
            delegate: delegate,
            queue: nil,
            options: [
                CBCentralManagerOptionShowPowerAlertKey: true
            ]
        )
        
        delegate.didUpdateState
            .assign(to: \.state, on: self)
            .store(in: &watch)
        
        delegate.didDiscoverPeripheral
            .filter({ $0.rssi.intValue >= -65 })
            .flatMap({
                Just(ScannedPeripheral(
                    peripheral: Peripheral(self, peripheral: $0.peripheral),
                    advertisment: $0.advert,
                    rssi: $0.rssi
                ))
            })
            .collect( .byTime(DispatchQueue.main, 1.5) )
            .sink {
                self.scannedPeripherals.formUnion($0)
                self.manager.stopScan()
            }.store(in: &watch)
        
        delegate.didConnectPeripheral.sink {
            self.connectedPeripherals.update(with: Peripheral(self, peripheral: $0))
        }.store(in: &watch)
        
        delegate.didFailToConnectPeripheral.sink {
            print("failure to connect", $0)
        }.store(in: &watch)
        
        delegate.didDisconnectPeripheral.sink {
            let p = $0.0
            if let i = self.connectedPeripherals.firstIndex(where: { $0.peripheral.identifier == p.identifier }){
                self.connectedPeripherals.remove(at: i)
            }
        }.store(in: &watch)
    }
    
    func scanForPeripherals(withServices uuids: [CBUUID]? = nil, options: [String: Any]? = nil) {
        manager.scanForPeripherals(withServices: uuids, options: options)
    }
    
    func stopScan() {
        if manager.isScanning {
            manager.stopScan()
            isScanning = false
        }
    }
    
    func connect(_ peripheral: CBPeripheral, options: [String: Any]?) {
        manager.connect(peripheral, options: options)
    }

    func disconnect(_ peripheral: CBPeripheral) {
        manager.cancelPeripheralConnection(peripheral)
    }
    
    private func scanningTick() {
        if manager.isScanning {
            let targetEndDate = lastScanStartDate.addingTimeInterval(scanDuration)
            
            if Date() >= targetEndDate {
                stopScan()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: scanningTick)
            }
        }
    }
    
    private func cleanup() {
        for p in connectedPeripherals { p.cleanup() }
    }
}

extension UserDefaults {
    var centralManagerRestorationID: String? {
        get { string(forKey: "CentralManagerRestorationID") }
        set { set(newValue, forKey:"CentralManagerRestorationID") }
    }
}
