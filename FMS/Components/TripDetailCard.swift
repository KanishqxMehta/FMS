import SwiftUI

struct TripDetailCard: View {
    let trip: Trip
    
    var body: some View {
        HStack(spacing: 0) {
            // Black strip on the left with vehicle type
            Text(trip.vehicleType)
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
                    Text("Ready to go!") // You can replace this with a status property in `Trip`
                        .foregroundColor(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(.systemGreen).opacity(0.2))
                        .cornerRadius(5)
                }
                Divider()
                
                HStack {
                    VStack {
                        Text(trip.startTime)
                            .font(.headline)
                            .bold()
                        Text("Departure: \(formattedDate(trip.startDate))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("--------------")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    VStack {
                        Text(trip.eta)
                            .font(.headline)
                            .bold()
                        Text("ETA: \(trip.distance)") // Using distance here, modify if needed
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
        }
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// Preview with sample data
#Preview {
    TripDetailCard(trip: sampleTrips[0])
}
