import SwiftUI
import FirebaseFirestore

struct MaintenanceRequest: View {
    @StateObject private var maintenanceViewModel = MaintenanceViewModel()
    @StateObject private var vehicleViewModel = VehicleViewModel()
    @State private var selectedVehicle: Vehicle?
    @State private var existingRequestStatus: String?
    @State private var navigateToStatusPage = false
    @State private var navigateToRequestForm = false
    @State private var selectedSegment = "Available"

    let segments = ["Available", "Ongoing", "Completed"]

    var body: some View {
        NavigationStack {
            VStack {
//                Picker("Maintenance Status", selection: $selectedSegment) {
//                    ForEach(segments, id: \.self) { segment in
//                        Text(segment)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.horizontal)

                Text("\(selectedSegment) Vehicles")
                    .font(.title2)
                    .padding(.top)

                List {
                    ForEach(filteredVehicles()) { vehicle in
                        Button(action: {
                            checkExistingRequest(vehicle: vehicle)
                        }) {
                            VehicleCard(vehicle: vehicle)
                        }
                    }
                }
                .listStyle(PlainListStyle())


                Spacer()
            }
            .padding()
            .onAppear {
                vehicleViewModel.fetchVehicles()
            }
            .navigationTitle("Maintenance")
            .navigationDestination(isPresented: $navigateToStatusPage) {
                if let vehicle = selectedVehicle, let status = existingRequestStatus {
                    MaintenanceRequestStatusPage(vehicle: vehicle, status: status)
                }
            }
            .navigationDestination(isPresented: $navigateToRequestForm) {
                if let vehicle = selectedVehicle {
                    MaintenanceRequestForm(vehicle: vehicle)
                }
            }
        }
    }

    private func filteredVehicles() -> [Vehicle] {
            switch selectedSegment {
            case "Ongoing":
                return vehicleViewModel.vehicles.filter { vehicle in
                    maintenanceViewModel.requests[vehicle.id.uuidString] == "In Progress"
                }
            case "Completed":
                return vehicleViewModel.vehicles.filter { vehicle in
                    maintenanceViewModel.requests[vehicle.id.uuidString] == "Completed"
                }
            default: // "Available"
                return vehicleViewModel.vehicles.filter { vehicle in
                    let status = maintenanceViewModel.requests[vehicle.id.uuidString]
                    return status != "In Progress" && status != "Completed"
                }
            }
        }


    private func checkExistingRequest(vehicle: Vehicle) {
        FirestoreService.shared.checkIfMaintenanceRequestExists(vehicleID: vehicle.id.uuidString) { exists, status in
            DispatchQueue.main.async {
                selectedVehicle = vehicle
                if exists {
                    existingRequestStatus = status
                    navigateToStatusPage = true
                } else {
                    navigateToRequestForm = true
                }
            }
        }
    }
}

class MaintenanceViewModel: ObservableObject {
    @Published var requests: [String: String] = [:] // 🔹 Stores {vehicleID: status}

    func fetchMaintenanceRequests() {
        let db = Firestore.firestore()
        db.collection("maintenanceRequests").addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Error fetching maintenance requests: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }
            var updatedRequests: [String: String] = [:]

            for document in documents {
                let data = document.data()
                if let vehicleID = data["vehicleID"] as? String,
                   let status = data["status"] as? String {
                    updatedRequests[vehicleID] = status
                }
            }

            DispatchQueue.main.async {
                self.requests = updatedRequests
            }
        }
    }
}


// ✅ Maintenance Request Status Page (Now Shows Cost Breakdown)
struct MaintenanceRequestStatusPage: View {
    var vehicle: Vehicle
    var status: String
    @State private var totalCost: Double = 0.0 // 🔹 Set default value to avoid nil issues
    @State private var priceBreakdown: [(String, Double)] = []
    let fixedServiceCost: Double = 50.00 // 🔹 Define Fixed Cost

