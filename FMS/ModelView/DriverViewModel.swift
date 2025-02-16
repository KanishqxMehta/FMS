//
//  DriverViewModel.swift
//  FMS
//
//  Created by Kanishq Mehta on 16/02/25.
//


import Foundation

class DriverViewModel: ObservableObject {
    @Published var drivers: [Driver] = []
    
    func addDriver(_ driver: Driver) {
        drivers.append(driver)
    }
    
    func removeDriver(at indexSet: IndexSet) {
        drivers.remove(atOffsets: indexSet)
    }
    
    func updateDriver(_ driver: Driver) {
        if let index = drivers.firstIndex(where: { $0.id == driver.id }) {
            drivers[index] = driver
        }
    }
}
