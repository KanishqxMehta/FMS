//
//  DriverListView.swift
//  FMS
//
//  Created by Kanishq Mehta on 15/02/25.
//

import SwiftUI

struct DriverListView: View {
//    let drivers: [Driver] = [
//        Driver(name: "Sanjeev Rana", totalTrips: 50, vehicleExpertise: "Car", experience: "4 yrs", status: "Ready to go!"),
//        Driver(name: "Sanjeev Rana", totalTrips: 50, vehicleExpertise: "Car", experience: "4 yrs", status: "Inactive!")
//    ]
//    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Drivers")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                HStack(spacing: 15) {
                    DriverStatusView(title: "Available", count: 12)
                    DriverStatusView(title: "On Leave", count: 5)
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(drivers) { driver in
                            DriverCardView(driver: driver)
                        }
                    }
                    .padding()
                }
                
                Spacer()
//                CustomTabBar()
            }
            .navigationBarItems(trailing: Button(action: {
                // Action to add driver
            }) {
                Image(systemName: "plus").font(.title2)
            })
        }
    }
}








struct DriversView_Previews: PreviewProvider {
    static var previews: some View {
        DriverListView()
    }
    
}

