import Foundation
import Combine
import CoreLocation

class Vehicle: ObservableObject {
    
    let name: String
    let uuidString: String
    let imageName: String
    
    private var link: RivianLink?
    
    init(name: String, uuidString: String, imageName: String){
        self.name = name
        self.uuidString = uuidString
        self.imageName = imageName
        self.link = RivianLink(self)
    }
    
    @Published var isConnected = false
    @Published var isAdvert = false
    @Published var actions: [Vehicle.Action] = []
    @Published var location: CLLocation?
    
    func send(action: Action) {
        link?.send(action: action)
    }
    
    func disconnect() {
        link?.disconnect()
    }
    
    func connect() {
        link?.connect()
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
    
    static func get(from string: String) -> Vehicle {
        string.lowercased().contains(r1t.name.lowercased()) ? r1t : r1s
    }
}
