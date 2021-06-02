import Foundation
import CoreLocation

class VehicleHost: Vehicle, ObservableObject {
    
    private var link: RivianHostLink?
    
    @Published var location: CLLocation?
    @Published var isSetup: Bool = false
    @Published var isConnected: Bool = false
    @Published var actions: [Action] = []
    
    override init(model: Model, uuidString: String){
        super.init(model: model, uuidString: uuidString)
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
        if isSetup { return }
        link?.setup()
    }
    
    func teardown() {
        link?.teardown()
    }
}
