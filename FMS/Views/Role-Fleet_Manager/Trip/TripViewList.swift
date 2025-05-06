import SwiftUI

struct TripListView: View {
    @StateObject var viewModel = TripViewModel()
    @State private var showingAddTrip = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) { // Adds spacing between cards
                    ForEach(viewModel.trips) { trip in
                        NavigationLink(destination: TripDetailsView(trip: trip)) {
                            TripCardView(trip: trip)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes default navigation button style
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Trips")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTrip = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTrip) {
                AddEditTripView(tripViewModel: viewModel, trip: nil)
            }
            .onAppear {
                viewModel.fetchTrips()
            }
        }
    }
}

// MARK: - Preview
struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView()
    }
}
