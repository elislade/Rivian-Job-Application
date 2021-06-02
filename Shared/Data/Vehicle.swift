import Foundation
import Combine
import CoreLocation

class Vehicle {
    
    let name: String
    let uuidString: String
    let imageName: String
    
    init(name: String, uuidString: String, imageName: String){
        self.name = name
        self.uuidString = uuidString
        self.imageName = imageName
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
    
    static let r1t = Vehicle(
        name: "R1T",
        uuidString: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F",
        imageName: "r1t"
    )
    
    static let r1s = Vehicle(
        name: "R1S",
        uuidString: "DCE846F8-2944-44A9-A55B-AE8220068273",
        imageName: "r1s"
    )
    
    
    static let r1tClient = VehicleClient(
        name: "R1T",
        uuidString: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F",
        imageName: "r1t"
    )
    
    static let r1sClient = VehicleClient(
        name: "R1S",
        uuidString: "DCE846F8-2944-44A9-A55B-AE8220068273",
        imageName: "r1s"
    )
    
    
    static let r1tHost = VehicleHost(
        name: "R1T",
        uuidString: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F",
        imageName: "r1t"
    )
    
    static let r1sHost = VehicleHost(
        name: "R1S",
        uuidString: "DCE846F8-2944-44A9-A55B-AE8220068273",
        imageName: "r1s"
    )
    
    static func getHost(from string: String) -> VehicleHost {
        string.lowercased().contains(r1t.name.lowercased()) ? r1tHost : r1sHost
    }
    
    static func getClient(from string: String) -> VehicleClient {
        string.lowercased().contains(r1t.name.lowercased()) ? r1tClient : r1sClient
    }
}
