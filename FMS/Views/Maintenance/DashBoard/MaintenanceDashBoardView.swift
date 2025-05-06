//
//  MaintenanceDashBoardView.swift
//  FMS
//
//  Created by Divyanshu Sharma on 21/02/25.
//

import SwiftUI
import FirebaseFirestore

// MARK: - Home (Dashboard) View
struct MaintenanceDashBoardView: View {
    @State private var lowInventoryItems: [InventoryMainItem] = []  // 🔥 Real-time Low Inventory Tracking
    @State private var maintenanceRequests: [MaintenanceRequestModel] = []  // 🔥 Real-time Maintenance Requests
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 🔥 Pending Maintenance Requests (Stay at the Top)
                    let pendingRequests = maintenanceRequests.filter { $0.status == "Pending" }
                    if !pendingRequests.isEmpty {
                        SectionCard(
                            icon: "wrench.fill",
                            title: "Maintenance Requests",
                            minHeight: 250
                        ) {
                            VStack(spacing: 16) {
                                ForEach(pendingRequests) { request in
                                    MaintenanceRequestCard(request: request, onStatusChange: updateRequestStatus)
                                }
                            }
                        }
                    }else {
                        Text("No Requests")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    }

                    // 🔥 Low Inventory Section (No Change)
                    if !lowInventoryItems.isEmpty {
                        SectionCard(
                            icon: "tag.fill",
                            title: "Low Inventory",
                            minHeight: 180
                        ) {
                            VStack(spacing: 12) {
                                ForEach(lowInventoryItems, id: \.name) { item in
                                    item
                                }
                            }
                        }
                    }

                    // 🔥 In Progress & Completed Requests (Always Show Below Low Inventory)
                    let completedOrInProgressRequests = maintenanceRequests.filter { $0.status == "In Progress" || $0.status == "Completed" }
                    if !completedOrInProgressRequests.isEmpty {
                        SectionCard(
                            icon: "clock.fill",
                            title: "Work Orders",
                            minHeight: 250
                        ) {
                            VStack(spacing: 16) {
                                ForEach(completedOrInProgressRequests) { request in
                                    MaintenanceRequestCard(request: request, onStatusChange: updateRequestStatus)
                                }
                            }
                        }
                    } else {
                        Text("No Ongoing or Completed Trips")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .navigationBarBackButtonHidden(true)
            }
            .navigationTitle("Maintenance")
        }
        .onAppear {
            fetchLowInventoryItems()  // 🔥 Fetch Low Inventory from Firestore
            fetchMaintenanceRequests()  // 🔥 Fetch Maintenance Requests from Firestore
        }
    }

    // 🔥 Fetch Low Inventory Items from Firestore
    private func fetchLowInventoryItems() {
        FirestoreService.shared.fetchInventoryItems { items in
            let lowStockItems = items
                .filter { $0.status == "Low Stock" || $0.status == "Critical" }
                .map { InventoryMainItem(name: $0.name, quantity: $0.quantity) }
            
            DispatchQueue.main.async {
                self.lowInventoryItems = lowStockItems
            }
        }
    }

    // 🔥 Fetch Maintenance Requests from Firestore
    private func fetchMaintenanceRequests() {
        FirestoreService.shared.fetchMaintenanceRequests { requests in
            DispatchQueue.main.async {
                self.maintenanceRequests = requests
            }
        }
    }

    // 🔥 Update Maintenance Request Status in Firestore
    private func updateRequestStatus(requestID: String, newStatus: String) {
        FirestoreService.shared.updateMaintenanceRequestStatus(requestID: requestID, newStatus: newStatus) { success in
            if success {
                DispatchQueue.main.async {
                    if let index = maintenanceRequests.firstIndex(where: { $0.id == requestID }) {
                        maintenanceRequests[index].status = newStatus
                    }
                }
            }
        }
    }
}

// ✅ Maintenance Request Card (Unchanged)
struct MaintenanceRequestCard: View {
    var request: MaintenanceRequestModel
    var onStatusChange: (String, String) -> Void  // Closure for status update

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Vehicle: \(request.vehicleName)")
                .font(.headline)
                .bold()
            
            Text("Due Date: \(request.dueDate.formatted(date: .abbreviated, time: .omitted))")
                .foregroundColor(.gray)
            
//            Text("Service Type: \(request.serviceType)")
//                .foregroundColor(.gray)

            if request.status == "Pending" {
                HStack {
                    Button(action: {
                        onStatusChange(request.id, "In Progress")
                    }) {
                        Text("Accept")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        onStatusChange(request.id, "Rejected")
                    }) {
                        Text("Reject")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

// ✅ Section Card Component (Unchanged)
struct SectionCard<Content: View>: View {
    let icon: String
    let title: String
    let minHeight: CGFloat
    let content: Content
    
    init(icon: String, title: String, minHeight: CGFloat = 200, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.minHeight = minHeight
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            
            content
                .padding(.horizontal)
                .padding(.bottom, 10)
            
        }
        .frame(minHeight: minHeight)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// ✅ Inventory Item Row (Unchanged)
struct InventoryMainItem: View {
    let name: String
    let quantity: Int
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text("Quantity: \(quantity) Left")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// ✅ Preview (Unchanged)
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        MaintenanceDashBoardView()
    }
}
