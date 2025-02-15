//
//  Driver.swift
//  FMS
//
//  Created by Kanishq Mehta on 14/02/25.
//

import Foundation

struct Driver: Identifiable {
    var id: UUID = UUID()
    var driverName: String
    var age: Int
    var address: String
    var mobileNumber: String
    var email: String
    var licenseNumber: String
//    var lisenceExpDate: String
    var vehicleType: [VehicleType]
    var experienceInYears: Int
}
