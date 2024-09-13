// MARK: - LocationData
struct LocationData: Codable {
    let placeID: String
    let licence: String
    let osmType: String
    let osmID: String
    let lat: String
    let lon: String
    let displayName: String
    let address: Address
    let boundingbox: [String]

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case licence
        case osmType = "osm_type"
        case osmID = "osm_id"
        case lat, lon
        case displayName = "display_name"
        case address, boundingbox
    }
}

// MARK: - Address
struct Address: Codable {
    let houseNumber: String?
    let road: String?
    let neighbourhood: String?
    let hamlet: String?
    let city: String?
    let county: String?
    let state: String?
    let postcode: String?
    let country: String?
    let countryCode: String?

    enum CodingKeys: String, CodingKey {
        case houseNumber = "house_number"
        case road, neighbourhood, hamlet, city, county, state, postcode, country
        case countryCode = "country_code"
    }
}
