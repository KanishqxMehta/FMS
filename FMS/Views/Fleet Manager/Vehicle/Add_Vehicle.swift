//
//  Add_Vehicle.swift
//  FMS
//
//  Created by Brahmjot Singh Tatla on 14/02/25.
//

import SwiftUI

// MARK: - ViewModel
class VehicleViewModel: ObservableObject {
    @Published var vehicles: [Vehicle] = [] {
        didSet { saveVehicles() }
    }
    
    init() { loadVehicles() }
    
    func addVehicle(_ vehicle: Vehicle) { vehicles.append(vehicle) }
    
    func updateVehicle(_ updatedVehicle: Vehicle) {
        if let index = vehicles.firstIndex(where: { $0.id == updatedVehicle.id }) {
            vehicles[index] = updatedVehicle
        }
    }
    
    private func saveVehicles() {
        if let encoded = try? JSONEncoder().encode(vehicles) {
            UserDefaults.standard.set(encoded, forKey: "vehicles")
        }
    }
    
    private func loadVehicles() {
        if let savedData = UserDefaults.standard.data(forKey: "vehicles"),
           let decodedVehicles = try? JSONDecoder().decode([Vehicle].self, from: savedData) {
            vehicles = decodedVehicles
        }
    }
}

// MARK: - Add Vehicle View
struct AddVehicleView: View {
    @EnvironmentObject var vehicleViewModel: VehicleViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var model = ""
    @State private var vin = ""
    @State private var type: VehicleType = .car
    @State private var manufactureYear = Calendar.current.component(.year, from: Date())
    @State private var rcExpiryDate = Date()
    @State private var pollutionExpiryDate = Date()
    @State private var insuranceExpiryDate = Date()
    @State private var permitExpiryDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("INFORMATION").bold().foregroundColor(.gray)) {
                    TextField("Enter driver's name", text: $model)
                    TextField("Enter identification number", text: $vin)
                    Picker("Select Vehicle Type", selection: $type) {
                        ForEach(VehicleType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    TextField("Enter manufacturing year", value: $manufactureYear, formatter: NumberFormatter())
                }
                
                Section(header: Text("DOCUMENT VALIDITY").bold().foregroundColor(.gray)) {
                    DatePicker("RC Expiry Date", selection: $rcExpiryDate, displayedComponents: .date)
                    DatePicker("Pollution Expiry Date", selection: $pollutionExpiryDate, displayedComponents: .date)
                    DatePicker("Insurance Expiry Date", selection: $insuranceExpiryDate, displayedComponents: .date)
                    DatePicker("Permit's Expiry Date", selection: $permitExpiryDate, displayedComponents: .date)
                }
            }
            .navigationBarTitle("Add new Vehicle", displayMode: .inline)
            .navigationBarItems(leading: Button("Vehicles") { presentationMode.wrappedValue.dismiss() },
                                trailing: Button("Save") { saveVehicle() })
        }
    }
    
    func saveVehicle() {
        let newVehicle = Vehicle(
            vehicleName: "Tata Ultra",
            vehicleType: .car,
            totalTrips: "120",
            status: "Active"
        )
        vehicleViewModel.addVehicle(newVehicle)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview
struct AddVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        AddVehicleView().environmentObject(VehicleViewModel())
    }
}