    var body: some View {
        VStack(spacing: 20) {
            Text("Maintenance Request Already Exists")
                .font(.title2)
                .bold()
                .foregroundColor(.red)

            VehicleInfoCard(vehicle: vehicle)

            Text("Current Status: \(status)")
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)

            if status == "Completed" {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Total Cost: $\(totalCost, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                    Text("Price Breakdown")
                        .font(.headline)

                    HStack {
                        Text("Fixed Service Cost:")
                        Spacer()
                        Text("$\(fixedServiceCost, specifier: "%.2f")")
                    }
                    .padding(.horizontal)

                    if !priceBreakdown.isEmpty {
                        ForEach(priceBreakdown, id: \.0) { item in
                            HStack {
                                Text("\(item.0):")
                                Spacer()
                                Text("$\(item.1, specifier: "%.2f")")
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        Text("No replaced parts added.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Request Status")
        .onAppear {
            if status == "Completed" {
                fetchTotalCost()
            }
        }
    }

    private func fetchTotalCost() {
        let db = Firestore.firestore()
        db.collection("maintenanceRequests")
          .whereField("vehicleID", isEqualTo: vehicle.id.uuidString)
          .getDocuments { snapshot, error in
              if let error = error {
                  print("❌ Firestore Query Error: \(error.localizedDescription)")
                  return
              }

              guard let documents = snapshot?.documents, !documents.isEmpty else {
                  print("❌ No matching documents found for vehicleID: \(vehicle.id.uuidString)")
                  return
              }

              for document in documents {
                  let data = document.data()
                  print("📄 Firestore Debug - Found Document: \(data)")

                  DispatchQueue.main.async {
                      if let fetchedTotalCost = data["totalCost"] as? NSNumber {
                          self.totalCost = fetchedTotalCost.doubleValue
                          print("✅ Total Cost Updated: \(self.totalCost)")
                      }

                      if let breakdownData = data["replacedParts"] as? [[String: Any]] {
                          self.priceBreakdown = breakdownData.compactMap { partData in
                              guard let name = partData["name"] as? String,
                                    let priceValue = partData["price"] else {
                                  return nil
                              }

                              let price: Double
                              if let priceNumber = priceValue as? NSNumber {
                                  price = priceNumber.doubleValue
                              } else if let priceString = priceValue as? String, let convertedPrice = Double(priceString) {
                                  price = convertedPrice
                              } else {
                                  return nil
                              }

                              return (name, price)
                          }

                          print("✅ Price Breakdown Updated: \(self.priceBreakdown)")
                      } else {
                          print("⚠️ No replaced parts found in Firestore")
                          self.priceBreakdown = []
                      }
                  }
              }
          }

    }


    
}


struct MaintenanceRequestForm: View {
    var vehicle: Vehicle
    @State private var dueDate = Date()
    @State private var requestSubmitted = false
    @State private var requestStatus: String?
    let serviceType: String = "Regular" // 🔹 Added Default Service Type

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Vehicle Information")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                VehicleInfoCard(vehicle: vehicle)

                if requestSubmitted {
                    VStack(spacing: 10) {
                        Text("Maintenance Request Sent Successfully!")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.green)
                        
                        Text("Maintenance Status: \(requestStatus ?? "Pending")")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding()
                } else {
                    Text("Request Maintenance")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                            .padding(.bottom, 10)

                        Button("Send Request") {
                            submitMaintenanceRequest()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Maintenance Request")
    }

    private func submitMaintenanceRequest() {
        let maintenanceRequest = MaintenanceRequestModel(
            id: UUID().uuidString,
            vehicleID: vehicle.id.uuidString,
            vehicleName: vehicle.vehicleName,
            dueDate: dueDate,
            status: "Pending",
            serviceType: serviceType // 🔹 Added Service Type
        )

        FirestoreService.shared.submitMaintenanceRequest(maintenanceRequest) { success in
            DispatchQueue.main.async {
                if success {
                    print("✅ Maintenance request successfully saved in Firestore")
                    requestStatus = "Maintenance Requested"
                    requestSubmitted = true
                } else {
                    print("⚠️ Maintenance request already exists for this vehicle!")
                    requestStatus = "⚠️ Request Already Exists"
                }
            }
        }
    }
}

// ✅ Maintenance Request Model (Updated with Service Type)
struct MaintenanceRequestModel: Identifiable, Codable {
    var id: String
    var vehicleID: String
    var vehicleName: String
    var dueDate: Date
    var status: String
    var serviceType: String // 🔹 Added Service Type
}


// ✅ Vehicle Information Card (Unchanged)
struct VehicleInfoCard: View {
    var vehicle: Vehicle

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(vehicle.vehicleName)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Text(vehicle.status.rawValue)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(vehicle.status == .available ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .foregroundColor(vehicle.status == .available ? .green : .red)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

#Preview {
    MaintenanceRequest()
}
