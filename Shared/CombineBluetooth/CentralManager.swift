import Foundation
import CoreBluetooth
import Combine
import os

class CentralManager: ObservableObject {
    
    let manager:CBCentralManager!
    let delegate = CBCentralManagerDelegateWrapper()
    
    @Published private(set) var state:CBManagerState = .unknown
    @Published private(set) var scannedPeripherals:[ScannedPeripheral] = []
    @Published private(set) var connectedPeripherals:[Peripheral] = []
    @Published private(set) var isScanning = false
    
    init() {
        self.manager = CBCentralManager(
            delegate: delegate,
            queue: nil,
            options: [CBCentralManagerOptionShowPowerAlertKey: true]
        )
        
        listenToState()
    }
    
    private var statePub:AnyCancellable?
    func listenToState(){
        if statePub == nil {
            statePub = delegate.didUpdateState
                .assign(to: \.state, on: self)
        }
    }
    

    private var scanDuration:TimeInterval = 4
    private var scanInterval:TimeInterval = 1.0
    private var lastScanStartDate = Date()
    
    var shouldAutoScan = true
    
    private var scanPub:AnyCancellable?
    func scanForPeripherals(withServices uuids:[CBUUID]? = nil, options:[String:Any]? = nil) {
        manager.scanForPeripherals(withServices: uuids, options: options)
        
        if scanPub == nil {
            scanPub = delegate.didDiscoverPeripheral
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
                    for a in $0 {
                        print(a.advertisment[CBAdvertisementDataLocalNameKey] ?? "")
                        if let i = self.scannedPeripherals.firstIndex(of: a) {
                           self.scannedPeripherals[i] = a
                        } else {
                            self.scannedPeripherals.append(a)
                        }
                    }
                    self.manager.stopScan()
                }
        }
    }
    
    private var connectPub:AnyCancellable?
    private var connectFailPub:AnyCancellable?
    private var disconnectPub:AnyCancellable?
    func connect(_ peripheral:CBPeripheral, options:[String: Any]?) {
        manager.connect(peripheral, options: options)
        
        if connectPub == nil {
            connectPub = delegate.didConnectPeripheral.sink {
                self.connectedPeripherals.append(
                    Peripheral(self, peripheral: $0)
                )
            }
        }
        
        if connectFailPub == nil {
            connectFailPub = delegate.didFailToConnectPeripheral.sink {
                print("failure to connect", $0)
            }
        }
        
        if disconnectPub == nil {
            disconnectPub = delegate.didDisconnectPeripheral.sink {
                let p = $0.0
                self.connectedPeripherals.removeAll(where: { $0.peripheral.identifier == p.identifier })
            }
        }
    }

    
    func disconnect(_ peripheral: CBPeripheral){
        manager.cancelPeripheralConnection(peripheral)
    }
    
    func startScan() {
        if !manager.isScanning {
            isScanning = true
            lastScanStartDate = Date()
            
            // manager.scanForPeripherals(
                // withServices: [TransferService.serviceUUID],
                // options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            // )

            scanForPeripherals(
                withServices: nil, //[Vehicle.service.uuid],// nil,
                options: [
                    // CBCentralManagerScanOptionAllowDuplicatesKey: true,
                    CBPeripheralManagerOptionShowPowerAlertKey: true
                ]
            )
        }
    }
    
    private func scanningTick() {
        if manager.isScanning {
            let targetEndDate = lastScanStartDate.addingTimeInterval(scanDuration)
            
            if Date() >= targetEndDate {
                stopScan()
            } else {
                let time = DispatchTime.now() + 0.02
                DispatchQueue.main.asyncAfter(deadline: time, execute: scanningTick)
            }
        }
    }
    
    func stopScan() {
        if manager.isScanning {
            manager.stopScan()
            isScanning = false
        }
    }
    
    
    private func cleanup() {
        for p in connectedPeripherals { p.cleanup() }
    }
}
