import SwiftUI
import Firebase

struct TripCardView: View {
    
    let trip: Trip
    @State private var driverName: String = "Unknown Driver" // ✅ Dynamically update driver name
    @State private var tripStatus: String = "On the trip" // ✅ Dynamically update trip status

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(driverName) // ✅ Displays the driver name
                        .font(.headline)
                        .bold()
                    Text(trip.vehicleType.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                Text(tripStatus) // ✅ Dynamically updates trip status
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            DriverInfoCardView(info: [("Start Location", trip.startLocation), ("ETA", trip.eta)])
        }
        .padding()
        .frame(width: 320, height: 150, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            fetchTripDetails()
        }
    }

    // ✅ Fetch trip details including driver name and status
    private func fetchTripDetails() {
        let db = Firestore.firestore()
        let tripRef = db.collection("trips").document(trip.id.uuidString)

        tripRef.getDocument { document, error in
            if let error = error {
                print("❌ Error fetching trip details: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                DispatchQueue.main.async {
                    // ✅ Fetch and update trip status
                    if let status = document.get("status") as? String {
                        tripStatus = status
                    }
                    // ✅ Fetch and update driver name
                    if let driver = document.get("driverName") as? String {
                        driverName = driver
                    }
                }
            }
        }
    }
}
