import Foundation
import CoreBluetooth
import Combine

class RivianScanner: ObservableObject {
    
    static let shared = RivianScanner()
    
    @Published private(set) var peripherals: Set<ScannedPeripheral> = []
    
    private var watch: Set<AnyCancellable> = []
    private var manager: CentralManager { CentralManager.shared }
    
    init() {
        manager.$scannedPeripherals.assign(to: \.peripherals, on: self).store(in: &watch)
        
        manager.$state.print("state").sink{ s in
            if s == .poweredOn {
                self.checkPeripheralCache()
            }
        }.store(in: &watch)
    }
    
    func checkPeripheralCache() {
        if peripherals.isEmpty {
            manager.scanForPeripherals(
                withServices: [.r1s_main_id, .r1t_main_id],
                options: [CBPeripheralManagerOptionShowPowerAlertKey: true]
            )
        } else {
            
        }
    }
}
