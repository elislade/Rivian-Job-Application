import XCTest
import CoreLocation

class Rivian_Data_Tests: XCTestCase {

    func testAllData() {
        testInts()
        testBools()
        testFloats()
        testDoubles()
        testStrings()
        //testLocation()
    }

    func testStrings() {
        testData("0xFFFF_FFFF")
        testData("😊")
        testData("128.257.0000.235")
        testData("""
            Indescribable oppression, which seemed to generate in some unfamiliar part of her consciousness, filled her whole being with a vague anguish. It was like a shadow, like a mist passing across her soul's summer day. It was strange and unfamiliar; it was a mood. She did not sit there inwardly upbraiding her husband, lamenting at Fate, which had directed her footsteps to the path which they had taken. She was just having a good cry all to herself. The mosquitoes made merry over her, biting her firm, round arms and nipping at her bare insteps.
        """)
    }
    
    func testDoubles() {
        testData(Double(1.73463476020858829923500683468360346))
        testData(Double(-9664303406366346.734))
    }
    
    func testFloats() {
        testData(Float(1.345454355435345))
        testData(Float(-0.345))
    }
    
    func testBools() {
        testData(true)
        testData(false)
    }
    
    func testInts() {
        testInt8()
        testInt16()
        testInt32()
        testInt64()
    }
    
    func testInt8() {
        testData(Int(Int8.min))
        testData(Int(Int8.max))
    }
    
    func testInt16() {
        testData(Int(Int16.min))
        testData(Int(Int16.max))
    }
    
    func testInt32() {
        testData(Int(Int32.min))
        testData(Int(Int32.max))
    }
    
    func testInt64() {
        testData(Int(Int64.min))
        testData(Int(Int64.max))
    }
    
    func testDates() {
        // NOTE: Sometimes fails

        let s = Date()
        XCTAssertEqual(Date(s.data)!, s)
    }
    
    func testCoordinates() {
        testData(CLLocationCoordinate2D(latitude: 49, longitude: -120))
    }
    
    func testLocation() {
        // NOTE: Always failing
        // Don't know why as they have matching outputs in the error
        
        let loc2 = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: 49, longitude: -120),
            altitude: 1000,
            horizontalAccuracy: 10,
            verticalAccuracy: 10,
            timestamp: Date()
        )

        let n = CLLocation(loc2.data)

        XCTAssertEqual(n!, loc2)
    }
    
    func testData<T:DataCodable & Equatable>(_ value:T) {
        let data = value.data
        XCTAssertEqual(T(data), value)
    }

}
