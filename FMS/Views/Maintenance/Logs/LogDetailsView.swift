import SwiftUI
import FirebaseFirestore

struct LogDetailsView: View {
    var logID: String
    var vehicleNumber: String
    var vehicleModel: String
    var serviceDate: String
    var dueDate: String
    var cost: String
    var serviceStatus: ServiceStatus
    enum ServiceStatus: String, Codable {
        case inProgress = "In Progress"
        case completed = "Completed"
        case requested = "Requested"

        var text: String {
            switch self {
            case .inProgress: return "In Progress"
            case .completed: return "Completed"
            case .requested: return "Requested"
            }
        }

        var color: Color {
            switch self {
            case .inProgress: return Color.yellow.opacity(0.8)
            case .completed: return Color.green.opacity(0.8)
            case .requested: return Color.orange.opacity(0.8)
            }
        }
    }


    @State private var replacedParts: [(name: String, price: Double)] = [] // 🔹 Now includes price
    @State private var inventoryItems: [(name: String, price: Double)] = [] // 🔹 Store Inventory Items with price
    @State private var showInventorySheet = false
    @State private var isSaved = false

    let fixedServiceCost: Double = 50.0 // 🔹 Fixed cost for "Regular" service

    var totalCost: Double {
        let partsTotal = replacedParts.reduce(0) { $0 + $1.price }
        return fixedServiceCost + partsTotal
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                // 🚗 Vehicle Information
                HStack {
                    Image(systemName: "car")
                        .resizable()
                        .frame(width: 60, height: 50)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black)
                        .cornerRadius(10)

                    VStack(alignment: .leading) {
                        Text(vehicleNumber)
                            .font(.headline)
                            .fontWeight(.bold)

                        Text(vehicleModel)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text(serviceStatus.text)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(serviceStatus.color)
                            .cornerRadius(10)
                    }.padding()
                    Spacer()
                }

                Divider()

                // 🛠 Service Details
                Text("Service Details")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 10) {
                    LabelDetailView(label: "Service Type", value: "Regular") // 🔹 Default service type
                    LabelDetailView(label: "Due Date", value: dueDate)
                    LabelDetailView(label: "Fixed Service Cost", value: String(format: "$%.2f", fixedServiceCost))
                }

                Divider()

                // 📋 Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Regular maintenance including software updates and brake inspection.")
                        .font(.body)
                }

                Divider()

                // 🔧 Replaced Parts & Add Button
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Replaced Parts")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()

                        if serviceStatus != .completed {
                            Button("Add") {
                                fetchInventoryItems()  // 🔥 Fetch Inventory Items with price
                                showInventorySheet = true
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }

                    ForEach(replacedParts, id: \.name) { part in
                        Text("• \(part.name) - $\(part.price, specifier: "%.2f")")
                            .font(.body)
                    }

                    if !isSaved && serviceStatus != .completed {
                        Button("Save") {
                            saveReplacedParts()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 1))
            .padding()

            // 🔹 Total Cost & Price Breakdown
            VStack(alignment: .leading, spacing: 10) {
                Text("Price Breakdown")
                    .font(.headline)

                Text("Regular Service: $\(fixedServiceCost, specifier: "%.2f")")
                ForEach(replacedParts, id: \.name) { part in
                    Text("\(part.name): $\(part.price, specifier: "%.2f")")
                }
                Text("Total Cost: $\(totalCost, specifier: "%.2f")")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.blue)
            }
            .padding()

            Spacer()

            // ✅ "Complete" Button - Sends total cost and price breakdown to Firestore
            if serviceStatus != .completed {
                Button(action: completeMaintenance) {
                    Text("Complete & Send Cost")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            fetchReplacedParts() // ✅ Fetch replaced parts with prices
        }
        .sheet(isPresented: $showInventorySheet) {
            InventorySelectionView(inventoryItems: inventoryItems, onSelect: { name, price in
                replacedParts.append((name, price)) // ✅ Correctly stores both name & price
            })
        }

    }

    // 🔥 Fetch Replaced Parts with Prices from Firestore
    private func fetchReplacedParts() {
        let db = Firestore.firestore()

        db.collection("replacedParts").document(logID).getDocument { snapshot, error in
            if let error = error {
                print("❌ Error fetching replaced parts: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data(), let parts = data["parts"] as? [[String: Any]] {
                DispatchQueue.main.async {
                    self.replacedParts = parts.compactMap { partData in
                        if let name = partData["name"] as? String, let price = partData["price"] as? Double {
                            return (name, price)
                        }
                        return nil
                    }
                }
            }
        }
    }

    // 🔥 Fetch Inventory Items with Prices
    private func fetchInventoryItems() {
        let db = Firestore.firestore()

        db.collection("inventory").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching inventory: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("❌ No inventory items found.")
                return
            }

            let items = documents.compactMap { doc -> (String, Double)? in
                if let name = doc["name"] as? String, let price = doc["price"] as? Double {
                    return (name, price)
                }
                return nil
            }

            DispatchQueue.main.async {
                self.inventoryItems = items
            }
        }
    }

    // 🔥 Save Replaced Parts with Prices
    private func saveReplacedParts() {
        let db = Firestore.firestore()

        let partsData = replacedParts.map { ["name": $0.name, "price": $0.price] }

        db.collection("replacedParts").document(logID).setData([
            "parts": partsData
        ], merge: true) { error in
            if let error = error {
                print("❌ Error saving replaced parts: \(error.localizedDescription)")
            } else {
                print("✅ Replaced parts saved successfully.")
                DispatchQueue.main.async {
                    self.isSaved = true
                }
            }
        }
    }

    // ✅ Complete Maintenance & Send Cost Data to Firestore
    private func completeMaintenance() {
        let db = Firestore.firestore()

        let priceBreakdown = replacedParts.map { ["name": $0.name, "price": $0.price] }
        let maintenanceData: [String: Any] = [
            "status": "Completed",
            "fixedServiceCost": fixedServiceCost,
            "replacedParts": priceBreakdown,
            "totalCost": totalCost
        ]

        db.collection("maintenanceRequests").document(logID).updateData(maintenanceData) { error in
            if let error = error {
                print("❌ Error updating maintenance request: \(error.localizedDescription)")
            } else {
                print("✅ Maintenance marked as Completed with cost details.")
            }
        }
    }
}


// ✅ Label Detail View (Fix for "Cannot Find in Scope" Error)
struct LabelDetailView: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.body)
        }
    }
}

// ✅ Inventory Selection View
struct InventorySelectionView: View {
    var inventoryItems: [(name: String, price: Double)] // 🔹 Now includes price
    var onSelect: (String, Double) -> Void // 🔹 Pass selected part & price
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List(inventoryItems, id: \.name) { item in
                Button(action: {
                    onSelect(item.name, item.price)  // ✅ Add Item & Price to Replaced Parts
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("$\(item.price, specifier: "%.2f")") // 🔹 Show price next to item
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Select Item")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


// ✅ Preview
//struct LogDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogDetailsView(logID: "testID", serviceStatus: .requested)
//    }
//}
