import SwiftUI

import SwiftUI

struct VehicleListView: View {
    @State private var vehicles: [Vehicle] = [
        Vehicle(vehicleName: "Toyota Corolla", year: 2022, vehicleType: .car, totalTrips: "15", status: "Available", vin: "1HGCM82633A123456",
                rcExpiryDate: Date(), pollutionExpiryDate: Date(), insuranceExpiryDate: Date(), permitExpiryDate: Date()),
        Vehicle(vehicleName: "Ford F-150", year: 2020, vehicleType: .truck, totalTrips: "22", status: "On Trip", vin: "1FTFW1E55LKD12345",
                rcExpiryDate: Date(), pollutionExpiryDate: Date(), insuranceExpiryDate: Date(), permitExpiryDate: Date())
    ]
    
    @State private var showAddEditVehicle = false
    @State private var selectedVehicle: Vehicle?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(vehicles) { vehicle in
                        VehicleCard(vehicle: vehicle)
                            .onTapGesture {
                                selectedVehicle = vehicle
                                showAddEditVehicle = true
                            }
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Vehicles")
            .navigationBarItems(trailing: Button(action: {
                selectedVehicle = nil
                showAddEditVehicle = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showAddEditVehicle) {
                AddEditVehicleView(vehicle: selectedVehicle)
            }
        }
    }
}


// MARK: - Vehicle Card View
struct VehicleCard: View {
    var vehicle: Vehicle

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
                
                Text(vehicle.status)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
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
        .padding(.horizontal)
    }
}

// MARK: - AddEditVehicleView
struct VehicleListView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleListView()
    }
}
