//
//  DriverDetailView.swift
//  FMS
//
//  Created by Kanishq Mehta on 15/02/25.
//

import SwiftUI

struct DriverDetailsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Driver Info Card
                    driverInfoCard()
                    
                    // Trip Details
                    TripDetailCard(trip: sampleTrips[2])

                    // Contact Info
                    contactInfoCard()
                    
                    // Vehicle Type
                    vehicleTypeCard()
                }
                .padding()
            }
            .background(Color(.systemGray5)) // Light Grey Background
            .navigationTitle("Driver Details")
//            .navigationBarItems(leading: Button("Drivers") {})
        }
    }
}

// MARK: - Components

func driverInfoCard() -> some View {
    VStack(alignment: .leading, spacing: 10) {
        HStack(alignment: .top) { // Align content to the top
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray5)) // Light Grey Background
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
                // ID on top
                Text("TNX XXXX")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("James Anderson")
                    .font(.title2).bold()
            }
            Spacer() // Push "Available" to the right
            
            // "Available" status at the top right with a light green background
            Text("Available")
                .font(.title3)
                .foregroundColor(.green)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(.systemGreen).opacity(0.2)) // Light Green Background
                .cornerRadius(5)
        }
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Trips")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("20")
                        .font(.title3).bold()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Experience")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("4 months")
                        .font(.title3).bold()
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Distance Travelled")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("120 km")
                        .font(.title3).bold()
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Hours")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("6")
                        .font(.title3).bold()
                }
            }
        }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(10)
}

func contactInfoCard() -> some View {
    VStack(alignment: .leading, spacing: 10) {
        Text("Contact").font(.headline)
        HStack {
            Image(systemName: "phone.fill")
            Text("XXXXXXXXXX")
        }
        HStack {
            Image(systemName: "envelope")
            Text("driver1@gmail.com").foregroundColor(.black)
        }
        HStack {
            Image(systemName: "house")
            Text("1234 Main St, Los Angeles, CA 90001")
        }
    }
    .frame(maxWidth: .infinity) // Ensure the contact card has the same width as others
    .padding()
    .background(Color.white)
    .cornerRadius(10)
}

func vehicleTypeCard() -> some View {
    VStack(alignment: .leading, spacing: 10) {
        Text("Vehicle Type (He Drives)").font(.headline)
        
        HStack(spacing: 5) { // Reduced spacing between buttons
            Button(action: {}) {
                Text("Truck")
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            Button(action: {}) {
                Text("Mini Truck")
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            Spacer() // Push the "Medium" button to the right
        }
        
        HStack {
            Button(action: {}) {
                Text("Car")
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
    .background(Color.white)
    .cornerRadius(10)
}

struct DriverDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DriverDetailsView()
    }
}
