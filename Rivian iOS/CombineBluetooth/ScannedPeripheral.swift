import Foundation
import CoreBluetooth

struct ScannedPeripheral {
    let peripheral:Peripheral
    let advertisment:[String: Any]
    let rssi:NSNumber
}

extension ScannedPeripheral: Identifiable {
    var id: UUID {
        peripheral.peripheral.identifier
    }
}

extension ScannedPeripheral: Equatable {
    static func == (lhs: ScannedPeripheral, rhs: ScannedPeripheral) -> Bool {
        lhs.peripheral == rhs.peripheral
    }
}

extension ScannedPeripheral: Hashable {
    func hash(into hasher: inout Hasher) {
        peripheral.hash(into: &hasher)
    }
}
