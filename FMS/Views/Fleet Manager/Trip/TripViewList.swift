//
//  TripViewList.swift
//  create new trips
//
//  Created by Vanshika on 14/02/25.
//

import SwiftUI

struct TripListView: View {
    @StateObject var viewModel = TripViewModel()
    @State private var showingAddTrip = false
    @State private var editingTrip: Trip? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.trips) { trip in
                    Button(action: {
                        editingTrip = trip
                    }) {
                        VStack(alignment: .leading) {
                            Text("\(trip.startLocation) to \(trip.endLocation)")
                                .font(.headline)
                            Text("Driver: \(trip.driver)")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: viewModel.removeTrip)
            }
            .navigationTitle("Trips")
            .toolbar {
                Button(action: { showingAddTrip = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTrip) {
                NavigationView {
                    TripDetailView(viewModel: viewModel, trip: nil)
                }
            }
            .sheet(item: $editingTrip) { trip in
                NavigationView {
                    TripDetailView(viewModel: viewModel, trip: trip)
                }
            }
        }
    }
}


struct TripListView_Preview: PreviewProvider {
    static var previews: some View {
        TripListView()
    }
}
