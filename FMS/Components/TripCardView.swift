//
//  TripCardView.swift
//  FMS
//
//  Created by Kanishq Mehta on 15/02/25.
//

import SwiftUI

struct TripCardView: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(trip.driver)
                        .font(.headline)
                        .bold()
                    Text(trip.vehicleType)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("On the trip")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.black)
                Text(trip.startLocation)
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.black)
                Text(trip.eta)
                    .font(.subheadline)
            }
            
            Button(action: {}) {
                HStack {
                    Text("View Details")
                        .font(.subheadline)
                        .bold()
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(10)
            }
        }
        .padding()
        .frame(width: 320, height: 180, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
