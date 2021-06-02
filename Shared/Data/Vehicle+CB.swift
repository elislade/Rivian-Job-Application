import Foundation
import CoreBluetooth

// having dynamic id's per vehicle could be wrong headed

// NOTE: Format is {vehicle}_{service}_{characteristic}_{descriptor}
// EX: r1s_main_location
// EX: r1t_main_action

extension CBUUID {
    
    // MARK: Main Service ID's
    
    static let r1t_main_id = CBUUID(string: "090A5E1E-25C8-41E5-9DEA-8888735B68E2")
    static let r1s_main_id = CBUUID(string: "1B091F07-4BAB-42A0-A818-0AA2F999E5BB")
    static func main_id(for v: Vehicle.Model) -> CBUUID {
        v == .r1s ? r1s_main_id : r1t_main_id
    }
    
    static let r1t_main_action_id = CBUUID(string: "EA4729D5-A438-4731-8D87-101F06801339")
    static let r1s_main_action_id = CBUUID(string: "285375CF-6F38-4607-A19C-66EB614DAA41")
    static func main_action_id(for v: Vehicle.Model) -> CBUUID {
        v == .r1s ? r1s_main_action_id : r1t_main_action_id
    }
    
    static let r1t_main_location_id = CBUUID(string: "B8D29D89-140F-4752-9F38-591D01A40219")
    static let r1s_main_location_id = CBUUID(string: "0018FDC4-CFD8-47AF-BBC0-35A43B179599")
    static func main_location_id(for v: Vehicle.Model) -> CBUUID {
        v == .r1s ? r1s_main_location_id : r1t_main_location_id
    }
}

extension CBMutableService {
    
    static let r1t_main = CBMutableService(type: .r1t_main_id, primary: true)
    static let r1s_main = CBMutableService(type: .r1s_main_id, primary: true)
    static func main(for v: Vehicle.Model) -> CBMutableService {
        v == .r1s ? r1s_main : r1t_main
    }
}

extension CBMutableCharacteristic {
    
    // MARK: Main Service Characteristics
    
    static let r1t_main_action = temp_action(.r1t_main_action_id)
    static let r1s_main_action = temp_action(.r1s_main_action_id)
    static func main_action(for v: Vehicle.Model) -> CBMutableCharacteristic {
        v == .r1s ? r1s_main_action : r1t_main_action
    }
    
    static let r1t_main_location = temp_location(.r1t_main_location_id)
    static let r1s_main_location = temp_location(.r1s_main_location_id)
    static func main_location(for v: Vehicle.Model) -> CBMutableCharacteristic {
        v == .r1s ? r1s_main_location : r1t_main_location
    }
    
    static func temp_action(_ id: CBUUID) -> CBMutableCharacteristic {
        CBMutableCharacteristic(
            type: id,
            properties: [.notify, .writeWithoutResponse],
            value: nil,
            permissions: [.writeable, .readable]
        )
    }
    
    static func temp_location(_ id: CBUUID) -> CBMutableCharacteristic {
        CBMutableCharacteristic(
            type: id,
            properties: [.notify, .read],
            value: nil,
            permissions: [.readable]
        )
    }
}
