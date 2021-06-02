import Foundation
import CoreLocation

class VehicleClient: Vehicle, ObservableObject {
    
    private var link: RivianClientLink?
    
    override init(name: String, uuidString: String, imageName: String){
        super.init(name: name, uuidString: uuidString, imageName: imageName)
        self.link = RivianClientLink(self)
    }
    
    @Published var isConnected: Bool = false
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
