//
//  FirestoreService.swift
//  FMS
//
//  Created by Naman Sharma on 17/02/25.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService() // ✅ Singleton Instance
    private let db = Firestore.firestore()
   
    func addDriver(_ driver: Driver, completion: @escaping (Error?) -> Void) {
        let driverData: [String: Any] = [
            "id": driver.id.uuidString, // Ensure it's stored as a String
            "name": driver.name,
            "age": Int(driver.age) ?? 0, // Ensure `age` is stored as an Int
            "address": driver.address,
            "mobileNumber": driver.mobileNumber,
            "email": driver.email,
            "licenseID": driver.licenseID,
            "experienceInYears": driver.experienceInYears, // Ensure it's stored as an Int
            "totalTrips": driver.totalTrips, // Ensure it's stored as an Int
            "driverStatus": driver.driverStatus.rawValue // Store Enum as String
        ]


            db.collection("drivers").document(driver.id.uuidString).setData(driverData) { error in
                if let error = error {
                    print("❌ Error adding driver: \(error.localizedDescription)")
                } else {
                    print("✅ Driver added successfully!")
                }
                completion(error)
            }
        }

    // 🔹 Fetch All Drivers from Firestore
    func fetchDrivers(completion: @escaping ([Driver]) -> Void) {
        db.collection("drivers").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                completion([])
                return
            }
            
            let drivers = documents.compactMap { doc -> Driver? in
                let data = doc.data()
                
                // ✅ Safe extraction of driverStatus
                let driverStatus: Driver.DriverStatus
                if let statusString = data["driverStatus"] as? String, let status = Driver.DriverStatus(rawValue: statusString) {
                    driverStatus = status
                } else {
                    driverStatus = .available
                }

                // ✅ Convert [String] from Firestore to [VehicleType]
                let vehicleTypes = (data["vehicleType"] as? [String])?.compactMap { VehicleType(rawValue: $0) } ?? []

                return Driver(
                    id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                    name: data["name"] as? String ?? "",
                    age: data["age"] as? String ?? "",
                    address: data["address"] as? String ?? "",
                    mobileNumber: data["mobileNumber"] as? String ?? "",
                    driverStatus: driverStatus,  // ✅ Fixed error
                    email: data["email"] as? String ?? "",
                    licenseID: data["licenseID"] as? String ?? "",
                    vehicleType: vehicleTypes, // ✅ Converted correctly
                    totalTrips: data["totalTrips"] as? Int ?? 0,
                    experienceInYears: data["experienceInYears"] as? Int ?? 0,
                    istanceTraveled: data["istanceTraveled"] as? String ?? "0 km"
                )
            }
            completion(drivers)

        }
    }

    // 🔹 Delete Driver from Firestore
    func deleteDriver(driverID: String, completion: @escaping (Bool, String?) -> Void) {
        db.collection("drivers").document(driverID).delete { error in
            if let error = error {
                print("❌ Firestore Delete Error: \(error.localizedDescription)")
                completion(false, "Firestore Delete Error: \(error.localizedDescription)")
            } else {
                print("✅ Driver successfully deleted from Firestore")
                completion(true, nil)
            }
        }
    }
    
