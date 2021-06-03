import Foundation
import Combine
import CoreLocation

class Vehicle {
    
    enum Model: String, CaseIterable {
        case r1t, r1s
    }
    
    let model: Model
    let id: String
    
    var imageName: String {
        model.rawValue.lowercased()
    }
    
    init(model: Model, id: String) {
        self.model = model
        self.id = id
    }
}

extension Vehicle: Hashable, Identifiable {
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Vehicle {
    
    static let r1tClient = { VehicleClient(model: .r1t, id: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F") }()
    static let r1sClient = { VehicleClient(model: .r1s, id: "DCE846F8-2944-44A9-A55B-AE8220068273") }()
    
    static let r1tHost = { VehicleHost(model: .r1t, id: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F") }()
    static let r1sHost = { VehicleHost(model: .r1s, id: "DCE846F8-2944-44A9-A55B-AE8220068273") }()
    
    static func host(from model: Model) -> VehicleHost {
        model == .r1s ? r1sHost : r1tHost
    }
    
    static func client(from model: Model) -> VehicleClient {
        model == .r1s ? r1sClient : r1tClient
    }
}
