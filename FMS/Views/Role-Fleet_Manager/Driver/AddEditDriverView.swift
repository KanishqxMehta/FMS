//
//  AddEditDriverView.swift
//  FMS
//
//  Created by Vanshika on 21/02/25.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AddEditDriverView: View {
    @ObservedObject var viewModel: DriverViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var driver: Driver
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var age: String = ""
    @State private var address: String = ""
    @State private var vehicleType: String = ""
    @State private var experienceInYears: String = ""
    @State private var distanceTraveled: String = "0 km"
    @State private var isCreatingUser: Bool = false
    @State private var errorMessage: String?
    @State private var isEditing: Bool = false
    @State private var showSuccessAlert = false

    var isFormValid: Bool {
        errorMessage = nil

        if let ageInt = Int(age), ageInt < 18 {
            errorMessage = "❌ Age must be at least 18."
            return false
        }

        if let expInt = Int(experienceInYears), expInt <= 0 {
            errorMessage = "❌ Experience must be at least 1 year."
            return false
        }

        if !driver.mobileNumber.isEmpty, driver.mobileNumber.count != 10 || !driver.mobileNumber.allSatisfy({ $0.isNumber }) {
            errorMessage = "❌ Mobile number must be exactly 10 digits."
            return false
        }

        if !driver.licenseID.isEmpty, driver.licenseID.count < 5 || !driver.licenseID.allSatisfy({ $0.isNumber }) {
            errorMessage = "❌ License ID must be at least 5 digits."
            return false
        }

        return !driver.name.isEmpty && !age.isEmpty && !address.isEmpty &&
               !vehicleType.isEmpty && !email.isEmpty
    }

    init(viewModel: DriverViewModel, driver: Driver?) {
        self.viewModel = viewModel
        _driver = State(initialValue: driver ?? Driver(
            id: UUID(), name: "", age: "", address: "", mobileNumber: "",
            driverStatus: .available, email: "", licenseID: "",
            vehicleType: [], totalTrips: 0, experienceInYears: 0, istanceTraveled: "0 km"
        ))
        _email = State(initialValue: driver?.email ?? "")
        _age = State(initialValue: driver?.age ?? "")
        _address = State(initialValue: driver?.address ?? "")
        _vehicleType = State(initialValue: driver?.vehicleType.first?.rawValue ?? "")
        _experienceInYears = State(initialValue: driver?.experienceInYears != nil ? "\(driver!.experienceInYears)" : "")
        _isEditing = State(initialValue: driver != nil)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Driver Details").bold()) {
                    TextField("Name", text: $driver.name)

                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                        .onChange(of: age) { _ in _ = isFormValid }

                    TextField("Address", text: $address)

                    TextField("Mobile Number", text: $driver.mobileNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: driver.mobileNumber) { _ in _ = isFormValid }

                    TextField("License ID", text: $driver.licenseID)
                        .keyboardType(.numberPad)
                        .onChange(of: driver.licenseID) { _ in _ = isFormValid }
                }

                Section(header: Text("Vehicle & Experience").bold()) {
                    Picker("Vehicle Type", selection: $vehicleType) {
                        ForEach(["Car", "Truck", "Mini Truck"], id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("Experience (Years)", text: $experienceInYears)
                        .keyboardType(.numberPad)
                        .onChange(of: experienceInYears) { _ in _ = isFormValid }
                }

                Section(header: Text("Login Credentials").bold()) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .disabled(isEditing)
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .navigationTitle(isEditing ? "Edit Driver" : "Add New Driver")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isCreatingUser {
                        ProgressView()
                    } else {
                        Button("Save") {
                            isCreatingUser = true
                            saveDriver()
                        }
                        .disabled(!isFormValid)
                    }
                }
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Driver saved successfully!"),
                    dismissButton: .default(Text("OK")) {
                        dismiss()
                    }
                )
            }
        }
    }

    // MARK: - Generate Secure Random Password
    private func generateRandomPassword(length: Int = 12) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*"
        return String((0..<length).map { _ in characters.randomElement()! })
    }

    // MARK: - Save Driver Function
    private func saveDriver() {
        if isFormValid {
            if !isEditing {
                password = generateRandomPassword()
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        isCreatingUser = false
                        errorMessage = "❌ Failed to create user: \(error.localizedDescription)"
                        return
                    }

                    guard let userID = authResult?.user.uid else {
                        isCreatingUser = false
                        errorMessage = "❌ Failed to get user ID."
                        return
                    }

                    saveDriverData(userID: userID)
                }
            } else {
                saveDriverData(userID: driver.id.uuidString)
            }
        }
    }

    private func saveDriverData(userID: String) {
        let driverData: [String: Any] = [
            "id": userID, // ✅ Ensuring driver document ID is the Firebase Auth UID
            "name": driver.name,
            "age": age,
            "address": address,
            "mobileNumber": driver.mobileNumber,
            "licenseID": driver.licenseID,
            "email": email,
            "vehicleType": [vehicleType],
            "driverStatus": driver.driverStatus.rawValue,
            "experienceInYears": Int(experienceInYears) ?? 0,
            "distanceTraveled": distanceTraveled
        ]

        Firestore.firestore().collection("drivers").document(userID).setData(driverData, merge: true) { error in
            DispatchQueue.main.async {
                isCreatingUser = false
                if let error = error {
                    errorMessage = "❌ Failed to save driver data: \(error.localizedDescription)"
                } else {
                    showSuccessAlert = true
                    if isEditing {
                        viewModel.fetchDrivers() // Refresh the list after editing
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct AddEditDriverView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditDriverView(viewModel: DriverViewModel(), driver: nil)
    }
}
