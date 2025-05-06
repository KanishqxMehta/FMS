import SwiftUI

struct DriverSettingView: View {
    @State private var isAvailable: Bool = true // ✅ Default to Available
    @State private var showingAlert: Bool = false
    @State private var pendingAvailabilityChange: Bool?
    @State private var totalDistanceTraveled: Double = 0.0
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DriverViewModel
    @State private var driverName: String
   
    init(viewModel: DriverViewModel, driverName: String) {
        self.viewModel = viewModel
        _driverName = State(initialValue: driverName)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // MARK: - Personal Details Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Personal Details")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                        Text(driverName.isEmpty ? (viewModel.driver?.name ?? "Naman") : driverName)
                            .foregroundColor(.black)
                            .bold()
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // MARK: - Availability Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Availability")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                        Text("Available for Trips")
                            .foregroundColor(.black)
                        Spacer()
                        Toggle("", isOn: $isAvailable)
                            .labelsHidden()
                            .onChange(of: isAvailable) { newValue in
                                pendingAvailabilityChange = newValue
                                showingAlert = true
                            }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // MARK: - Wallet Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Earnings")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "wallet.pass.fill")
                            .foregroundColor(.black)
                        Text("Earnings")
                            .foregroundColor(.black)
                        Spacer()
//                        fetchTotalDistanceTraveled()
                        Text("$ \(totalDistanceTraveled, specifier: "%.2f")")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // MARK: - Logout Button
                Button(action: {
                    resetAppToRoot()
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
            .padding()
            .background(Color(.systemGray6))
            .navigationTitle("Settings")
            .onAppear {
                if driverName.isEmpty {
                    viewModel.loadCurrentDriver()
                    driverName = viewModel.driver?.name ?? "Naman"
                }
                
                if let driverStatus = viewModel.driver?.driverStatus {
                    isAvailable = driverStatus == .available
                }
                
                fetchTotalDistanceTraveled()
            }
            .alert("Change Availability?", isPresented: $showingAlert) {
                Button("Cancel", role: .cancel) {
                    if let pendingChange = pendingAvailabilityChange {
                        isAvailable = !pendingChange // Revert toggle change
                    }
                }
                Button("Confirm") {
                    if let pendingChange = pendingAvailabilityChange {
                        updateAvailability(pendingChange)
                    }
                }
            } message: {
                Text("Are you sure you want to change your availability?")
            }
        }
    }
    
    func resetAppToRoot() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = UIHostingController(rootView: RoleSelectionView())
        window.makeKeyAndVisible()
    }

    func updateAvailability(_ isAvailable: Bool) {
        viewModel.updateAvailability(isAvailable: isAvailable)
    }
    
    func fetchTotalDistanceTraveled() {
        FirestoreService.shared.fetchCompletedTrips { trips in
            DispatchQueue.main.async {
                self.totalDistanceTraveled = trips.reduce(0) { total, trip in
                    if let distance = Double(trip.distance) {
                        return total + distance
                    } else {
                        print("⚠️ Invalid distance value for trip: \(trip.distance)")
                        return total
                    }
                }
            }
        }
    }
}

#Preview {
    DriverSettingView(viewModel: DriverViewModel(), driverName: "Naman")
}
