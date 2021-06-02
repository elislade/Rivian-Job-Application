import Foundation
import Combine
import CoreLocation

class Vehicle {
    
    enum Model: String, CaseIterable {
        case r1t, r1s
    }
    
    let model: Model
    let uuidString: String
    var imageName: String {
        model.rawValue.lowercased()
    }
    
    init(model: Model, uuidString: String){
        self.model = model
        self.uuidString = uuidString
    }
}



extension Vehicle: Hashable, Identifiable {
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        lhs.uuidString == rhs.uuidString
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuidString)
    }
}

extension Vehicle {
    
//    static let r1t = Vehicle(
//        name: "R1T",
//        uuidString: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F",
//        imageName: "r1t"
//    )
//
//    static let r1s = Vehicle(
//        name: "R1S",
//        uuidString: "DCE846F8-2944-44A9-A55B-AE8220068273",
//        imageName: "r1s"
//    )
//
    
    static let r1tClient = VehicleClient(
        model: .r1t,
        uuidString: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F"
    )
    
    static let r1sClient = VehicleClient(
        model: .r1s,
        uuidString: "DCE846F8-2944-44A9-A55B-AE8220068273"
    )
    
    
    static let r1tHost = VehicleHost(
        model: .r1t,
        uuidString: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F"
    )
    
    static let r1sHost = VehicleHost(
        model: .r1s,
        uuidString: "DCE846F8-2944-44A9-A55B-AE8220068273"
    )
    
    static func getHost(from model: Vehicle.Model) -> VehicleHost {
        model == .r1s ? r1sHost : r1tHost
    }
    
    static func getClient(from model: Vehicle.Model) -> VehicleClient {
        model == .r1s ? r1sClient : r1tClient
    }
}
