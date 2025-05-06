import SwiftUI

struct AddEditVehicleView: View {
    @EnvironmentObject var vehicleViewModel: VehicleViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var vehicle: Vehicle?

    @State private var model: String
    @State private var vin: String
    @State private var type: VehicleType
    @State private var manufactureYear: String
    @State private var rcExpiryDate: Date
    @State private var pollutionExpiryDate: Date
    @State private var insuranceExpiryDate: Date
    @State private var permitExpiryDate: Date
    @State private var chassisNumber: String
    @State private var engineNumber: String
    @State private var showConfirmationAlert = false
    @State private var showCancelAlert = false
    @State private var errorMessages: [String: String] = [:]

    let vehicleTypes = VehicleType.allCases

    init(vehicle: Vehicle? = nil) {
        self.vehicle = vehicle
        _model = State(initialValue: vehicle?.vehicleName ?? "")
        _vin = State(initialValue: vehicle?.vin ?? "")
        _type = State(initialValue: vehicle?.vehicleType ?? .car)
        _manufactureYear = State(initialValue: String(vehicle?.year ?? Calendar.current.component(.year, from: Date())))
        _rcExpiryDate = State(initialValue: vehicle?.rcExpiryDate ?? Date())
        _pollutionExpiryDate = State(initialValue: vehicle?.pollutionExpiryDate ?? Date())
        _insuranceExpiryDate = State(initialValue: vehicle?.insuranceExpiryDate ?? Date())
        _permitExpiryDate = State(initialValue: vehicle?.permitExpiryDate ?? Date())
        _chassisNumber = State(initialValue: vehicle?.chassisNumber != nil ? String(vehicle!.chassisNumber) : "")
        _engineNumber = State(initialValue: vehicle?.engineNumber != nil ? String(vehicle!.engineNumber) : "")
    }

    var isSaveDisabled: Bool {
        return model.isEmpty ||
               vin.isEmpty ||
               chassisNumber.isEmpty ||
               engineNumber.isEmpty ||
               manufactureYear.isEmpty
    }

    
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("INFORMATION").bold().foregroundColor(.gray)) {
                    TextField("Enter Vehicle's name", text: $model)

                    TextField("Enter identification number", text: $vin)
                        .keyboardType(.numberPad)
                        .onChange(of: vin) { validateField("vin", value: vin) }
                    if let errorMessage = errorMessages["vin"] {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    TextField("Enter chassis number", text: $chassisNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: chassisNumber) { validateField("chassisNumber", value: chassisNumber) }
                    if let errorMessage = errorMessages["chassisNumber"] {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    TextField("Enter engine number", text: $engineNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: engineNumber) { validateField("engineNumber", value: engineNumber) }
                    if let errorMessage = errorMessages["engineNumber"] {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Picker("Select Vehicle Type", selection: $type) {
                        ForEach(vehicleTypes, id: \.self) { vehicle in
                            Text(vehicle.rawValue.capitalized).tag(vehicle)
                        }
                    }

                    TextField("Enter manufacturing year", text: $manufactureYear)
                        .keyboardType(.numberPad)
                        .onChange(of: manufactureYear) { validateField("manufactureYear", value: manufactureYear) }
                    if let errorMessage = errorMessages["manufactureYear"] {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                Section(header: Text("DOCUMENT VALIDITY").bold().foregroundColor(.gray)) {
                    DatePicker("RC Expiry Date", selection: $rcExpiryDate, displayedComponents: .date)
                    DatePicker("Pollution Expiry Date", selection: $pollutionExpiryDate, displayedComponents: .date)
                    DatePicker("Insurance Expiry Date", selection: $insuranceExpiryDate, displayedComponents: .date)
                    DatePicker("Permit's Expiry Date", selection: $permitExpiryDate, displayedComponents: .date)
                }
            }
            .navigationTitle(vehicle == nil ? "Add New Vehicle" : "Edit Vehicle")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showCancelAlert = true
                },
                trailing: Button("Save") { validateAndSave() }
                    .disabled(isSaveDisabled)                     .alert(isPresented: $showConfirmationAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("The vehicle was added successfully"),
                            dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
            )
            .alert(isPresented: $showCancelAlert) {
                Alert(
                    title: Text("Discard Changes?"),
                    message: Text("Are you sure you want to discard your changes?"),
                    primaryButton: .destructive(Text("Discard")) {
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    
    
    
   
    func validateField(_ field: String, value: String) {
        
        if value.isEmpty {
            errorMessages[field] = nil
            return
        }

        switch field {
        case "chassisNumber", "engineNumber":
            if !value.allSatisfy({ $0.isNumber }) {
                errorMessages[field] = "❌ Must contain only numbers."
            } else {
                errorMessages[field] = nil
            }

        case "manufactureYear":
            if let yearInt = Int(value), yearInt >= 1900, yearInt <= Calendar.current.component(.year, from: Date()) {
                errorMessages[field] = nil
            } else {
                errorMessages[field] = "❌ Year must be between 1900 and the current year."
            }

        default:
            break
        }
        
    }

    
    
    func validateAndSave() {
      
        validateField("vin", value: vin)
        validateField("chassisNumber", value: chassisNumber)
        validateField("engineNumber", value: engineNumber)
        validateField("manufactureYear", value: manufactureYear)

        if !errorMessages.isEmpty || isSaveDisabled {
            return
        }

        let newVehicle = Vehicle(
            id: vehicle?.id ?? UUID(),
            vehicleName: model,
            year: Int(manufactureYear) ?? Calendar.current.component(.year, from: Date()),
            vehicleType: type,
            totalTrips: vehicle?.totalTrips ?? "0",
            status: vehicle?.status ?? .available,
            vin: vin,
            rcExpiryDate: rcExpiryDate,
            pollutionExpiryDate: pollutionExpiryDate,
            insuranceExpiryDate: insuranceExpiryDate,
            permitExpiryDate: permitExpiryDate,
            chassisNumber: Int(chassisNumber) ?? 0,
            engineNumber: Int(engineNumber) ?? 0
        )

        if vehicle != nil {
            vehicleViewModel.updateVehicle(newVehicle)
        } else {
            vehicleViewModel.addVehicle(newVehicle)
        }
        showConfirmationAlert = true
    }
}
