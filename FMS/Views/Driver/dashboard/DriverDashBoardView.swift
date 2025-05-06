import SwiftUI

struct MainDriverView: View {
    var body: some View {
        TabView {
            DriverDashBoardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            DriverTripsView()
                .tabItem {
                    Label("Trips", systemImage: "car.fill")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DriverDashBoardView: View {
    @StateObject private var tripViewModel = TripViewModel()
    @StateObject private var driverViewModel = DriverViewModel()
    @State private var isSettingsPresented = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 20) {
                        InfoCard(icon: "car.fill", title: "Total Trips", value: "\(tripViewModel.trips.count)")
                        InfoCard(
                            icon: "bolt.fill",
                            title: "Total Distance",
                            value: String(format: "%.1f km", tripViewModel.trips.reduce(0) {
                                $0 + (Double($1.distance.replacingOccurrences(of: " km", with: "")) ?? 0)
                            })
                        )

                    }
                    
                    Text("Upcoming Trips")
                        .font(.title2).bold()
                    
                    VStack(spacing: 15) {
                        ForEach(tripViewModel.trips) { trip in
                            TripCard(trip: trip, tripViewModel: tripViewModel)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("Driver Dashboard")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: Button(action: {
                isSettingsPresented.toggle()
            }) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(.black)
            })
            .sheet(isPresented: $isSettingsPresented) {
                DriverSettingView(viewModel: driverViewModel, driverName: driverViewModel.driver?.name ?? "Naman")
            }
            .onAppear {
                tripViewModel.fetchTrips() // ✅ Fetch the latest trips from Firestore
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - TripCard
struct TripCard: View {
    var trip: Trip
    @ObservedObject var tripViewModel: TripViewModel
    @State private var tripStatus: String
    @State private var showStartTripAlert = false
    @State private var showEndTripAlert = false

    init(trip: Trip, tripViewModel: TripViewModel) {
        self.trip = trip
        self.tripViewModel = tripViewModel
        _tripStatus = State(initialValue: trip.status) // ✅ Load status from Firestore
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(trip.vehicleType.rawValue)
                .bold()
                .foregroundColor(.white)
                .padding(.vertical, 2)
                .padding(.horizontal, 5)
                .background(Color.black)
                .cornerRadius(5)

            Text("\(trip.startLocation) - \(trip.endLocation)").font(.headline)
            Text("Start Time: \(trip.startDate, formatter: timeFormatter)").foregroundColor(.gray)

            HStack {
                Text("Departure: \(trip.startDate.formatted())")
                Spacer()
                Text("ETA: \(trip.eta)")
            }
            .font(.caption)
            .foregroundColor(.gray)

            HStack(spacing: 20) {
                if tripStatus == "Pending" {
                    Button("Accept") {
                        updateTripStatus(newStatus: "Accepted")
                    }
                    .buttonStyle(TripButtonStyle(color: .black))

                    Button("Reject") {
                        updateTripStatus(newStatus: "Declined")
                    }
                    .buttonStyle(TripButtonStyle(color: .red))
                } else if tripStatus == "Accepted" {
                    Button("Start Trip") {
                        showStartTripAlert = true
                    }
                    .buttonStyle(TripButtonStyle(color: .blue))
                    .alert("Start Trip", isPresented: $showStartTripAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Start") {
                            updateTripStatus(newStatus: "Started")
                        }
                    }
                } else if tripStatus == "Declined" {
                    Text("Trip Declined")
                        .font(.headline)
                        .foregroundColor(.red)
                } else if tripStatus == "Started" {
                    Button("End Trip") {
                        showEndTripAlert = true
                    }
                    .buttonStyle(TripButtonStyle(color: .green))
                    .alert("End Trip", isPresented: $showEndTripAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("End") {
                            updateTripStatus(newStatus: "Completed")
                        }
                    }

                    Text("Trip Started")
                        .font(.headline)
                        .foregroundColor(.blue)
                } else if tripStatus == "Completed" {
                    Text("Trip Completed")
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }

    // MARK: - Update Trip Status in Firestore
    private func updateTripStatus(newStatus: String) {
        tripStatus = newStatus // ✅ Update local state immediately
        tripViewModel.updateTripStatus(tripID: trip.id.uuidString, newStatus: newStatus) // ✅ Update Firestore
    }
}

// MARK: - Date Formatter
private var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a" // Format: 12-hour with AM/PM
    return formatter
}

// MARK: - Custom Button Style for Trip Actions
struct TripButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// MARK: - InfoCard
struct InfoCard: View {
    var icon: String
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(8)
                Spacer()
                Text(value)
                    .font(.title2).bold()
            }
            .padding(.vertical, 3)
            Text(title)
                .font(.callout)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    MainDriverView()
}
