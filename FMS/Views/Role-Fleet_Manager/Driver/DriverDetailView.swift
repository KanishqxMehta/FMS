//
//  DriverDetailView.swift
//  FMS
//
//  Created by Vanshika on 21/02/25.
//
import SwiftUI

struct DriverDetailsView: View {
    @ObservedObject var driverViewModel = DriverViewModel()
    var selectedDriver: Driver?
    @State private var showingEditDriver = false // Add this state variable
    
    var body: some View {
        let driver = selectedDriver ?? Driver(
            id: UUID(),
            name: "Unknown",
            age: "22",
            address: "Unknown",
            mobileNumber: "1234567890",
            driverStatus: .available,
            email: "driver@gmail.com",
            licenseID: "2343343443",
            vehicleType: [.car, .truck],
            experienceInYears: 22,
            istanceTraveled: "22 km"
        )

        return NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    driverInfoCard(driver: driver)
                    contactInfoCard(driver: driver)
                    vehicleTypeCard(driver: driver)
                }
                .padding()
            }
            .background(Color(.systemGray5))
            .navigationTitle("Driver Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        showingEditDriver = true // Set the state to show the sheet
                    }
                }
            }
            .sheet(isPresented: $showingEditDriver) {
                // Present the edit view with the selected driver
                AddEditDriverView(viewModel: driverViewModel, driver: driver)
            }
        }
    }
}

// MARK: - Components

func driverInfoCard(driver: Driver) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        HStack(alignment: .top) {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray5)) // ✅ Light Grey Background
                    .frame(width: 120, height: 120)
                    .cornerRadius(15)
                
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(.systemGray3))
                    .clipShape(Rectangle())
                    .cornerRadius(10)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("\(driver.licenseID)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("\(driver.name)")
                    .font(.title2).bold()
            }
            Spacer()
            
            Text(driver.driverStatus == .available ? "Available" : "Unavailable")
                .font(.title3)
                .foregroundColor(driver.driverStatus == .available ? .green : .red)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(driver.driverStatus == .available ? Color(.systemGreen).opacity(0.2) : Color(.red).opacity(0.2))
                .cornerRadius(5)
        }
        DriverInfoCardView(
           
            info: [
                ("Experience", String(driver.experienceInYears)),
                ("Distance Travelled", String(driver.istanceTraveled)),
                ("Total Trips", String(driver.totalTrips)),
//                ("Hours", String(driver.hours))
               
            ]
        )
        
//        VStack {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text("Total Trips")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                    Text("20")
//                        .font(.title3).bold()
//                }
//                Spacer()
//                VStack(alignment: .leading) {
//                    Text("Experience")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                    Text("\(driver.experienceInYears) years")
//                        .font(.title3).bold()
//                }
//            }
//
//            HStack {
//                VStack(alignment: .leading) {
//                    Text("Distance Traveled")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                    Text("\(driver.istanceTraveled)")
//                        .font(.title3).bold()
//                }
//                Spacer()
//                VStack(alignment: .leading) {
//                    Text("Hours")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                    Text("6")
//                        .font(.title3).bold()
//                }
//            }
//        }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(10)
}

func contactInfoCard(driver: Driver) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        Text("Contact")
            .font(.headline)

        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.black)
                Text(driver.mobileNumber)
            }
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.black)
                Text(driver.email)
                    .foregroundColor(.black)
            }
            
            HStack {
                Image(systemName: "house")
                    .foregroundColor(.black)
                Text(driver.address)
            }
        }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading) // ✅ Aligns the whole card to the left
    .background(Color.white)
    .cornerRadius(10)
}

func vehicleTypeCard(driver: Driver) -> some View {
    VStack(alignment: .leading, spacing: 10) {
        Text("Vehicle Type (He Drives)").font(.headline)
        
        HStack(spacing: 5) {
            ForEach(driver.vehicleType, id: \.self) { vehicle in
                Text(vehicle.rawValue)
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            Spacer()
        }
    }
    .padding()
    .background(Color.white) // ✅ White Background
    .cornerRadius(10)
}

// MARK: - Preview
struct DriverDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DriverDetailsView(selectedDriver: Driver(
            id: UUID(),
            name: "John Doe",
            age: "30",
            address: "123 Main St, Los Angeles, CA",
            mobileNumber: "9876543210",
            driverStatus: .available,
            email: "johndoe@example.com",
            licenseID: "123456789",
            vehicleType: [.car, .truck],
            experienceInYears: 5,
            istanceTraveled: "5000 km"
        ))
    }
}




