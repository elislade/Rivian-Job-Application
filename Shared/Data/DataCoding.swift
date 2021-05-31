import Foundation

enum DataType: UInt8 {
    case string = 0, float, double, int, bool
}

// NOTE: data layout/protocol idea
// packet = [DataType, Data...]
// the first byte in every packet will declare what base type the resulting data is

protocol DataCodable {
    init?(_ data: Data)
    var data: Data { get }
    
    static var byteSize: Int { get }
}

extension DataCodable {
    static var byteSize: Int {
        MemoryLayout<Self>.size
    }
}

extension Data {
    func to<T: ExpressibleByIntegerLiteral>(type: T.Type) -> T? {
        var value: T = 0
        guard self.count == MemoryLayout.size(ofValue: value) else { return nil }
        _ = Swift.withUnsafeMutableBytes(of: &value, { copyBytes(to: $0)} )
        return value
    }
    
    
    // NOTE: - Chunks data into specified size
    // Eg. 100kb piece of data chunked to size 10kb would return 10 chunks
    // size is in bytes 10kb = 10,000 in actual usage
    
    func chunked(to size: Int, withEOM: Bool = true) -> [Data] {
        let chunkCount = ceil(Double(count) / Double(size))
        var chunkedData: [Data] = []

        if count > size {
            for i in 0..<Int(chunkCount)  {
                let start = i * size
                let end = start + size
                chunkedData.append(subdata(in: start..<Swift.min(end, count)))
            }
        } else {
            chunkedData = [self]
        }
        
        if withEOM {
            chunkedData.append("EOM".data)
        }
        
        return chunkedData
    }
    
    
    // NOTE: - Used to map data to a given typed memory layout.
    // Helpful for decoding data to an array of
    // inited typed values
    
    func layoutDecoding(for layout: [DataCodable.Type]) -> [DataCodable] {
        layout.reduce(into: (byteIndex: 0, types: [DataCodable]()), { track, type in
            if let inited = type.init(subdata(in: track.byteIndex..<track.byteIndex + type.byteSize)) {
                track.types.append(inited)
                track.byteIndex += type.byteSize
            }
        }).types
    }
}

extension Data: DataCodable {
    var data: Data { self }
}


//MARK: - UInt8

extension UInt8: DataCodable {
    init?(_ data: Data) { self = data[0] }
    var data: Data { Data([self]) }
}

enum BitSize: UInt8, DataCodable {
    case _8 = 0, _16, _32, _64
}


//MARK: - Bool

extension Bool: DataCodable {
    init?(_ data: Data) {
        self = data[0] == 1
    }
    
    var data: Data {
        self == true ? Data([1]) : Data([0])
    }
}


//MARK: - Double

extension Double: DataCodable {
    
    init?(_ data: Data) {
        guard let v = data.to(type: Self.self) else { return nil }
        self = v
    }
    
    var data: Data {
        withUnsafeBytes(of: self, { Data($0) })
    }
}


//MARK: - Float

extension Float: DataCodable {
    
    init?(_ data: Data) {
        guard let v = data.to(type: Self.self) else { return nil }
        self = v
    }
    
    var data: Data {
        withUnsafeBytes(of: self, { Data($0) })
    }
    
}


//MARK: - Int

extension Int: DataCodable {
    
    static func decode(_ data: Data) -> Int? {
        let bitData = data.subdata(in: 0..<1)
        let intData = data.subdata(in: 1..<data.count)
        
        guard let bitSize = BitSize(bitData) else { return nil }
        
        if bitSize == ._8 {
            if let v = intData.to(type: Int8.self) {
                return Int(v)
            }
        } else if bitSize == ._16 {
            if let v = intData.to(type: Int16.self) {
                return Int(Int16(bigEndian: v))
            }
        } else if bitSize == ._32 {
            if let v = intData.to(type: Int32.self) {
                return Int(Int32(bigEndian: v))
            }
        } else {
            if let v = intData.to(type: Int64.self) {
                return Int(Int64(bigEndian: v))
            }
        }
        
        return nil
    }
    
    init?(_ data: Data) {
        guard let n = Self.decode(data) else { return nil }
        self = n
    }
    
    var data: Data {
        var bitData = Data()
        var intData = Data()

        if self >= Int8.min && self <= Int8.max {
            bitData = BitSize._8.data
            intData = withUnsafeBytes(of: Int8(self).bigEndian, { Data($0) })
        } else if self >= Int16.min && self <= Int16.max {
            bitData = BitSize._16.data
            intData = withUnsafeBytes(of: Int16(self).bigEndian, { Data($0) })
        } else if self >= Int32.min && self <= Int32.max {
            bitData = BitSize._32.data
            intData = withUnsafeBytes(of: Int32(self).bigEndian, { Data($0) })
        } else {
            bitData = BitSize._64.data
            intData = withUnsafeBytes(of: self.bigEndian, { Data($0) })
        }
        
        return bitData + intData
    }

}

extension UInt: DataCodable {
    
    static func decode(_ data: Data) -> UInt? {
        let bitData = data.subdata(in: 0..<1)
        let intData = data.subdata(in: 1..<data.count)
        
        guard let bitSize = BitSize(bitData) else { return nil }
        
        if bitSize == ._8 {
            if let v = intData.to(type: UInt8.self) {
                return UInt(v)
            }
        } else if bitSize == ._16 {
            if let v = intData.to(type: UInt16.self) {
                return UInt(UInt16(bigEndian: v))
            }
        } else if bitSize == ._32 {
            if let v = intData.to(type: UInt32.self) {
                return UInt(UInt32(bigEndian: v))
            }
        } else {
            if let v = intData.to(type: UInt64.self) {
                return UInt(UInt64(bigEndian: v))
            }
        }
        
        return nil
    }
    
    init?(_ data: Data) {
        guard let n = Self.decode(data) else { return nil }
        self = n
    }
    
    var data: Data {
        var bitData = Data()
        var intData = Data()

        if self >= UInt8.min && self <= UInt8.max {
            bitData = BitSize._8.data
            intData = withUnsafeBytes(of: UInt8(self).bigEndian, { Data($0) })
        } else if self >= UInt16.min && self <= UInt16.max {
            bitData = BitSize._16.data
            intData = withUnsafeBytes(of: UInt16(self).bigEndian, { Data($0) })
        } else if self >= UInt32.min && self <= UInt32.max {
            bitData = BitSize._32.data
            intData = withUnsafeBytes(of: UInt32(self).bigEndian, { Data($0) })
        } else {
            bitData = BitSize._64.data
            intData = withUnsafeBytes(of: self.bigEndian, { Data($0) })
        }
        
        return bitData + intData
    }

}


//MARK: - String

extension String: DataCodable {

    init?(_ data: Data) {
        guard let s = String(data: data, encoding: .utf8) else { return nil }
        self = s
    }
    
    var data: Data {
        Data(utf8)
    }
}


//MARK: - Date

extension Date: DataCodable {
    
    init?(_ data: Data) {
        guard let d = Double(data) else { return nil }
        self.init(timeIntervalSince1970: d)
    }
    
    var data: Data {
        timeIntervalSince1970.data
    }
    
    static var byteSize: Int {
        Double.byteSize
    }
}

extension RawRepresentable where RawValue: DataCodable {
    
    init?(_ data: Data) {
        guard let d = RawValue(data) else { return nil }
        self.init(rawValue: d)
    }
    
    var data: Data {
        rawValue.data
    }
}
