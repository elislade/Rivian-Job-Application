import Foundation
import SwiftUI
import CoreBluetooth

typealias Info = (name: String, image: Image?)

extension CBService {
    var info: Info {
        if uuid == .r1t_main_id || uuid == .r1s_main_id {
            return ("Rivian Vehicle", Image(systemName: "car.fill"))
        }
        return (uuid.description, uuid.image)
    }
}

protocol UUIDInfo {
    associatedtype DataType: DataCodable
    
    var uuid: CBUUID { get }
    var name: String { get }
    var image: Image? { get }
    var data: DataType.Type { get }
}

struct InfoD<DataType: DataCodable>: UUIDInfo {
    let uuid: CBUUID
    let name: String
    let image: Image?
    let data: DataType.Type = DataType.self
}

extension CBCharacteristic {
    var info: Info {
        if uuid == .r1s_main_action_id || uuid == .r1t_main_action_id {
            return ("Vehicle Action", Image(systemName: "bolt.fill"))
        }
        return (uuid.description, uuid.image)
    }
}
