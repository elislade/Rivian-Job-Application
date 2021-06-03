import Foundation
import CoreLocation
import MapKit

extension CLLocationCoordinate2D: DataCodable {
    init?(_ data: Data) {
        guard
            let lat = Double(data.subdata(in: 0..<8)),
            let lng = Double(data.subdata(in: 8..<16))
        else { return nil }
        
        self.init(latitude: lat, longitude: lng)
    }
    
    var data: Data { latitude.data + longitude.data }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocation {
    
    static func decode(_ data: Data) -> Self? {
        guard data.count == Self.byteSize else { return nil }
        let decoded = data.layoutDecoding(for: layoutTypes)
        
        guard
            let cord = decoded[0] as? CLLocationCoordinate2D,
            let alti = decoded[1] as? Double,
            let horz = decoded[2] as? Double,
            let vert = decoded[3] as? Double,
            let time = decoded[4] as? Date
        else { return nil }

        return self.init(
            coordinate: cord,
            altitude: alti,
            horizontalAccuracy: horz,
            verticalAccuracy: vert,
            timestamp: time
        )
    }
    
    var data:Data {
        let cord = coordinate.data
        let alti = altitude.data
        let hAcc = horizontalAccuracy.data
        let vAcc = verticalAccuracy.data
        let time = timestamp.data
        return cord + alti + hAcc + vAcc + time
    }
    
    
    static let layoutTypes: [DataCodable.Type] = [
        // NOTE: - Location data protocol
        // [coord = 16bytes, alt = 8bytes, hacc = 8bytes, vacc = 8bytes, timestamp = 8bytes]
        CLLocationCoordinate2D.self, Double.self, Double.self, Double.self, Date.self
    ]
    
    static var byteSize: Int {
        layoutTypes.map({ $0.byteSize }).reduce(0, { $0 + $1 })
    }
    
    convenience init?(_ data: Data) {
        guard let s = Self.decode(data) else { return nil }
        
        self.init(
            coordinate: s.coordinate,
            altitude: s.altitude,
            horizontalAccuracy: s.horizontalAccuracy,
            verticalAccuracy: s.verticalAccuracy,
            timestamp: s.timestamp
        )
    }
}


extension CLLocation: MKAnnotation {}

extension CLLocation {
    func address(completion: @escaping (String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: { marks, error in
            completion(marks?.first?.name)
        })
    }
}
