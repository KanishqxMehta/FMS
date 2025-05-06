//
//  Driver.swift
//  FMS
//
//  Created by Kanishq Mehta on 14/02/25.
//

import Foundation

enum DriverStatus: String {
    case available
    case unavailable
}

struct Driver: Identifiable,Codable {
    var id: UUID = UUID()
    var name: String
    var age: String // Change from Int to String for text field binding
    var address: String
    var mobileNumber: String
    var driverStatus: DriverStatus
    var email: String
    var licenseID: String
    var vehicleType: [VehicleType]
    var totalTrips: Int = 0
    var experienceInYears: Int
    var istanceTraveled: String
    
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "age": age,
            "mobileNumber": mobileNumber,
            "email": email,
            "licenseID": licenseID,
            "vehicleType": vehicleType, // ✅ Ensure Firestore stores `[String]`
            "totalTrips": totalTrips
        ]
    }
    enum DriverStatus: String, Codable {
            case available
            case unavailable
        }
    
}
