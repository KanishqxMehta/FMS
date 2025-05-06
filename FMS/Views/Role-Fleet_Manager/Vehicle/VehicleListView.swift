import SwiftUI

struct VehicleListView: View {
    @StateObject private var vehicleViewModel = VehicleViewModel()
    @State private var showAddEditVehicle = false
    @State private var selectedVehicle: Vehicle?
    @State private var showingDeleteAlert = false
    @State private var vehicleToDelete: Vehicle?
    
    var availableCount: Int {
      vehicleViewModel.vehicles.filter { $0.status == .available }.count
    }
    
    var unavailableCount: Int {
      vehicleViewModel.vehicles.filter { $0.status != .available }.count
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    StatusCard(title: "Available", count: availableCount)
                    StatusCard(title: "Unavailable", count: unavailableCount)
                }.padding(20)
                
                List {
                    ForEach(vehicleViewModel.vehicles, id: \ .id) { vehicle in
                        NavigationLink(destination: VehicleDetailsView(vehicle: vehicle, showEditVehicle: $showAddEditVehicle, selectedVehicle: $selectedVehicle)) {
                            VehicleCard(vehicle: vehicle)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                vehicleToDelete = vehicle
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Vehicles")
            .navigationBarItems(
                trailing: Button(action: {
                    selectedVehicle = nil
                    showAddEditVehicle = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showAddEditVehicle) {
                AddEditVehicleView(vehicle: selectedVehicle)
                    .environmentObject(vehicleViewModel)
            }
            .alert("Are you sure you want to delete this vehicle?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let vehicle = vehicleToDelete {
                        vehicleViewModel.deleteVehicle(vehicle)
                    }
                }
            }
        }
    }
}



// MARK: - Vehicle Card View
struct VehicleCard: View {
    var vehicle: Vehicle
    @EnvironmentObject var vehicleViewModel: VehicleViewModel // Add environment object
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(vehicle.vehicleName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text(vehicle.vin)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
              Text(vehicle.status.rawValue)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(vehicle.status == .available ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundColor(vehicle.status == .available ? .green : .red)
                    .cornerRadius(10)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.gray)
                Text("Year Purchased: \(String(vehicle.year))")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.gray)
                Text("Total Trips: \(vehicle.totalTrips)")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 0.5)
                .background(Color.white)
                .cornerRadius(12)
        )
    }
}
struct StatusCard: View {
    var title: String
    var count: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text("\(count)")
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 1))
    }
}

struct VehicleListView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleListView()
    }
}
