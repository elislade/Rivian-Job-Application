import Foundation
import CoreLocation

class VehicleHost: Vehicle, ObservableObject {
    
    private var link: RivianHostLink?
    
    @Published var location: CLLocation?
    @Published var isSetup: Bool = false
    @Published var isConnected: Bool = false
    @Published var actions: [Action] = []
    
    override init(name: String, uuidString: String, imageName: String){
        super.init(name: name, uuidString: uuidString, imageName: imageName)
        self.link = RivianHostLink(self)
    }
    
    func send(_ action: Vehicle.Action) {
        link?.send(action)
    }
    
    func update(location: CLLocation) {
        link?.update(location: location)
        self.location = location
    }
    
    func setup() {
        link?.setup()
    }
    
    func teardown() {
        link?.teardown()
    }
}
