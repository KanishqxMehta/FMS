import SwiftUI
import FirebaseFirestore

struct ItemEntry: Identifiable, Codable {
    let id = UUID()
    var partName: String
    var quantity: String
    var pricePerUnit: String
    var totalValue: String
    var label: String
}

struct AddInventoryView: View {
    @State private var itemEntry = ItemEntry(partName: "Engine Oil", quantity: "", pricePerUnit: "", totalValue: "", label: "In Stock")
    @Environment(\.presentationMode) var presentationMode
    @Binding var inventoryItems: [InventoryItem]
    
    private let availableParts = ["Engine Oil", "Gear Oil"]
    
    private var isSaveDisabled: Bool {
        itemEntry.partName.isEmpty || itemEntry.quantity.isEmpty || itemEntry.pricePerUnit.isEmpty || itemEntry.totalValue.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Part Name")
                        Spacer()
                        Picker("", selection: $itemEntry.partName) {
                            ForEach(availableParts, id: \.self) { part in
                                Text(part).tag(part)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField("Enter quantity", text: $itemEntry.quantity)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Price per Unit")
                        Spacer()
                        TextField("Enter price", text: $itemEntry.pricePerUnit)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Total Value")
                        Spacer()
                        TextField("Calculated total", text: $itemEntry.totalValue)
                            .multilineTextAlignment(.trailing)
                            .disabled(true)
                    }
                    
                    Picker("Label", selection: $itemEntry.label) {
                        Text("In Stock").tag("In Stock")
                        Text("Low Stock").tag("Low Stock")
                        Text("Critical").tag("Critical")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveItem()
                    }
                    .disabled(isSaveDisabled)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onChange(of: itemEntry.quantity) { _ in
                calculateTotal()
            }
            .onChange(of: itemEntry.pricePerUnit) { _ in
                calculateTotal()
            }
        }
    }
    
    private func calculateTotal() {
        if let quantity = Int(itemEntry.quantity), let price = Double(itemEntry.pricePerUnit) {
            itemEntry.totalValue = String(format: "%.2f", Double(quantity) * price)
        } else {
            itemEntry.totalValue = ""
        }
    }
    
    private func saveItem() {
            let quantity = Int(itemEntry.quantity) ?? 0
            let price = Double(itemEntry.pricePerUnit) ?? 0.0
            let newItem = InventoryItem(
                name: itemEntry.partName,
                quantity: quantity,
                price: price,
                status: itemEntry.label.isEmpty ? "In Stock" : itemEntry.label
            )
            
            FirestoreService.shared.addInventoryItem(newItem) { success, error in
                if success {
                    DispatchQueue.main.async {
                        inventoryItems.append(newItem)
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    print("❌ Error saving inventory item: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
}

struct InventoryEntryView_Previews: PreviewProvider {
    @State static var mockInventoryItems: [InventoryItem] = []
    
    static var previews: some View {
        AddInventoryView(inventoryItems: .constant(mockInventoryItems))
    }
}
