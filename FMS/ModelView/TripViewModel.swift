import Foundation

class TripViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
    }
    
    func removeTrip(at indexSet: IndexSet) {
        trips.remove(atOffsets: indexSet)
    }
    
    func updateTrip(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
        }
    }
}
