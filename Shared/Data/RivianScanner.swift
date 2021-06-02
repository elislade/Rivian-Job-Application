import Foundation
import CoreBluetooth
import Combine

class RivianScanner: ObservableObject {
    
    static let shared = RivianScanner()
    
    private var central: CentralManager { CentralManager.shared }
    private var watch: Set<AnyCancellable> = []
    
    @Published var peripherals: Set<ScannedPeripheral> = []
    
    init() {
        central.$state.sink{ s in
            if s == .poweredOn {
                self.checkPeripheralCache()
            }
        }.store(in: &watch)
        
        central.$scannedPeripherals.assign(to: \.peripherals, on: self).store(in: &watch)
    }
    
    func checkPeripheralCache() {
        if peripherals.count == 0 {
            CentralManager.shared.scanForPeripherals(
                withServices: [.r1s_main_id, .r1t_main_id],
                options: [CBPeripheralManagerOptionShowPowerAlertKey: true]
            )
        } else {
            
        }
    }
}
