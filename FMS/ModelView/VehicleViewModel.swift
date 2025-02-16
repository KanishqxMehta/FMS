//
//  VehicleViewModel.swift
//  FMS
//
//  Created by Kanishq Mehta on 16/02/25.
//

import Foundation

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
