//
//  TripViewModel.swift
//  FMS
//
//  Created by Kanishq Mehta on 16/02/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class TripViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var activeTrips: [Trip] = []
    private let db = Firestore.firestore()
    
    init() { fetchTrips() }

    // MARK: - Add Trip to Firestore
    func addTrip(_ trip: Trip) {
        FirestoreService.shared.saveTrip(trip: trip) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.trips.append(trip)
                }
            }
        }
    }

    // MARK: - Update Trip in Firestore
    func updateTrip(_ updatedTrip: Trip) {
        FirestoreService.shared.saveTrip(trip: updatedTrip) { success, error in
            if success {
                DispatchQueue.main.async {
                    if let index = self.trips.firstIndex(where: { $0.id == updatedTrip.id }) {
                        self.trips[index] = updatedTrip
                    }
                }
            }
        }
    }

    // MARK: - Fetch Trips from Firestore
//    func fetchTrips() {
//        db.collection("trips")
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print("❌ Error fetching trips: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let documents = snapshot?.documents else {
//                    print("❌ No trips found.")
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    self.trips = documents.compactMap { document in
//                        try? document.data(as: Trip.self)
//                    }
//                    // Update active trips as well
//                    self.activeTrips = self.trips.filter { $0.status == "active" }
//                    print("✅ Loaded \(self.trips.count) trips (\(self.activeTrips.count) active)")
//                }
//            }
//    }
    func fetchTrips() {
        Firestore.firestore().collection("trips")
            .order(by: "startDate", descending: false) // Sort by upcoming trips
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching trips: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("❌ No trips found.")
                    return
                }

                DispatchQueue.main.async {
                    self.trips = documents.compactMap { document in
                        try? document.data(as: Trip.self)
                    }
                    print("✅ Loaded \(self.trips.count) trips")
                }
            }
    }


    // MARK: - Delete Trip from Firestore
    func deleteTrip(_ trip: Trip) {
        FirestoreService.shared.deleteTrip(tripID: trip.id.uuidString) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.trips.removeAll { $0.id == trip.id }
                }
            }
        }
    }
    
    
    // MARK: - Update Only Trip Status in Firestore
//    func updateTripStatus(tripID: String, newStatus: String) {
//        let db = Firestore.firestore()
//        
//        db.collection("trips").document(tripID).updateData(["status": newStatus]) { error in
//            if let error = error {
//                print("❌ Error updating trip status: \(error.localizedDescription)")
//            } else {
//                print("✅ Trip status updated to \(newStatus)")
//                
//                // ✅ Update Local State
//                DispatchQueue.main.async {
//                    if let index = self.trips.firstIndex(where: { $0.id.uuidString == tripID }) {
//                        self.trips[index].status = newStatus
//                    }
//                }
//            }
//        }
//    }
    func updateTripStatus(tripID: String, newStatus: String, completion: (() -> Void)? = nil) {
        let db = Firestore.firestore()
        
        db.collection("trips").document(tripID).updateData(["status": newStatus]) { error in
            if let error = error {
                print("❌ Error updating trip status: \(error.localizedDescription)")
            } else {
                print("✅ Trip status updated to \(newStatus)")
                
                DispatchQueue.main.async {
                    if let index = self.trips.firstIndex(where: { $0.id.uuidString == tripID }) {
                        self.trips[index].status = newStatus
                    }
                }
                
                // ✅ If trip is completed, update vehicle's total trips
                if newStatus == "Completed" {
                    self.incrementVehicleTotalTrips(tripID: tripID, completion: completion)
                } else {
                    completion?() // Call completion if provided
                }
            }
        }
    }
    private func incrementVehicleTotalTrips(tripID: String, completion: (() -> Void)? = nil) {
        let db = Firestore.firestore()

        db.collection("trips").document(tripID).getDocument { snapshot, error in
            guard let tripData = snapshot?.data(), let vehicleID = tripData["vehicleID"] as? String else {
                print("❌ Error retrieving vehicle ID for trip \(tripID)")
                return
            }

            let vehicleRef = db.collection("vehicles").document(vehicleID)

            db.runTransaction { transaction, errorPointer in
                let vehicleSnapshot: DocumentSnapshot
                do {
                    try vehicleSnapshot = transaction.getDocument(vehicleRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                guard let totalTrips = vehicleSnapshot.data()?["totalTrips"] as? Int else { return nil }

                let newTotalTrips = totalTrips + 1
                transaction.updateData(["totalTrips": newTotalTrips], forDocument: vehicleRef)

                return nil
            } completion: { _, error in
                if let error = error {
                    print("❌ Failed to update vehicle totalTrips: \(error)")
                } else {
                    print("✅ Successfully incremented totalTrips for vehicle \(vehicleID)")
                    completion?() // ✅ Refresh dashboard after updating totalTrips
                }
            }
        }
    }


    func fetchActiveTrips() {
            db.collection("trips")
            /*.whereField("status", isEqualTo: "active")*/ // ✅ Only fetch active trips
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("❌ Error fetching active trips: \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        print("❌ No active trips found.")
                        return
                    }

                    DispatchQueue.main.async {
                        self.activeTrips = documents.compactMap { document in
                            try? document.data(as: Trip.self)
                        }
                        print("✅ Loaded \(self.activeTrips.count) active trips")
                    }
                }
        }

}
