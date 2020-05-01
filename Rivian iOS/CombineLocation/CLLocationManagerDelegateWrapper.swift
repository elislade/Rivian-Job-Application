import Foundation
import CoreLocation
import Combine

class CLLocationManagerDelegateWrapper: NSObject, CLLocationManagerDelegate {
    
   
    // MARK: - Auth
    
    let didChangeAuth = PassthroughSubject<CLAuthorizationStatus, Never>()
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        didChangeAuth.send(status)
    }
    
    
    // MARK: - Location
    
    let didUpdateLocation = PassthroughSubject<(new: CLLocation, old: CLLocation), Never>()
    let didUpdateLocations = PassthroughSubject<[CLLocation], Never>()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didUpdateLocations.send(locations)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateTo newLocation: CLLocation, from oldLocation: CLLocation) {
//        didUpdateLocation.send((newLocation, oldLocation))
//    }
    
    
    // MARK: - Regions
    
    let didStartMonitoringForRegion = PassthroughSubject<CLRegion, Never>()
    let didEnterRegion = PassthroughSubject<CLRegion, Never>()
    let didExitRegion = PassthroughSubject<CLRegion, Never>()
    let didDetermineState = PassthroughSubject<(state:CLRegionState, region:CLRegion), Never>()
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        didStartMonitoringForRegion.send(region)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        didEnterRegion.send(region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        didExitRegion.send(region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        didDetermineState.send((state, region))
    }
    
    
    // MARK: - Errors
    
    let didFailWithError = PassthroughSubject<Error, Never>()
    let didFinishDeferredUpdatesWithError = PassthroughSubject<Error?, Never>()
    let monitoringDidFailForRegion = PassthroughSubject<(region:CLRegion?, error:Error), Never>()
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didFailWithError.send(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        didFinishDeferredUpdatesWithError.send(error)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        monitoringDidFailForRegion.send((region, error))
    }
}
