//
//  VehicleViewModel.swift
//  FMS
//
//  Created by Kanishq Mehta on 16/02/25.
//

import Foundation

class VehicleViewModel: ObservableObject {
    @Published var vehicles: [Vehicle] = []

    init() { fetchVehicles() }

    func addVehicle(_ vehicle: Vehicle) {
        FirestoreService.shared.saveVehicle(vehicle: vehicle) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.vehicles.append(vehicle)
                }
            }
        }
    }

    func updateVehicle(_ updatedVehicle: Vehicle) {
        FirestoreService.shared.saveVehicle(vehicle: updatedVehicle) { success, error in
            if success {
                DispatchQueue.main.async {
                    if let index = self.vehicles.firstIndex(where: { $0.id == updatedVehicle.id }) {
                        self.vehicles[index] = updatedVehicle
                    }
                }
            }
        }
    }

    func fetchVehicles() {
        FirestoreService.shared.fetchVehicles { vehicles in
            DispatchQueue.main.async {
                self.vehicles = vehicles
            }
        }
    }

    func deleteVehicle(_ vehicle: Vehicle) {
        FirestoreService.shared.deleteVehicle(vehicleID: vehicle.id.uuidString) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.vehicles.removeAll { $0.id == vehicle.id }
                }
            }
        }
    }
}
