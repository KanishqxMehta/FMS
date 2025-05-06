import SwiftUI

struct TripDetailsView: View {
    let trip: Trip
    @StateObject private var vehicleViewModel = VehicleViewModel()
    @StateObject private var driverViewModel = DriverViewModel()
    @State private var vehicleName: String = "Loading..."
    @State private var driverName: String = "Loading..."

    @State private var showEditSheet = false
    @State private var needsRefresh = false
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    VStack(spacing: 15) {
                        // Trip Information Card
                        VStack {
                            RouteMapView(startAddress: trip.startLocation, endAddress: trip.endLocation)
                                .frame(height: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            HStack {
                                Image(systemName: "car.2")
                                    .foregroundColor(.gray)
                                Text(trip.startLocation)
                                    .foregroundColor(.gray)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.gray)
                                Text(trip.endLocation)
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                                Text(formattedDate(trip.startDate))
                                    .foregroundColor(.gray)
                            }
                            .padding()

                            // Line connecting locations
                            HStack {
                                LineView()
                                    .padding(.horizontal)
                            }

                            VStack(alignment: .leading) {
                                HStack {
                                    Text(trip.startLocation)
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(formattedTime(trip.startDate))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Text("Departure Address: \(trip.startLocation)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .padding(.leading, 8)

                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 30)
                                Text(trip.eta)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)

                            VStack(alignment: .leading) {
                                HStack {
                                    Text(trip.endLocation)
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(formattedTime(trip.endDate))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Text("Destination Address: \(trip.endLocation)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .padding(.leading, 8)
                        }
                        .background(.white)
                        .cornerRadius(10)
                        .padding()
                        .shadow(radius: 2)

                        // Vehicle Assigned
                        InfoCardView(
                            title: "Vehicle Assigned",
                            primaryText: vehicleName,
                            info: [
                                ("Type", trip.vehicleType.rawValue),
                                ("Distance Travelled", trip.distance),
                                ("Estimated Time", trip.eta),
                                ("Start Date", formattedDate(trip.startDate)),
                                ("End Date", formattedDate(trip.endDate))
                            ]
                        )

                        // Driver Assigned
                        InfoCardView(
                            title: "Driver Assigned",
                            primaryText: driverName,
                            info: [
                                ("Total Trips", "20"), // You might replace this with actual data
                                ("Distance Travelled", trip.distance)
                            ]
                        )
                    }
                    .padding(.bottom, 20) // Prevents content cutoff at the bottom
                }

            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showEditSheet = true
                }) {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AddEditTripView(tripViewModel: TripViewModel(), trip: trip)
                .onDisappear {
                    // Trigger refresh when sheet is dismissed
                    needsRefresh = true
                }
        }
        .onChange(of: needsRefresh) {
            if needsRefresh {
                refreshData()
                needsRefresh = false
            }
        }
        .onAppear {
            refreshData()
        }
    }
    
    private func refreshData() {
            // Fetch fresh data first
            vehicleViewModel.fetchVehicles()
            driverViewModel.fetchDrivers()
            
            // Add a slight delay to ensure data is loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Then update the names
                if let vehicle = vehicleViewModel.vehicles.first(where: { $0.id.uuidString == trip.vehicleID }) {
                    vehicleName = vehicle.vehicleName
                } else {
                    vehicleName = "Unknown Vehicle"
                }
                
                if let driver = driverViewModel.drivers.first(where: { $0.id.uuidString == trip.driver }) {
                    driverName = driver.name
                } else {
                    driverName = "Unknown Driver"
                }
            }
        }
    }

    // Format Date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    // Format Time
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // e.g., 10:45 AM
        return formatter.string(from: date)
    }


// Preview
struct TripDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TripDetailsView(trip: Trip(
            startLocation: "Delhi",
            endLocation: "Chandigarh",
            vehicleType: .car,
            vehicleID: "967F906A-B603-4163-B30B-CC13FB65EEE8",
            eta: "12 hr 19 min",
            distance: "1400.25 km",
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .hour, value: 12, to: Date())!,
            driver: "83DF762A-CEC5-4E88-AEC4-001E9268F9BF"
        ))
    }
}
