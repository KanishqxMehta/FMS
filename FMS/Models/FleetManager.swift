//
//  FleetManager.swift
//  FMS
//
//  Created by Kanishq Mehta on 14/02/25.
//

import Foundation
import Firebase

// MARK: - User Model
struct User: Identifiable, Codable {
  var id: String
  var email: String
  var isDriver: Bool
}

// MARK: - Vehicle Type Enum
enum VehicleType: String, CaseIterable, Codable {
  case car = "Car"
  case miniTruck = "Mini Truck"
  case truck = "Truck"
}

// MARK: - Vehicle Model
struct Vehicle: Identifiable, Codable {
  var id: UUID = UUID()
  var vehicleName: String
  var year: Int
  var vehicleType: VehicleType
  var totalTrips: String
  var status: VehicleStatus = .available
  var vin: String
  var rcExpiryDate: Date
  var pollutionExpiryDate: Date
  var insuranceExpiryDate: Date
  var permitExpiryDate: Date
  var chassisNumber: Int
  var engineNumber: Int
}

enum VehicleStatus: String, Codable {
    case available = "available"
    case inMaintenance = "in Maintenance"
    case onTrip = "on Trip"
}


struct Trip: Identifiable, Codable {
  var id: UUID = UUID()
  var startLocation: String
  var endLocation: String
  var vehicleType: VehicleType
  var vehicleID: String
  var eta: String
  var distance: String
  var startDate: Date
  var endDate: Date
  var driver: String
  var status: String = "Pending" // ✅ New field to track trip status
//  var driverName: String = ""
  
  
}

