import SwiftUI

struct AddEditDriverView: View {
    @ObservedObject var viewModel: DriverViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var driver: Driver
    
    private var isFormValid: Bool {
        !driver.name.isEmpty &&
        !driver.age.isEmpty && Int(driver.age) != nil &&
        !driver.address.isEmpty &&
        !driver.mobileNumber.isEmpty &&
        !driver.email.isEmpty && driver.email.contains("@") &&
        !driver.licenseID.isEmpty
    }
    
    init(viewModel: DriverViewModel, driver: Driver?) {
        self.viewModel = viewModel
        _driver = State(initialValue: driver ?? Driver(name: "", age: "", address: "", mobileNumber: "", email: "", licenseID: "", vehicleType: [.car], experienceInYears: 0))
    }
    
    var body: some View {
            Form {
                Section(header: Text("Personal Details")) {
                    TextField("Enter driver's name", text: $driver.name)
                    TextField("Enter driver's age", text: $driver.age)
                        .keyboardType(.numberPad)
                    TextField("Enter driver's address", text: $driver.address)
                }
                
                Section(header: Text("Contact")) {
                    TextField("Enter driver's mobile", text: $driver.mobileNumber)
                        .keyboardType(.phonePad)
                    TextField("Enter driver's email", text: $driver.email)
                        .keyboardType(.emailAddress)
                }
                
                Section(header: Text("Vehicle License")) {
                    Picker("Type", selection: Binding(
                        get: { driver.vehicleType.first ?? .car }, // Selects the first type
                        set: { driver.vehicleType = [$0] } // Updates the array
                    )) {
                        ForEach(VehicleType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    TextField("Enter driver’s License ID", text: $driver.licenseID)
                }
            }
            .navigationTitle(driver.id == UUID() ? "New Driver" : "Edit Driver")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let index = viewModel.drivers.firstIndex(where: { $0.id == driver.id }) {
                            viewModel.drivers[index] = driver
                        } else {
                            viewModel.addDriver(driver)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!isFormValid)
                }
        }
    }
}

struct AddEditDriverView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditDriverView(viewModel: DriverViewModel(), driver: nil)
    }
}
