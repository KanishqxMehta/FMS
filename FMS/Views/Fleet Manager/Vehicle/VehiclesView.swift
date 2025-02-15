//
//  VehiclesView.swift
//  BootCamp
//
//  Created by Rohan Jain on 13/02/25.
//

import SwiftUI

struct VehiclesView: View {
    @State private var selectedCategory = "Truck"
    let categories = ["Truck", "Mini Truck", "Car"]
    
    let vehicles: [Vehicle] = [
        Vehicle(vehicleName: "Tata 407", vehicleType: .truck, totalTrips: "40", status: "Ready to go!"),
        Vehicle(vehicleName: "Mahindra Blazo", vehicleType: .truck, totalTrips: "60", status: "Needs Maintenance"),
        Vehicle(vehicleName: "BharatBenz 3123", vehicleType: .truck, totalTrips: "90", status: "Maintenance"),
        
        Vehicle(vehicleName: "Maruti Swift", vehicleType: .car, totalTrips: "20", status: "Ready to go!"),
        Vehicle(vehicleName: "Hyundai Creta", vehicleType: .car, totalTrips: "35", status: "Needs Maintenance"),
        Vehicle(vehicleName: "Tata Harrier", vehicleType: .car, totalTrips: "50", status: "Maintenance"),
        
        Vehicle(vehicleName: "Volvo 9400", vehicleType: .miniTruck, totalTrips: "60", status: "Ready to go!"),
        Vehicle(vehicleName: "Ashok Leyland", vehicleType: .miniTruck, totalTrips: "80", status: "Needs Maintenance"),
        Vehicle(vehicleName: "Mercedes-Benz Tourismo", vehicleType: .miniTruck, totalTrips: "100", status: "Maintenance")
    ]

    
    var filteredVehicles: [Vehicle] {
        vehicles.filter { $0.vehicleType.rawValue == selectedCategory }
    }
    
    var body: some View {
            
            NavigationView {
                VStack {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \..self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    List(filteredVehicles) { vehicle in
                        VehicleRow(vehicle: vehicle)
                    }
                    .listStyle(PlainListStyle())
                }
                .navigationTitle("Vehicles")
                .background(Color(UIColor.secondarySystemBackground))
            }
            .background(Color.white.ignoresSafeArea())
    }
}

struct VehicleRow: View {
    let vehicle: Vehicle
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(vehicle.vehicleName).font(.headline)
                Spacer()
                Text(vehicle.status)
                    .foregroundColor(vehicle.status == "Ready to go!" ? .green : (vehicle.status == "Needs Maintenance" ? .orange : .red))
            }
//            Text("Last maintenance: \(vehicle.lastMaintenance)")
//            Text("Distance after maintenance: \(vehicle.distanceAfterMaintenance)")
            Text("Total Trips: \(vehicle.totalTrips)")
        }
        .padding()
    }
}

struct VehiclesView_Previews: PreviewProvider {
    static var previews: some View {
        VehiclesView()
    }
}

