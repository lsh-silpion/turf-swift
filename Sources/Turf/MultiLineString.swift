import Foundation
#if !os(Linux)
import CoreLocation
#endif


/**
 A `MultiLineString` geometry. The coordinates property represent a `[CLLocationCoordinate2D]` of two or more coordinates.
 */
public struct MultiLineString: Codable, Equatable {
    var type: String = GeometryType.MultiLineString.rawValue
    public var coordinates: [[CLLocationCoordinate2D]]
    
    public init(_ coordinates: [[CLLocationCoordinate2D]]) {
        self.coordinates = coordinates
    }
    
    public init(_ polygon: Polygon) {
        self.coordinates = polygon.coordinates
    }
}

public struct MultiLineStringFeature: GeoJSONObject {
    public var type: FeatureType = .feature
    public var identifier: FeatureIdentifier?
    public var geometry: MultiLineString!
    public var properties: [String : AnyJSONType]?
    
    public init(_ geometry: MultiLineString) {
        self.geometry = geometry
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GeoJSONCodingKeys.self)
        geometry = try container.decode(MultiLineString.self, forKey: .geometry)
        properties = try container.decode([String: AnyJSONType]?.self, forKey: .properties)
        identifier = try container.decodeIfPresent(FeatureIdentifier.self, forKey: .identifier)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GeoJSONCodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(geometry, forKey: .geometry)
        try container.encode(properties, forKey: .properties)
        try container.encodeIfPresent(identifier, forKey: .identifier)
    }
}
