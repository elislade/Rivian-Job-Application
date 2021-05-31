import Foundation
import CoreBluetooth
import SwiftUI

extension CBUUID {
    var image: Image {
        if "\(self)" == "Battery" {
            return Image(systemName: "battery.25")
        } else if "\(self)" == "Current Time" {
            return Image(systemName: "clock")
        } else if "\(self)" == "Device Information" {
            return Image(systemName: "info.circle")
        } else if "\(self)" == "Continuity" {
            return Image(systemName: "link")
        } else {
            return Image(systemName: "questionmark")
        }
    }
}

extension CBPeripheralState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .connected: return "Connected"
        case .connecting: return" Connecting"
        case .disconnected: return "Disconnected"
        case .disconnecting: return "Disconnecting"
        @unknown default: return "unknown"
        }
    }
}

extension CGSize {
    static func *(rhs: CGSize, lhs: CGFloat) -> CGSize {
        return CGSize(width: rhs.width * lhs, height: rhs.height * lhs)
    }
}

extension ScannedPeripheral {
    func asVehicle() -> Vehicle? {
        if let name = advertisment[CBAdvertisementDataLocalNameKey] as? String {
            return Vehicle.get(from: name)
        }
        return nil
    }
}
