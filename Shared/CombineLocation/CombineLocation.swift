import Foundation
import CoreLocation
import Combine

class Location: ObservableObject {
    let delegate = CLLocationManagerDelegateWrapper()
    let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    
    init(){
        manager.delegate = delegate
        manager.requestWhenInUseAuthorization()
        listenToAuthChange()
        listenToLocationChange()
        listenToLocationsChange()
    }
    
    var authPub: AnyCancellable?
    func listenToAuthChange(){
        authPub = delegate.didChangeAuth
            .sink {
                #if os(macOS)
                if $0 == .authorizedAlways {
                    self.manager.requestLocation()
                }
                #else
                if $0 == .authorizedAlways || $0 == .authorizedWhenInUse {
                    self.manager.requestLocation()
                }
                #endif
            }
    }
    
    var locPub: AnyCancellable?
    func listenToLocationChange(){
        locPub = delegate.didUpdateLocation
            .map({$0.new})
            .assign(to: \.location, on: self)
    }
    
    var locsPub: AnyCancellable?
    func listenToLocationsChange(){
        locsPub = delegate.didUpdateLocations
            .map({$0.last})
            .assign(to: \.location, on: self)
    }
}
