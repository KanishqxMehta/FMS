//
//  MainTabView.swift
//  FMS
//
//  Created by Kanishq Mehta on 16/02/25.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FleetManagerDashboard()

                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            DriverListView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Drivers")
                }
            
            VehicleView()
                .tabItem {
                    Image(systemName: "car.fill")
                    Text("Vehicles")
                }
            
            TripListView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Trips")
                }
        }
        .accentColor(.black) // Set active tab color
    }
}

// Sample Views for other tabs (Replace with actual content)
struct DriverView: View {
    var body: some View {
        Text("Driver Management Screen")
            .font(.title)
            .bold()
    }
}

struct VehicleView: View {
    var body: some View {
        Text("Vehicle Management Screen")
            .font(.title)
            .bold()
    }
}

struct TripView: View {
    var body: some View {
        Text("Trip Management Screen")
            .font(.title)
            .bold()
    }
}

// **Preview**
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
