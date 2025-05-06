//
//  InventoryView.swift
//  Maintenance
//
//  Created by Brahmjot Singh Tatla on 19/02/25.
//

import SwiftUI
import FirebaseFirestore

struct InventoryView: View {
    @State private var selectedFilter = 0
    @State private var showingInventoryEntry = false
    @State private var inventoryItems: [InventoryItem] = [] // 🔥 Firestore Data

    // ✅ Merging Items with Same Name
    var mergedItems: [InventoryItem] {
        var itemDict: [String: InventoryItem] = [:]

        for item in inventoryItems {
            if let existingItem = itemDict[item.name] {
                // Merge quantities if the item name exists
                itemDict[item.name] = InventoryItem(
                    id: existingItem.id,
                    name: existingItem.name,
                    quantity: existingItem.quantity + item.quantity,
                    price: existingItem.price, // Keeping price of first occurrence (adjust if needed)
                    status: item.status // Assuming latest status is preferred
                )
            } else {
                itemDict[item.name] = item
            }
        }
        
        return Array(itemDict.values)
    }

    var filteredItems: [InventoryItem] {
        let items = mergedItems
        if selectedFilter == 1 {
            return items.filter { $0.status == "Low Stock" || $0.status == "Critical" }
        }
        return items
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    SearchBar()
                }
                .padding(.horizontal)

                // Info Cards
                HStack(spacing: 16) {
                    MaintenanceInfoCard(icon: "cube.box", count: mergedItems.count, label: "Spare Parts")
                    MaintenanceInfoCard(icon: "exclamationmark.triangle", count: mergedItems.filter { $0.status == "Low Stock" || $0.status == "Critical" }.count, label: "Low Stock")
                }
                .padding(.horizontal)

                // Picker
                Picker("", selection: $selectedFilter) {
                    Text("All Items").tag(0)
                    Text("Low Stock").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Inventory List
                ScrollView {
                    ForEach(filteredItems) { item in
                        InventoryItemView(item: item)
                    }
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                Button(action: {
                    showingInventoryEntry = true
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $showingInventoryEntry) {
                    AddInventoryView(inventoryItems: $inventoryItems)
                }
            }
        }
        .background(Color(.systemGray6))
        .onAppear {
            fetchInventoryItems() // 🔥 Fetch inventory from Firestore
        }
    }

    // 🔥 Fetch Inventory from Firestore (Real-time Updates)
    private func fetchInventoryItems() {
        FirestoreService.shared.fetchInventoryItems { items in
            self.inventoryItems = items
        }
    }
}

// ✅ Inventory Item Model
struct InventoryItem: Identifiable, Codable {
    var id: String = UUID().uuidString // Firestore uses String IDs
    var name: String
    var quantity: Int
    var price: Double
    var status: String

    // 🔹 Explicitly define coding keys (optional)
    enum CodingKeys: String, CodingKey {
        case id, name, quantity, price, status
    }
}

// ✅ Inventory Item View (Updated UI)
struct InventoryItemView: View {
    let item: InventoryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(item.name)
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                // Status badge
                Text(item.status)
                    .font(.caption)
                    .bold()
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(item.status == "Critical" || item.status == "Low Stock" ? Color.red : Color.black, lineWidth: 1)
                    )
                    .foregroundColor(item.status == "Critical" || item.status == "Low Stock" ? .black : .black)
                    .cornerRadius(12)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Quantity")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(item.quantity) units")
                        .font(.headline)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Price")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("$ \(item.price, specifier: "%.1f")")
                        .font(.headline)
                        .bold()
                }
            }
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
}

// ✅ Search Bar Component
struct SearchBar: View {
    @State private var searchText = ""

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(10)
                .background(Color(.white))
                .cornerRadius(8)
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color(.white))
        .cornerRadius(12)
    }
}

// ✅ Info Card Component
struct MaintenanceInfoCard: View {
    let icon: String
    let count: Int
    let label: String

    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.black)
                Text("\(count)")
                    .font(.title)
                    .bold()
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// ✅ Preview
struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
