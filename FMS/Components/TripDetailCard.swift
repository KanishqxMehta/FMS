import SwiftUI
import Firebase
struct TripDetailCard: View {
    let trip: Trip
    @State private var tripStatus: String = "On the trip" // ✅ State for trip status

    var body: some View {
        HStack(spacing: 0) {
            Text(trip.vehicleType.rawValue)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 200, height: 100)
                .padding(.vertical, 10)
                .background(Color.black)
                .rotationEffect(.degrees(-90))
                .fixedSize()
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "car.fill")
                        .foregroundColor(.black)
                    Text("\(trip.startLocation) - \(trip.endLocation)").bold()
                    Spacer()
                    Text(tripStatus) // ✅ Show trip status
                        .foregroundColor(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(.systemGreen).opacity(0.2))
                        .cornerRadius(5)
                }
                
                Divider()

                HStack {
                    Text("--------------")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    VStack {
                        Text(trip.eta)
                            .font(.headline)
                            .bold()
                        Text("ETA: \(trip.distance)") // ✅ Use distance info
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity)

                // ✅ View Details Button (Same as TripCardView)
                Button(action: {
                    print("Navigating to trip details for \(trip.id.uuidString)")
                }) {
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
            .background(Color(.systemBackground))
            .cornerRadius(10)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .onAppear {
            fetchTripStatus() // ✅ Fetch trip status dynamically
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // ✅ Fetch trip status from Firestore
    private func fetchTripStatus() {
        let db = Firestore.firestore()
        let tripRef = db.collection("trips").document(trip.id.uuidString)

        tripRef.getDocument { document, error in
            if let error = error {
                print("❌ Error fetching trip status: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                if let status = document.get("status") as? String {
                    DispatchQueue.main.async {
                        tripStatus = status // ✅ Update the status dynamically
                    }
                }
            }
        }
    }
}

// Preview with sample data
#Preview {
    TripDetailCard(trip: Trip(startLocation: "Delhi", endLocation: "Chandigarh", vehicleType: .car, vehicleID: "967F906A-B603-4163-B30B-CC13FB65EEE8", eta: "1219 min", distance: "1400.25 km", startDate: Date(), endDate: Date(), driver: "55207BC8-DF23-4931-BBEB-B401B32CEB2F"))
}
