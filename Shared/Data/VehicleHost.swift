import Foundation
import CoreLocation

class VehicleHost: Vehicle, ObservableObject {
    
    private var link: RivianHostLink?
    
    @Published var location: CLLocation?
    @Published var isSetup: Bool = false
    @Published var isConnected: Bool = false
    @Published var actions: [Action] = []
    
    override init(model: Model, id: String) {
        super.init(model: model, id: id)
        self.link = RivianHostLink(self)
    }
    
    func send(_ action: Vehicle.Action) {
        link?.send(action)
    }
    
    func update(location: CLLocation) {
        self.location = location
        link?.update(location: location)
    }
    
    func setup() {
        if isSetup { return }
        link?.setup()
    }
    
    func teardown() {
        link?.teardown()
    }
}
