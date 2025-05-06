//
//  MainTabView.swift
//  FMS
//
//  Created by Kanishq Mehta on 16/02/25.
//


import SwiftUI

struct MainTabView: View {
    var body: some View { // ✅ Wrap TabView inside NavigationStack
            TabView {
                FleetManagerDashboard()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
//                    .navigationBarBackButtonHidden(true)

                DriverListView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Drivers")
                    }

                VehicleListView()
                    .tabItem {
                        Image(systemName: "car.fill")
                        Text("Vehicles")
                    }

                TripListView()
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Trips")
                    }
                
                SettingView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .accentColor(.black)
            .navigationBarTitleDisplayMode(.inline) // ✅ Ensure title shows
            .toolbar(.visible, for: .navigationBar)
            .navigationBarBackButtonHidden(true) // Hide back button
        }
}


// Sample Views for other tabs (Replace with actual content)
struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                NavigationLink{
                    MaintenanceRequest()
                }label: {
                    Text("Maintance Request")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    // Dismiss the MainTabView
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Settings")
        }
    }
}


// **Preview**
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
