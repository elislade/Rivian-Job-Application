import Foundation
import SwiftUI

extension Vehicle {
    enum Action: UInt8, CaseIterable, CustomStringConvertible, Identifiable {
        case unlock = 0, lock, honk

        var image: Image {
            self == .unlock ? Image(systemName: "lock.open.fill") :
            self == .lock ? Image(systemName: "lock.fill") :
            Image(systemName: "dot.radiowaves.right")
        }
        
        var id: String {
            UUID().uuidString
        }
        
        var description: String {
            self == .unlock ? "Unlock" :
            self == .lock ? "Lock" :
            "Honk"
        }
    }
}
