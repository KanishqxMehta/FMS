import SwiftUI

struct FleetManagerDashboard: View {
    
    @StateObject private var vehicleViewModel = VehicleViewModel()  // ✅ Use instance
        @StateObject private var driverViewModel = DriverViewModel()
    @StateObject private var tripViewModel = TripViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    HStack(spacing: 20) {
                        StatsCard(icon: "car.2.fill", value: "\(vehicleViewModel.vehicles.count)", label: "Total Vehicles")
                        StatsCard(icon: "person.2.fill", value: "\(driverViewModel.drivers.count)", label: "Total Drivers")
                    }
                    
                    TripManagementCard_Fleet()
                    
                    ActiveTripsView(trips: tripViewModel.activeTrips)
                }
                .navigationTitle("Fleet") // ✅ Now title will show
                .padding(.horizontal)
                .onAppear {
                                    vehicleViewModel.fetchVehicles()   // ✅ Fetch latest vehicle count
                                    driverViewModel.fetchDrivers()     // ✅ Fetch latest driver count
                                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct TripManagementCard_Fleet: View {
    @State private var isPresented = false
    @StateObject var viewModel = TripViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Trip Management")
                        .font(.headline)
                        .bold()
                    Text("Create and manage your fleet trips")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                isPresented.toggle()
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.title2)
                    Text("Create New Trip")
                        .font(.title2)
                        .bold()
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.black)
                .cornerRadius(10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 3)
        }
        .sheet(isPresented: $isPresented) {
          AddEditTripView(tripViewModel: viewModel, trip: nil)
        }
    }
}

struct ActiveTripsView: View {
    let trips: [Trip]
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Active Trips")
                        .font(.title3)
                        .bold()
                    Text("Monitor your ongoing fleet operations")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack {
                    Text("\(trips.count)")  // Display total number of active trips
                        .bold()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            
            // TabView restricted to max 3 trips
            TabView(selection: $currentIndex) {
                ForEach(0..<min(trips.count, 3), id: \.self) { index in
                    TripCardView(trip: trips[index]) // ✅ Use TripCardView
                        .tag(index)
                }
            }
            .frame(height: 200)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Page Indicator Dots (Limited to 3)
            HStack(spacing: 6) {
                ForEach(0..<min(trips.count, 3), id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(currentIndex == index ? .black : .gray.opacity(0.3))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.2)) // Light gray background
            .cornerRadius(10)
            .padding(.top, 5)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
    }
}

struct FleetManagerView_Previews: PreviewProvider {
    static var previews: some View {
        FleetManagerDashboard()
    }
}
