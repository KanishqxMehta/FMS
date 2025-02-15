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

struct Driver: Identifiable {
    var id: UUID = UUID()
    var driverName: String
    var age: Int
    var address: String
    var mobileNumber: String
    var driverStatus: DriverStatus = .available
    var email: String
    var licenseNumber: String
//    var lisenceExpDate: String
    var vehicleType: [VehicleType]
    var totalTrips: Int = 0
    var experienceInYears: Int
}

let drivers: [Driver] = [
    Driver(driverName: "Sanjeev Rana", age: 45, address: "Rajpura, Punjab", mobileNumber: "+91 98765 43210", driverStatus: .available, email: "sanjeev.rana@example.com", licenseNumber: "PB10X123456789", vehicleType: [.miniTruck, .truck], experienceInYears: 20),
    
    Driver(driverName: "Amit Sharma", age: 38, address: "Mumbai, Maharashtra", mobileNumber: "+91 97654 32109", driverStatus: .unavailable, email: "amit.sharma@example.com", licenseNumber: "MH12Y987654321", vehicleType: [.car, .miniTruck], experienceInYears: 15),
    
    Driver(driverName: "Vikram Singh", age: 50, address: "Jaipur, Rajasthan", mobileNumber: "+91 96543 21098", driverStatus: .available, email: "vikram.singh@example.com", licenseNumber: "RJ14Z456789012", vehicleType: [.truck], experienceInYears: 25),
    
    Driver(driverName: "Ramesh Iyer", age: 42, address: "Bangalore, Karnataka", mobileNumber: "+91 95432 10987", driverStatus: .unavailable, email: "ramesh.iyer@example.com", licenseNumber: "KA05P234567890", vehicleType: [.miniTruck, .truck], experienceInYears: 18),
    
    Driver(driverName: "Suresh Kumar", age: 36, address: "Hyderabad, Telangana", mobileNumber: "+91 94321 09876", driverStatus: .available, email: "suresh.kumar@example.com", licenseNumber: "TS08G678901234", vehicleType: [.car, .truck], experienceInYears: 12),
    
    Driver(driverName: "Arjun Das", age: 47, address: "Kolkata, West Bengal", mobileNumber: "+91 93210 98765", driverStatus: .unavailable, email: "arjun.das@example.com", licenseNumber: "WB20L345678901", vehicleType: [.miniTruck], experienceInYears: 22)
]
