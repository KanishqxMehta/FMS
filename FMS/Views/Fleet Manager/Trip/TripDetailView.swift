//
//  TripDetailView.swift
//  create new trips
//
//  Created by Vanshika on 14/02/25.
//
import SwiftUI

struct TripDetailView: View {
    @ObservedObject var viewModel: TripViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var trip: Trip
    
    var isFormValid: Bool {
        !trip.startLocation.isEmpty && !trip.endLocation.isEmpty &&
        !trip.vehicleType.isEmpty && !trip.vehicleID.isEmpty &&
        !trip.eta.isEmpty && !trip.distance.isEmpty &&
        !trip.startTime.isEmpty && !trip.driver.isEmpty
    }
    
    init(viewModel: TripViewModel, trip: Trip?) {
        self.viewModel = viewModel
        _trip = State(initialValue: trip ?? Trip(startLocation: "", endLocation: "", vehicleType: "", vehicleID: "", eta: "", distance: "", startDate: Date(), startTime: "", endTime: "", driver: ""))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Location Details")) {
                TextField("Start Location", text: $trip.startLocation)
                TextField("End Location", text: $trip.endLocation)
            }
            Section(header: Text("Vehicle Information")) {
                TextField("Vehicle Type", text: $trip.vehicleType)
                TextField("Vehicle ID", text: $trip.vehicleID)
            }
            Section(header: Text("Trip Details")) {
                TextField("ETA", text: $trip.eta)
                TextField("Distance", text: $trip.distance)
            }
            Section(header: Text("Schedule")) {
                DatePicker("Start Date", selection: $trip.startDate, displayedComponents: .date)
                TextField("Start Time", text: $trip.startTime)
            }
            Section(header: Text("Assign Driver")) {
                TextField("Driver Name", text: $trip.driver)
            }
        }
        .navigationTitle(trip.id == UUID() ? "New Trip" : "Edit Trip")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if viewModel.trips.firstIndex(where: { $0.id == trip.id }) != nil {
                        viewModel.updateTrip(trip)
                    } else {
                        viewModel.addTrip(trip)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(!isFormValid)
            }
        }
    }
}
