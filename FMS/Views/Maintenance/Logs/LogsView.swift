//
//  LogsView.swift
//  Maintenance
//
//  Created by Naman Sharma on 21/02/25.
//

import SwiftUI
import FirebaseFirestore

// ✅ Log Model
struct LogEntry: Identifiable {
    var id: String
    var vehicleNumber: String
    var model: String
    var totalDriven: String
    var dueDate: String
    var serviceType: String
    var estimatedCost: String
    var totalCost: Double
    var status: String // "Pending", "In Progress", "Completed"
}

// ✅ Logs View
struct LogsView: View {
    @State private var selectedSegment = "Requests"
    @State private var searchText = ""
    @State private var logs: [LogEntry] = []  // 🔥 Real-time Firestore Data

    let segments = ["Requests", "In Progress", "Completed"]

    // 🔄 Mapping for Firestore Status
    let statusMapping: [String: String] = [
        "Requests": "Pending",
        "In Progress": "In Progress",
        "Completed": "Completed"
    ]

    var filteredLogs: [LogEntry] {
        logs.filter {
            $0.status == statusMapping[selectedSegment] &&
            (searchText.isEmpty || $0.vehicleNumber.contains(searchText) || $0.model.contains(searchText))
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                
                MaintenanceSearchBar(text: $searchText)
                    .padding(.horizontal)
                
                Picker("Segments", selection: $selectedSegment) {
                    ForEach(segments, id: \.self) { segment in
                        Text(segment).tag(segment)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                

                List {
                    if filteredLogs.isEmpty {
                        Text("No \(selectedSegment.lowercased()) found")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(filteredLogs) { log in
                            if selectedSegment == "Requests" {
                                RequestCardView(log: log, onStatusChange: updateLogStatus)
                            } else {
                                LogCardView(log: log)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Logs")
            .onAppear {
                fetchLogs()
            }
        }

    }

    // ✅ Fetch Logs from Firestore (Real-Time Updates)
    private func fetchLogs() {
        let db = Firestore.firestore()
        
        db.collection("maintenanceRequests").addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Error fetching logs: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("❌ No maintenance request documents found.")
                return
            }

            var fetchedLogs: [LogEntry] = []

            for document in documents {
                let data = document.data()
                print("📄 Debug - Fetched Data: \(data)")

                let id = document.documentID
                let vehicleName = data["vehicleName"] as? String ?? "Unknown"
                let serviceType = data["serviceType"] as? String ?? "N/A"
                let totalDriven = data["totalDriven"] as? String ?? "N/A"
                let dueDate = (data["dueDate"] as? Timestamp)?.dateValue().formatted(date: .abbreviated, time: .omitted) ?? "N/A"
                let estimatedCost = data["estimatedCost"] as? String ?? "$0"
                let totalCost = data["totalCost"] as? Double ?? 50.0
                let status = data["status"] as? String ?? "Pending"

                let log = LogEntry(
                    id: id,
                    vehicleNumber: vehicleName,
                    model: serviceType,
                    totalDriven: totalDriven,
                    dueDate: dueDate,
                    serviceType: serviceType,
                    estimatedCost: estimatedCost,
                    totalCost: totalCost,
                    status: status
                )
                fetchedLogs.append(log)
            }

            DispatchQueue.main.async {
                self.logs = fetchedLogs
            }
        }
    }

    // ✅ Update Log Status in Firestore & Refresh UI
    private func updateLogStatus(logID: String, newStatus: String) {
        let db = Firestore.firestore()
        db.collection("maintenanceRequests").document(logID).updateData([
            "status": newStatus
        ]) { error in
            if let error = error {
                print("❌ Error updating log status: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                fetchLogs() // 🔥 Ensure UI updates immediately
            }
        }
    }
}

// ✅ General Log Card (for In Progress & Completed)
struct LogCardView: View {
    let log: LogEntry

    var body: some View {
        NavigationLink(destination: LogDetailsView(
            logID: log.id,
            vehicleNumber: log.vehicleNumber,
            vehicleModel: log.model,
            serviceDate: log.dueDate,
//            serviceType: log.serviceType,
            dueDate: log.dueDate,
            cost: log.estimatedCost,
            serviceStatus: log.status == "In Progress" ? .inProgress : .completed
            
        )) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "car.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)

                    VStack(alignment: .leading) {
                        Text(log.vehicleNumber)
                            .font(.headline)
                        Text(log.model)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                Divider()

                HStack {
                    Text("Due: \(log.dueDate)")
                        .font(.body)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

// ✅ Search Bar Component
struct MaintenanceSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}

// ✅ Request Card (with Accept/Reject buttons)
struct RequestCardView: View {
    let log: LogEntry
    var onStatusChange: (String, String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "car.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)

                VStack(alignment: .leading) {
                    Text(log.vehicleNumber)
                        .font(.headline)
                    Text(log.model)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            Divider()

            HStack {
                VStack(alignment: .leading) {
                    Text("Due Date").font(.caption).foregroundColor(.gray)
                    Text(log.dueDate).font(.body)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Service Type").font(.caption).foregroundColor(.gray)
                    Text(log.serviceType).font(.body)
                }
            }

            HStack {
                Button(action: {
                    onStatusChange(log.id, "In Progress")
                }) {
                    Text("Accept")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    onStatusChange(log.id, "Rejected")
                }) {
                    Text("Reject")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// ✅ Preview
struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}
