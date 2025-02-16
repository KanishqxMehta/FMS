//
//  Add_Vehicle.swift
//  FMS
//
//  Created by Brahmjot Singh Tatla on 14/02/25.
//

import SwiftUI


// MARK: - Add Vehicle View
struct AddEditVehicleView: View {
    @EnvironmentObject var vehicleViewModel: VehicleViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var vehicle: Vehicle?  // Optional vehicle for editing
    
    @State private var model = ""
    @State private var vin = ""
    @State private var type: VehicleType = .car
    @State private var manufactureYear = Calendar.current.component(.year, from: Date())
    @State private var rcExpiryDate = Date()
    @State private var pollutionExpiryDate = Date()
    @State private var insuranceExpiryDate = Date()
    @State private var permitExpiryDate = Date()

    init(vehicle: Vehicle? = nil) {
        self.vehicle = vehicle
        _model = State(initialValue: vehicle?.vehicleName ?? "")
        _vin = State(initialValue: vehicle?.vin ?? "")
        _type = State(initialValue: vehicle?.vehicleType ?? .car)
        _manufactureYear = State(initialValue: vehicle?.year ?? Calendar.current.component(.year, from: Date()))
        _rcExpiryDate = State(initialValue: vehicle?.rcExpiryDate ?? Date())
        _pollutionExpiryDate = State(initialValue: vehicle?.pollutionExpiryDate ?? Date())
        _insuranceExpiryDate = State(initialValue: vehicle?.insuranceExpiryDate ?? Date())
        _permitExpiryDate = State(initialValue: vehicle?.permitExpiryDate ?? Date())
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("INFORMATION").bold().foregroundColor(.gray)) {
                    TextField("Enter Vehicle's name", text: $model)
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
            .navigationBarTitle(vehicle == nil ? "Add new Vehicle" : "Edit Vehicle", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                                trailing: Button("Save") { saveVehicle() })
        }
    }
    
    func saveVehicle() {
        let newVehicle = Vehicle(
            id: vehicle?.id ?? UUID(),
            vehicleName: model,
            year: manufactureYear,
            vehicleType: type,
            totalTrips: vehicle?.totalTrips ?? "0",
            status: vehicle?.status ?? "Available",
            vin: vin,
            rcExpiryDate: rcExpiryDate,
            pollutionExpiryDate: pollutionExpiryDate,
            insuranceExpiryDate: insuranceExpiryDate,
            permitExpiryDate: permitExpiryDate
        )
        
        if let existingVehicle = vehicle {
            vehicleViewModel.updateVehicle(newVehicle)  // Update
        } else {
            vehicleViewModel.addVehicle(newVehicle)  // Add new
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview
struct AddVehicleView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditVehicleView().environmentObject(VehicleViewModel())
    }
}
