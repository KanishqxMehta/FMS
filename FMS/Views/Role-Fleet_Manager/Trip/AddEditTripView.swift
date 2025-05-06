import SwiftUI
import MapKit
import FirebaseFirestore

struct AddEditTripView: View {
    @ObservedObject var tripViewModel: TripViewModel
    @ObservedObject var vehicleViewModel = VehicleViewModel()
    @ObservedObject var driverViewModel = DriverViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var trip: Trip
    @State private var selectedDriverID: String = "" // Stores selected driver ID
    @State private var selectedVehicleID: String = "" // Stores selected Vehicle ID
    @State private var route: MKRoute?
    @State private var vehicleType: VehicleType = .car
    
    var isEndDateValid: Bool {
        trip.endDate > trip.startDate
    }

    var isFormValid: Bool {
        !trip.startLocation.isEmpty &&
        !trip.endLocation.isEmpty &&
        !selectedVehicleID.isEmpty &&  // Check selectedVehicleID instead of trip.vehicleID
        !trip.eta.isEmpty &&
        !trip.distance.isEmpty &&
        !selectedDriverID.isEmpty
    }

    init(tripViewModel: TripViewModel, trip: Trip?) {
        self.tripViewModel = tripViewModel
        _trip = State(initialValue: trip ?? Trip(startLocation: "", endLocation: "", vehicleType: .car, vehicleID: "", eta: "", distance: "", startDate: Date(), endDate: Date(), driver: ""))
        _selectedDriverID = State(initialValue: trip?.driver ?? "")
        _selectedVehicleID = State(initialValue: trip?.vehicleID ?? "")  // Add this line
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location Details").bold()) {
                    TextField("Enter start location", text: $trip.startLocation, onCommit: fetchRoute)
                    
                    TextField("Enter end location", text: $trip.endLocation, onCommit: fetchRoute)
                        .onChange(of: trip.endLocation) {
                            fetchRoute() // Trigger route calculation
                            updateEndDate() // Auto-update end date
                        }
                }

                Section(header: Text("Vehicle Information").bold()) {
                    Picker("Vehicle Type", selection: $trip.vehicleType) {
                        ForEach(VehicleType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    let filteredVehicles = vehicleViewModel.vehicles.filter { $0.status == .available && $0.vehicleType == trip.vehicleType }

                    if filteredVehicles.isEmpty {
                        Text("No available vehicles of this type").foregroundColor(.gray)
                    } else {
                        Picker("Select Vehicle", selection: $selectedVehicleID) {
                            ForEach(filteredVehicles) { vehicle in
                                Text(vehicle.vehicleName).tag(vehicle.id.uuidString)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onAppear {
                            if selectedVehicleID.isEmpty, let firstVehicle = filteredVehicles.first {
                                selectedVehicleID = firstVehicle.id.uuidString
                            }
                        }
                    }
                }

                Section(header: Text("Trip Details").bold()) {
                    TextField("ETA (min)", text: $trip.eta).disabled(true)
                    TextField("Distance (km)", text: $trip.distance).disabled(true)
                }
                
                Section(header: Text("Schedule").bold()) {
                    DatePicker("Start Date", selection: $trip.startDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                        .onChange(of: trip.startDate) { updateEndDate() }

                    DatePicker("End Date", selection: $trip.endDate, displayedComponents: [.date, .hourAndMinute])
                        .disabled(true) // Prevent user editing
                }

                Section(header: Text("Assign Driver").bold()) {
                    if driverViewModel.drivers.isEmpty {
                        Text("No available drivers").foregroundColor(.gray)
                    } else {
                        Picker("Select Driver", selection: $selectedDriverID) {
                            ForEach(driverViewModel.drivers.filter { $0.driverStatus == .available }) { driver in
                                Text(driver.name).tag(driver.id.uuidString) // Display name, store ID
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Use a pop-up menu style
                    }
                }
            }
            .navigationTitle(tripViewModel.trips.contains(where: { $0.id == trip.id }) ? "Edit Trip" : "New Trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTripToFirestore()
                    }
                    .disabled(!isFormValid)
                }
            }
            .onAppear {
                driverViewModel.fetchDrivers()
            }
        }
    }
    
    func updateEndDate() {
        guard let etaMinutes = Int(trip.eta.replacingOccurrences(of: " min", with: "")) else { return }
        trip.endDate = Calendar.current.date(byAdding: .minute, value: etaMinutes, to: trip.startDate) ?? trip.startDate
    }

    func fetchRoute() {
        guard !trip.startLocation.isEmpty, !trip.endLocation.isEmpty else { return }
        
        let startRequest = MKLocalSearch.Request()
        startRequest.naturalLanguageQuery = trip.startLocation
        let startSearch = MKLocalSearch(request: startRequest)
        startSearch.start { startResponse, _ in
            guard let startCoordinate = startResponse?.mapItems.first?.placemark.coordinate else { return }
            
            let endRequest = MKLocalSearch.Request()
            endRequest.naturalLanguageQuery = trip.endLocation
            let endSearch = MKLocalSearch(request: endRequest)
            endSearch.start { endResponse, _ in
                guard let endCoordinate = endResponse?.mapItems.first?.placemark.coordinate else { return }
                
                let startPlacemark = MKPlacemark(coordinate: startCoordinate)
                let endPlacemark = MKPlacemark(coordinate: endCoordinate)
                
                let directionRequest = MKDirections.Request()
                directionRequest.source = MKMapItem(placemark: startPlacemark)
                directionRequest.destination = MKMapItem(placemark: endPlacemark)
                directionRequest.transportType = .automobile
                
                let directions = MKDirections(request: directionRequest)
                directions.calculate { response, _ in
                    guard let route = response?.routes.first else { return }
                    self.route = route
                    trip.distance = "\(String(format: "%.2f", route.distance / 1000)) km"
                    trip.eta = "\(String(format: "%.0f", route.expectedTravelTime / 60)) min"
                }
            }
        }
    }
    
    func saveTripToFirestore() {
        trip.driver = selectedDriverID
        trip.vehicleID = selectedVehicleID
        
//         Get the driver's name from the selected driver
        let driverName = driverViewModel.drivers.first(where: { $0.id.uuidString == selectedDriverID })?.name ?? "Unknown Driver"
        
        let tripData: [String: Any] = [
            "id": trip.id.uuidString,
            "startLocation": trip.startLocation,
            "endLocation": trip.endLocation,
            "vehicleType": trip.vehicleType.rawValue,
            "vehicleID": trip.vehicleID,
            "eta": trip.eta,
            "distance": trip.distance,
            "startDate": trip.startDate,
            "endDate": trip.endDate,
            "driver": trip.driver,
            "driverName": driverName,
            "status": trip.status
        ]
        
        Firestore.firestore().collection("trips").document(trip.id.uuidString).setData(tripData) { error in
            if let error = error {
                print("❌ Error saving trip: \(error.localizedDescription)")
            } else {
                print("✅ Trip saved successfully")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MARK: - Preview
struct AddEditTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditTripView(tripViewModel: TripViewModel(), trip: nil)
    }
}

