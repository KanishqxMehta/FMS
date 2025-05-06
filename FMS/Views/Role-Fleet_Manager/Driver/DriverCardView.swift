//
//  DriverCardView.swift
//  FMS
//
//  Created by Vanshika on 21/02/25.
//
import SwiftUI

struct DriverCardView: View {
    let driver: Driver

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)

                Text(driver.name)
                    .font(.headline)
                    .bold()

                Spacer()

                Text(driver.driverStatus == .available ? "Available" : "Unavailable")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(driver.driverStatus == .available ? Color.black : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            HStack {
                Image(systemName: "waveform.path.ecg")
                Text("Total trips: \(driver.totalTrips)")
            }

            HStack {
                Image(systemName: "bolt.fill")
                Text("Experience: \(driver.experienceInYears) years")
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
}
