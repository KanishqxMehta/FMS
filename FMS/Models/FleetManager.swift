//
//  FleetManager.swift
//  FMS
//
//  Created by Kanishq Mehta on 14/02/25.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var isDriver: Bool
}

enum VehicleType: String, CaseIterable, Codable {
    case car = "car"
    case miniTruck = "miniTruck"
    case truck = "truck"
}

struct Vehicle: Identifiable, Codable {
    var id: UUID = UUID()
    let vehicleName: String
    var vehicleType: VehicleType
    var totalTrips: String
    var status: String
//    var vehicleNumber: String
//    var lastMaintenanceDate: Date
//    var distanceAfterMaintenance: Double
//    var totalTripsAfterLastMaintenance: Int
}



//struct Driver: Identifiable {
//    let id = UUID()
//    let name: String
//    let vehicle: String
//    let location: String
//    let date: String
//}

struct Trip: Identifiable, Codable {
    var id: UUID = UUID()
    var startLocation: String
    var endLocation: String
    var vehicleType: String
    var vehicleID: String
    var eta: String
    var distance: String
    var startDate: Date
    var startTime: String
    var endTime: String
    var driver: String
}

let sampleTrips: [Trip] = [
    Trip(startLocation: "Rajpura, Punjab", endLocation: "Delhi", vehicleType: "Eicher Pro 2049", vehicleID: "PB10AB1234", eta: "25th Feb, 20:30", distance: "200 km", startDate: Date(), startTime: "18:00", endTime: "20:30", driver: "Sanjeev Rana"),
    Trip(startLocation: "Mumbai, Maharashtra", endLocation: "Pune", vehicleType: "Tata Ultra", vehicleID: "MH12XY5678", eta: "26th Feb, 14:00", distance: "150 km", startDate: Date(), startTime: "10:30", endTime: "14:00", driver: "Amit Sharma"),
    Trip(startLocation: "Jaipur, Rajasthan", endLocation: "Udaipur", vehicleType: "Mahindra Blazo", vehicleID: "RJ14KL7890", eta: "27th Feb, 09:45", distance: "250 km", startDate: Date(), startTime: "05:00", endTime: "09:45", driver: "Vikram Singh"),
    Trip(startLocation: "Bangalore, Karnataka", endLocation: "Chennai", vehicleType: "Ashok Leyland", vehicleID: "KA05PQ2345", eta: "28th Feb, 16:20", distance: "350 km", startDate: Date(), startTime: "12:00", endTime: "16:20", driver: "Ramesh Iyer"),
    Trip(startLocation: "Hyderabad, Telangana", endLocation: "Nagpur", vehicleType: "BharatBenz 1923", vehicleID: "TS08GH4567", eta: "1st Mar, 11:00", distance: "400 km", startDate: Date(), startTime: "07:30", endTime: "11:00", driver: "Suresh Kumar"),
    Trip(startLocation: "Kolkata, West Bengal", endLocation: "Patna", vehicleType: "Force Traveller", vehicleID: "WB20LM6789", eta: "2nd Mar, 18:10", distance: "300 km", startDate: Date(), startTime: "14:00", endTime: "18:10", driver: "Arjun Das")
]