//    func updateDriverAvailability(driverID: String, isAvailable: Bool, completion: @escaping (Bool, String?) -> Void) {
//            db.collection("drivers").document(driverID).updateData(["driverStatus": isAvailable ? "available" : "unavailable"]) { error in
//                if let error = error {
//                    completion(false, error.localizedDescription)
//                } else {
//                    completion(true, nil)
//                }
//            }
//        }
    
    func saveVehicle(vehicle: Vehicle, completion: @escaping (Bool, String?) -> Void) {
            let vehicleData: [String: Any] = [
                "id": vehicle.id.uuidString,
                "vehicleName": vehicle.vehicleName,
                "year": vehicle.year,
                "vehicleType": vehicle.vehicleType.rawValue,
                "totalTrips": vehicle.totalTrips,
                "status": vehicle.status.rawValue,
                "vin": vehicle.vin,
                "rcExpiryDate": vehicle.rcExpiryDate.timeIntervalSince1970,
                "pollutionExpiryDate": vehicle.pollutionExpiryDate.timeIntervalSince1970,
                "insuranceExpiryDate": vehicle.insuranceExpiryDate.timeIntervalSince1970,
                "permitExpiryDate": vehicle.permitExpiryDate.timeIntervalSince1970,
                "chassisNumber": vehicle.chassisNumber,
                "engineNumber": vehicle.engineNumber
            ]

            db.collection("vehicles").document(vehicle.id.uuidString).setData(vehicleData, merge: true) { error in
                if let error = error {
                    print("❌ Firestore Save Error: \(error.localizedDescription)")
                    completion(false, "Firestore Save Error: \(error.localizedDescription)")
                } else {
                    print("✅ Vehicle successfully saved to Firestore")
                    completion(true, nil)
                }
            }
        }

    func fetchVehicles(completion: @escaping ([Vehicle]) -> Void) {
            db.collection("vehicles").getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }

                let vehicles = documents.compactMap { doc -> Vehicle? in
                    let data = doc.data()
                    return Vehicle(
                        id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                        vehicleName: data["vehicleName"] as? String ?? "",
                        year: data["year"] as? Int ?? 0,
                        vehicleType: VehicleType(rawValue: data["vehicleType"] as? String ?? "car") ?? .car,
                        totalTrips: data["totalTrips"] as? String ?? "0",
                        status: data["status"] as? VehicleStatus ?? .available,
                        vin: data["vin"] as? String ?? "",
                        rcExpiryDate: Date(timeIntervalSince1970: data["rcExpiryDate"] as? TimeInterval ?? 0),
                        pollutionExpiryDate: Date(timeIntervalSince1970: data["pollutionExpiryDate"] as? TimeInterval ?? 0),
                        insuranceExpiryDate: Date(timeIntervalSince1970: data["insuranceExpiryDate"] as? TimeInterval ?? 0),
                        permitExpiryDate: Date(timeIntervalSince1970: data["permitExpiryDate"] as? TimeInterval ?? 0),
                        chassisNumber: data["chassisNumber"] as? Int ?? 0,
                        engineNumber: data["engineNumber"] as? Int ?? 0
                        )
                        
                }
                completion(vehicles)
            }
        }
    
    func deleteVehicle(vehicleID: String, completion: @escaping (Bool, String?) -> Void) {
            db.collection("vehicles").document(vehicleID).delete { error in
                if let error = error {
                    print("❌ Firestore Delete Error: \(error.localizedDescription)")
                    completion(false, "Firestore Delete Error: \(error.localizedDescription)")
                } else {
                    print("✅ Vehicle successfully deleted from Firestore")
                    completion(true, nil)
                }
            }
        }
    
    func saveTrip(trip: Trip, completion: @escaping (Bool, String?) -> Void) {
            let tripData: [String: Any] = [
              "id": trip.id.uuidString,
              "startLocation": trip.startLocation,
              "endLocation": trip.endLocation,
              "vehicleType": trip.vehicleType,
              "vehicleID": trip.vehicleID,
              "eta": trip.eta,
              "distance": trip.distance,
              "startDate": trip.startDate.timeIntervalSince1970,
              "endDate": trip.endDate.timeIntervalSince1970,
              "driver": trip.driver,
              "status": trip.status // ✅ Added missing field
            ]

            db.collection("trips").document(trip.id.uuidString).setData(tripData, merge: true) { error in
                if let error = error {
                    print("❌ Firestore Save Error: \(error.localizedDescription)")
                    completion(false, "Firestore Save Error: \(error.localizedDescription)")
                } else {
                    print("✅ Trip successfully saved to Firestore")
                    completion(true, nil)
                }
            }
        }

        // MARK: - Fetch All Trips from Firestore
        func fetchTrips(completion: @escaping ([Trip]) -> Void) {
            db.collection("trips").addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }

                let trips = documents.compactMap { doc -> Trip? in
                    let data = doc.data()
                    return Trip(
                      id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                      startLocation: data["startLocation"] as? String ?? "",
                      endLocation: data["endLocation"] as? String ?? "",
                      vehicleType: data["vehicleType"] as? VehicleType ?? .car,
                      vehicleID: data["vehicleID"] as? String ?? "",
                      eta: data["eta"] as? String ?? "",
                      distance: data["distance"] as? String ?? "",
                      startDate: Date(timeIntervalSince1970: data["startDate"] as? TimeInterval ?? 0),
                      endDate: Date(timeIntervalSince1970: data["endDate"] as? TimeInterval ?? 0),
                      driver: data["driver"] as? String ?? "",
                      status: data["status"] as? String ?? "Pending" // ✅ Fetch from Firestore, fallback to "Pending"
                    )
                }
                DispatchQueue.main.async {
                            completion(trips)
                        }
            }
        }
    
    func fetchCompletedTrips(completion: @escaping ([Trip]) -> Void) {
        db.collection("trips")
            .whereField("status", isEqualTo: "Completed")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }

                let trips = documents.compactMap { doc -> Trip? in
                    let data = doc.data()
                    return Trip(
                        id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                        startLocation: data["startLocation"] as? String ?? "",
                        endLocation: data["endLocation"] as? String ?? "",
                        vehicleType: data["vehicleType"] as? VehicleType ?? .car,
                        vehicleID: data["vehicleID"] as? String ?? "",
                        eta: data["eta"] as? String ?? "",
                        distance: data["distance"] as? String ?? "",
                        startDate: Date(timeIntervalSince1970: data["startDate"] as? TimeInterval ?? 0),
                        endDate: Date(timeIntervalSince1970: data["endDate"] as? TimeInterval ?? 0),
                        driver: data["driver"] as? String ?? "",
                        status: data["status"] as? String ?? "Pending"
                    )
                }
                completion(trips)
            }
    }


        // MARK: - Delete Trip from Firestore
        func deleteTrip(tripID: String, completion: @escaping (Bool, String?) -> Void) {
            db.collection("trips").document(tripID).delete { error in
                if let error = error {
                    print("❌ Firestore Delete Error: \(error.localizedDescription)")
                    completion(false, "Firestore Delete Error: \(error.localizedDescription)")
                } else {
                    print("✅ Trip successfully deleted from Firestore")
                    completion(true, nil)
                }
            }
        }
    
    
    func fetchDriver(driverID: String, completion: @escaping (Driver?) -> Void) {
        db.collection("drivers").whereField("id", isEqualTo: driverID).getDocuments { snapshot, error in
            if let error = error {
                print("❌ Firestore Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let document = snapshot?.documents.first, let data = document.data() as? [String: Any] else {
                print("❌ Driver not found for ID: \(driverID)")
                completion(nil)
                return
            }

            print("✅ Firestore Data Fetched: \(data)")
            let driver = Driver(
                id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                name: data["name"] as? String ?? "Unknown",
                age: data["age"] as? String ?? "",
                address: data["address"] as? String ?? "",
                mobileNumber: data["mobileNumber"] as? String ?? "",
                driverStatus: .available,
                email: data["email"] as? String ?? "",
                licenseID: data["licenseID"] as? String ?? "",
                vehicleType: [],
                totalTrips: data["totalTrips"] as? Int ?? 0,
                experienceInYears: data["experienceInYears"] as? Int ?? 0,
                istanceTraveled: data["istanceTraveled"] as? String ?? "0 km"
            )

            print("✅ Driver Object Created: \(driver.name)")
            completion(driver)
        }
    }




        // MARK: - Fetch Driver Trips
        func fetchDriverTrips(driverName: String, completion: @escaping ([Trip]) -> Void) {
            db.collection("trips").whereField("driver", isEqualTo: driverName).getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }

                let trips = documents.compactMap { doc -> Trip? in
                    let data = doc.data()
                    return Trip(
                      id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                      startLocation: data["startLocation"] as? String ?? "",
                      endLocation: data["endLocation"] as? String ?? "",
                      vehicleType: data["vehicleType"] as? VehicleType ?? .car,
                      vehicleID: data["vehicleID"] as? String ?? "",
                      eta: data["eta"] as? String ?? "",
                      distance: data["distance"] as? String ?? "",
                      startDate: Date(timeIntervalSince1970: data["startDate"] as? TimeInterval ?? 0),
                      endDate: Date(timeIntervalSince1970: data["endDate"] as? TimeInterval ?? 0), // ✅ Corrected from startDate to endDate
                      driver: data["driver"] as? String ?? "",
                      status: data["status"] as? String ?? "Pending" // ✅ Safely unwrap status
                    )
                }
                completion(trips)
            }
        }
     
    func fetchUpcomingTripsForDriver(driverID: String, completion: @escaping ([Trip]) -> Void) {
        db.collection("trips")
            .whereField("driver", isEqualTo: driverID) // Ensure this field matches Firestore structure
            .order(by: "startDate", descending: false)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("❌ Firestore Fetch Trips Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }

                let trips = documents.compactMap { doc -> Trip? in
                    let data = doc.data()
                    return Trip(
                        id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                        startLocation: data["startLocation"] as? String ?? "",
                        endLocation: data["endLocation"] as? String ?? "",
                        vehicleType: data["vehicleType"] as? VehicleType ?? .car,
                        vehicleID: data["vehicleID"] as? String ?? "",
                        eta: data["eta"] as? String ?? "",
                        distance: data["distance"] as? String ?? "",
                        startDate: Date(timeIntervalSince1970: data["startDate"] as? TimeInterval ?? 0),
                        endDate: Date(timeIntervalSince1970: data["endDate"] as? TimeInterval ?? 0),
                        driver: data["driver"] as? String ?? "",
                        status: data["status"] as? String ?? "Pending"
                    )
                }
                print("✅ Found \(trips.count) upcoming trips for driver \(driverID)")
                completion(trips)
            }
    }


    func addTrip(trip: Trip, completion: @escaping (Bool, String?) -> Void) {
            let tripData: [String: Any] = [
              "id": trip.id.uuidString,
              "startLocation": trip.startLocation,
              "endLocation": trip.endLocation,
              "vehicleType": trip.vehicleType,
              "vehicleID": trip.vehicleID,
              "eta": trip.eta,
              "distance": trip.distance,
              "startDate": trip.startDate.timeIntervalSince1970, // ✅ Store as timestamp
              "endDate": trip.endDate.timeIntervalSince1970,
              "driver": trip.driver,
              "status": trip.status // ✅ Ensure trip status is stored
            ]

            db.collection("trips").document(trip.id.uuidString).setData(tripData) { error in
                if let error = error {
                    print("❌ Failed to add trip: \(error.localizedDescription)")
                    completion(false, error.localizedDescription)
                } else {
                    print("✅ Trip successfully added to Firestore")
                    completion(true, nil)
                }
            }
        }
    
    
    func updateTripStatus(tripID: String, newStatus: String, completion: @escaping (Bool, Error?) -> Void) {
            let db = Firestore.firestore()
            db.collection("trips").document(tripID).updateData(["status": newStatus]) { error in
                if let error = error {
                    print("❌ Error updating trip status: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    print("✅ Trip status updated to \(newStatus)")
                    completion(true, nil)
                }
            }
        }
    
    
    func addInventoryItem(_ item: InventoryItem, completion: @escaping (Bool, Error?) -> Void) {
            do {
                let _ = try db.collection("inventory").addDocument(from: item) { error in
                    if let error = error {
                        print("❌ Error adding inventory item: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("✅ Inventory item added successfully")
                        completion(true, nil)
                    }
                }
            } catch {
                print("❌ Error encoding inventory item: \(error.localizedDescription)")
                completion(false, error)
            }
        }

        // 🔥 Fetch Inventory Items from Firestore (Real-Time Updates)
        func fetchInventoryItems(completion: @escaping ([InventoryItem]) -> Void) {
            db.collection("inventory").addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("❌ Error fetching inventory: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }

                let items = documents.compactMap { doc -> InventoryItem? in
                    try? doc.data(as: InventoryItem.self)
                }

                DispatchQueue.main.async {
                    completion(items)
                }
            }
        }
    
    func updateInventoryItem(id: String, newQuantity: Int, completion: @escaping (Bool, Error?) -> Void) {
            let itemRef = db.collection("inventory").document(id)
            
            itemRef.updateData(["quantity": newQuantity]) { error in
                if let error = error {
                    print("❌ Firestore update error: \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    
    
    func fetchAvailableVehicles(completion: @escaping ([Vehicle]) -> Void) {
            db.collection("vehicles")
//                .whereField("status", isEqualTo: "Available")
                .addSnapshotListener { snapshot, error in
                    guard let documents = snapshot?.documents, error == nil else {
                        print("❌ Error fetching vehicles: \(error?.localizedDescription ?? "Unknown error")")
                        completion([])
                        return
                    }

                    let vehicles = documents.compactMap { doc -> Vehicle? in
                        try? doc.data(as: Vehicle.self)
                    }

                    DispatchQueue.main.async {
                        completion(vehicles)
                    }
                }
        }
        
        
    func checkIfMaintenanceRequestExists(vehicleID: String, completion: @escaping (Bool, String?) -> Void) {
            let db = Firestore.firestore()
            
            db.collection("maintenanceRequests")
                .whereField("vehicleID", isEqualTo: vehicleID)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("❌ Error fetching maintenance requests: \(error.localizedDescription)")
                        completion(false, nil)
                        return
                    }

                    if let documents = snapshot?.documents, !documents.isEmpty {
                        let status = documents.first?["status"] as? String ?? "Pending"
                        completion(true, status)
                    } else {
                        completion(false, nil)
                    }
                }
        }
        // 🔥 Submit Maintenance Request to Firestore
        func submitMaintenanceRequest(_ request: MaintenanceRequestModel, completion: @escaping (Bool) -> Void) {
            checkIfMaintenanceRequestExists(vehicleID: request.vehicleID) { exists, _ in
                if exists {
                    print("⚠️ A request already exists for this vehicle!")
                    completion(false)
                    return
                }

                do {
                    let docRef = self.db.collection("maintenanceRequests").document(request.id)
                    try docRef.setData(from: request) { error in
                        if let error = error {
                            print("❌ Firestore Write Error: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("✅ Successfully saved maintenance request for \(request.vehicleID)")
                            completion(true)
                        }
                    }
                } catch {
                    print("❌ Firestore Encoding Error: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }

        // 🔥 Fetch Maintenance Requests (Convert String back to UUID)
    func fetchMaintenanceRequests(completion: @escaping ([MaintenanceRequestModel]) -> Void) {
        db.collection("maintenanceRequests").addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Error fetching maintenance requests: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let documents = snapshot?.documents else {
                print("❌ No maintenance request documents found.")
                completion([])
                return
            }

            var requests: [MaintenanceRequestModel] = []

            for document in documents {
                let data = document.data()
                let id = document.documentID
                let vehicleID = data["vehicleID"] as? String ?? "N/A"
                let vehicleName = data["vehicleName"] as? String ?? "Unknown"
                let dueDate = (data["dueDate"] as? Timestamp)?.dateValue() ?? Date()
                let serviceType = data["serviceType"] as? String ?? "Not Provided"
                let estimatedCost = data["estimatedCost"] as? String ?? "0"
                let status = data["status"] as? String ?? "Pending"

                let request = MaintenanceRequestModel(
                    id: id,
                    vehicleID: vehicleID,
                    vehicleName: vehicleName,
                    dueDate: dueDate,
//                    serviceType: serviceType,
//                    estimatedCost: estimatedCost,
                    status: status,
                    serviceType: serviceType
                )

                requests.append(request)
            }

            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }

    func updateMaintenanceRequestStatus(requestID: String, newStatus: String, completion: @escaping (Bool) -> Void) {
        let requestRef = db.collection("maintenanceRequests").document(requestID)

        requestRef.updateData(["status": newStatus]) { error in
            if let error = error {
                print("❌ Error updating maintenance request status: \(error.localizedDescription)")
                completion(false)
            } else {
                print("✅ Maintenance request status updated to \(newStatus)")
                completion(true)
            }
        }
    }

    
    
    func updateDriverAvailability(driverID: String, isAvailable: Bool, completion: @escaping (Bool, String?) -> Void) {
        let status = isAvailable ? "available" : "unavailable"
        let driverRef = db.collection("drivers").document(driverID)

        // 🔍 First, check if the document exists
        driverRef.getDocument { document, error in
            if let document = document, document.exists {
                // ✅ If it exists, update the status
                driverRef.updateData(["driverStatus": status]) { error in
                    if let error = error {
                        print("❌ Firestore Update Error: \(error.localizedDescription)")
                        completion(false, error.localizedDescription)
                    } else {
                        print("✅ Driver availability updated to \(status) in Firestore")
                        completion(true, nil)
                    }
                }
            } else {
                // ❌ If document doesn't exist, print an error
                print("❌ Error: No driver found with ID \(driverID). Cannot update availability.")
                completion(false, "No driver found.")
            }
        }
    }

    
    func removeInventoryItem(_ item: InventoryItem, completion: @escaping (Bool, Error?) -> Void) {
            let db = Firestore.firestore()
            db.collection("inventory").document(item.id).delete { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    
    
}
