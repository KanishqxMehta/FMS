//
//  ContentView.swift
//  DriverDash
//
//  Created by Brahmjot Singh Tatla on 15/02/25.
//

import SwiftUI

struct DriverDashboardView: View {
    var body: some View {
        NavigationView {
                    VStack(alignment: .leading) {
                        ScrollView {
                            VStack {
                                
                            }
                        }
                        .padding(.bottom, 50)
                    }
                    .background(Color(UIColor.systemGray6))
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationTitle("Welcome")
                    
                }
            }
        }

// Components
struct StatCard_Driver: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.black)
                Text(value)
                    .font(.title2)
                    .bold()
            }
            Text(label)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
            Spacer()
        }
    }
}

struct TripCard: View {
    let vehicleType: String
    let from: String
    let to: String
    let departure: String
    let arrival: String
    let date: String
    let eta: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(vehicleType)
                .font(.caption)
                .padding(5)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(5)
            
            HStack {
                Image(systemName: "car.fill")
                Text("\(from) - \(to)")
                    .font(.headline)
                Spacer()
            }
            
            HStack {
                Text(departure)
                    .font(.subheadline)
                Spacer()
                Text("------------------")
                    .foregroundColor(.gray)
                Spacer()
                Text(arrival)
                    .font(.subheadline)
            }
            .padding(.vertical, 5)
            
            HStack {
                Text("🗓 Departure: \(date)")
                    .font(.caption)
                    .foregroundColor(.black)
                Spacer()
                Text("ETA: \(eta)")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            
            HStack {
                Button(action: {}) {
                    Text("Accept")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {}) {
                    Text("Reject")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct RecentTripCard: View {
    let pickup: String
    let dropoff: String
    let distance: String
    let status: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Pickup: \(pickup)")
                    .font(.subheadline)
                Spacer()
                Text("Status: \(status)")
                    .font(.subheadline)
                    .bold()
            }
            
            Spacer()
            
            HStack {
                Text("Distance: \(distance)")
                    .font(.subheadline)
                Spacer()
                Text("Drop-off: \(dropoff)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct DriverDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DriverDashboardView()
    }
}
