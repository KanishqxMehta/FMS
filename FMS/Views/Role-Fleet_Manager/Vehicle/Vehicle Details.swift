//
//  Vehicle Details.swift
//  FMS
//
//  Created by MainAdmin on 25/02/25.
//

import SwiftUI

//import SwiftUI

struct VehicleDetailsView: View {
    var vehicle: Vehicle
    @Binding var showEditVehicle: Bool
    @Binding var selectedVehicle: Vehicle?
    
    var body: some View {
        ScrollView {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(vehicle.vin)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(vehicle.vehicleName)
                                    .font(.title2)
                                    .bold()
                            }
                            Spacer()
                          Text(vehicle.status.rawValue)
                                .font(.callout)
                                .bold()
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        
                        Divider()
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), alignment: .leading)], spacing: 8) {
                            InfoRow(title: "Type", value: vehicle.vehicleType.rawValue)
                            InfoRow(title: "Distance Travelled", value: vehicle.totalTrips + " km")
                            InfoRow(title: "Engine Number", value: String(vehicle.engineNumber))
                            InfoRow(title: "Total Trips", value: vehicle.totalTrips)
                            InfoRow(title: "Chassis Number", value: String(vehicle.chassisNumber))
                            InfoRow(title: "Manufacture Date", value: String(vehicle.year))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Expiry Details")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), alignment: .leading)], spacing: 8) {
                            InfoRow(title: "RC Expiry", value: vehicle.rcExpiryDate.formatted(date: .numeric, time: .omitted))
                            InfoRow(title: "Pollution Expiry", value: vehicle.pollutionExpiryDate.formatted(date: .numeric, time: .omitted))
                            InfoRow(title: "Insurance Expiry", value: vehicle.insuranceExpiryDate.formatted(date: .numeric, time: .omitted))
                            InfoRow(title: "Permit Expiry", value: vehicle.permitExpiryDate.formatted(date: .numeric, time: .omitted))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
        .navigationTitle("Vehicle Details")
        .navigationBarItems(
            trailing: Button(action: {
                selectedVehicle = vehicle
                showEditVehicle = true
            }) {
                Text("Edit")
                    .foregroundColor(.blue)
            }
        )
    }
}

// Preview
//struct VehicleDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        VehicleDetailsView()
//    }
//}
