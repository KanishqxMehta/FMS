import SwiftUI

struct DriverTripsView: View {
    @StateObject private var tripViewModel = TripViewModel()
    @State private var selectedSegment = "Ongoing"
    let segments = ["Ongoing", "Upcoming", "Completed"]
    
    var filteredTrips: [Trip] {
        switch selectedSegment {
        case "Upcoming":
            return tripViewModel.trips.filter { $0.status == "Accepted" }
        case "Completed":
            return tripViewModel.trips.filter { $0.status == "Completed" }
        default:
            return tripViewModel.trips.filter { $0.status == "Started" }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Trip Type", selection: $selectedSegment) {
                    ForEach(segments, id: \.self) { segment in
                        Text(segment)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ScrollView {
                    VStack(spacing: 10) {
                        if filteredTrips.isEmpty {
                            Text("No \(selectedSegment.lowercased()) trips available.")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                        } else {
                            ForEach(filteredTrips) { trip in
                                TripCard(trip: trip, tripViewModel: tripViewModel)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Trips")
            .onAppear {
                tripViewModel.fetchTrips() // Fetch latest trip data
            }
        }
    }
}

#Preview {
    DriverTripsView()
}
