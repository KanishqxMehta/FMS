import SwiftUI

struct DriverFormView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = UserDefaults.standard.string(forKey: "name") ?? ""
    @State private var age: String = UserDefaults.standard.string(forKey: "age") ?? ""
    @State private var address: String = UserDefaults.standard.string(forKey: "address") ?? ""
    @State private var mobile: String = UserDefaults.standard.string(forKey: "mobile") ?? ""
    @State private var email: String = UserDefaults.standard.string(forKey: "email") ?? ""
    @State private var vehicleType: VehicleType = .car  // Default vehicle type
    @State private var licenseID: String = UserDefaults.standard.string(forKey: "licenseID") ?? ""
    @State private var showAlert = false  // State variable for showing alert

    private var isFormValid: Bool {
        return !name.isEmpty &&
               !age.isEmpty && Int(age) != nil &&
               !address.isEmpty &&
               !mobile.isEmpty &&
               !email.isEmpty && email.contains("@") &&
               !licenseID.isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Details").font(.headline)) {
                    TextField("Enter driver's name", text: $name)
                    TextField("Enter driver's age", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Enter driver's address", text: $address)
                }
                
                Section(header: Text("Contact").font(.headline)) {
                    TextField("Enter driver's mobile", text: $mobile)
                        .keyboardType(.phonePad)
                    TextField("Enter driver's email", text: $email)
                        .keyboardType(.emailAddress)
                }
                
                Section(header: Text("Vehicle License").font(.headline)) {
                    Picker("Type", selection: $vehicleType) {
                        ForEach(VehicleType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    TextField("Enter driver’s License ID", text: $licenseID)
                }
            }
            .navigationTitle("Add New Driver")
            .navigationBarItems(
                leading: Button("Drivers") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveDriverDetails()
                }
                .foregroundColor(isFormValid ? .black : .gray)
                .disabled(!isFormValid)
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Driver Added Successfully!"),
                    dismissButton: .default(Text("OK"), action: clearFields)
                )
            }
        }
    }

    private func saveDriverDetails() {
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(age, forKey: "age")
        UserDefaults.standard.set(address, forKey: "address")
        UserDefaults.standard.set(mobile, forKey: "mobile")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(vehicleType.rawValue, forKey: "vehicleType")
        UserDefaults.standard.set(licenseID, forKey: "licenseID")

        showAlert = true
    }

    private func clearFields() {
        name = ""
        age = ""
        address = ""
        mobile = ""
        email = ""
        vehicleType = .car
        licenseID = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DriverFormView()
    }
}

