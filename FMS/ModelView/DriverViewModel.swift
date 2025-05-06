import FirebaseFirestore
import FirebaseAuth
class DriverViewModel: ObservableObject {
    @Published var drivers: [Driver] = []
    @Published var driver: Driver?
    @Published var trips: [Trip] = []
    private let db = Firestore.firestore()
    
    init() {
        fetchDrivers()
    }

    func addDriver(_ driver: Driver) {
        FirestoreService.shared.addDriver(driver) { error in
            if let error = error {
                print("❌ Error adding driver: \(error.localizedDescription)")
            } else {
                self.fetchDrivers()
            }
        }
    }

    func fetchDrivers() {
        FirestoreService.shared.fetchDrivers { fetchedDrivers in
            DispatchQueue.main.async {
                self.drivers = fetchedDrivers
                print("✅ Driver list updated from Firestore with \(fetchedDrivers.count) drivers.")
            }
        }
    }


    func deleteDriver(_ driver: Driver) {
        FirestoreService.shared.deleteDriver(driverID: driver.id.uuidString) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.drivers.removeAll { $0.id == driver.id }
                    
                }
            }
        }
    }

//    func loadDriver(driverID: String) {
//            FirestoreService.shared.fetchDriver(driverID: driverID) { [weak self] fetchedDriver in
//                DispatchQueue.main.async {
//                    self?.driver = fetchedDriver
//                }
//            }
//        }

    func loadTrips(driverID: String) {
        FirestoreService.shared.fetchUpcomingTripsForDriver(driverID: driverID) { trips in
            DispatchQueue.main.async {
                self.trips = trips
                print("✅ Loaded \(trips.count) upcoming trips for driver \(driverID)")
            }
        }
    }

    // 🔹 Update Driver Availability
    func updateAvailability(isAvailable: Bool) {
        guard let driverID = driver?.id.uuidString else {
            print("❌ Error: Driver ID is nil")
            return
        }

        print("🔄 Updating driver \(driverID) to \(isAvailable ? "Available" : "Unavailable")")

        FirestoreService.shared.updateDriverAvailability(driverID: driverID, isAvailable: isAvailable) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.driver?.driverStatus = isAvailable ? .available : .unavailable
                }
                print("✅ Driver availability updated in Firestore")
            } else if let error = error {
//                print("❌ Error updating availability: \(error.localizedDescription)")
            }
        }
    }

    func acceptTrip(trip: Trip) {
        FirestoreService.shared.addTrip(trip: trip) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.trips.append(trip)
                }
            }
        }
    }
    
//    func fetchTrips() {
//        FirestoreService.shared.fetchTrips { trips in
//            DispatchQueue.main.async {
//                self.trips = trips.map { trip in
//                    var modifiedTrip = trip
//                    if modifiedTrip.status.isEmpty { // ✅ Ensuring default status
//                        modifiedTrip.status = "Pending"
//                    }
//                    return modifiedTrip
//                }
//            }
//        }
//    }

    func fetchTrips() {
        FirestoreService.shared.fetchTrips { trips in
            DispatchQueue.main.async {
                self.trips = trips
            }
        }
    }
//    
//    func updateTripStatus(tripID: String, newStatus: String) {
//            FirestoreService.shared.updateTripStatus(tripID: tripID, newStatus: newStatus) { success, error in
//                if success {
//                    DispatchQueue.main.async {
//                        if let index = self.trips.firstIndex(where: { $0.id.uuidString == tripID }) {
//                            self.trips[index].status = newStatus
//                        }
//                    }
//                }
//            }
//        }
//    
    
    
//    func loadCurrentDriver() {
//            guard let userID = Auth.auth().currentUser?.uid else {
//                print("❌ No user is logged in")
//                return
//            }
//            
//            print("✅ Fetching Driver for User ID: \(userID)") // ✅ DEBUG
//
//            FirestoreService.shared.fetchDriver(driverID: userID) { [weak self] fetchedDriver in
//                DispatchQueue.main.async {
//                    if let driver = fetchedDriver {
//                        print("✅ Driver Fetched: \(driver.name)") // ✅ DEBUG
//                    } else {
//                        print("❌ Driver Not Found in Firestore")
//                    }
//                    self?.driver = fetchedDriver
//                }
//            }
//        }
    func loadCurrentDriver() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("❌ No user is logged in")
            return
        }
        
        print("✅ Logged in Firebase User ID: \(userID)") // ✅ Check what ID is used
        fetchDriverFromFirestore(driverID: userID)
    }


    func fetchDriverFromFirestore(driverID: String) {
        FirestoreService.shared.fetchDriver(driverID: driverID) { [weak self] fetchedDriver in
            DispatchQueue.main.async {
                if let driver = fetchedDriver {
                    print("✅ Driver Found: \(driver.name)")
                } else {
                    print("❌ No Driver Found in Firestore")
                }
                self?.driver = fetchedDriver
            }
        }
    }
    
    func updateTripStatus(tripID: String, newStatus: String) {
            let db = Firestore.firestore()
            let tripRef = db.collection("trips").document(tripID)

            tripRef.updateData(["status": newStatus]) { error in
                if let error = error {
                    print("❌ Firestore Update Error: \(error.localizedDescription)")
                } else {
                    print("✅ Trip status updated to \(newStatus) in Firestore")
                    self.fetchTrips()
                }
            }
        }

    
}
