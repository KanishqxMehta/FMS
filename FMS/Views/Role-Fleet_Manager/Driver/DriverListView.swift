//
//  DriverListView.swift
//  FMS
//
//  Created by Vanshika on 21/02/25.
//
import SwiftUI
import Firebase

struct DriverListView: View {
    @StateObject private var viewModel = DriverViewModel()
    @State private var showingAddDriver = false
    @State private var selectedDriver: Driver? = nil
    @State private var showDeleteConfirmation = false
    @State private var driverToDelete: Driver? = nil

    var availableDriversCount: Int {
        viewModel.drivers.filter { $0.driverStatus == .available }.count
    }

    var unavailableDriversCount: Int {
        viewModel.drivers.filter { $0.driverStatus == .unavailable }.count
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Drivers")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 10)

                HStack(spacing: 15) {
                    DriverStatusView(title: "Available", count: availableDriversCount)
                    DriverStatusView(title: "Unavailable", count: unavailableDriversCount)
                }
                .padding(.horizontal)

                if viewModel.drivers.isEmpty {
                    VStack {
                        Text("No drivers available.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    }
                } else {
                    List(viewModel.drivers) { driver in
                        NavigationLink(destination: DriverDetailsView(selectedDriver: driver)) {
                            DriverCardView(driver: driver)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                driverToDelete = driver
                                showDeleteConfirmation = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedDriver = nil
                        showingAddDriver = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddDriver) {
                AddEditDriverView(viewModel: viewModel, driver: nil) // ✅ Creating a new driver
            }
            .onAppear {
                viewModel.fetchDrivers()
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Driver"),
                    message: Text("Are you sure you want to delete this driver?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let driver = driverToDelete {
                            viewModel.deleteDriver(driver)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

// MARK: - Preview
struct DriverListView_Previews: PreviewProvider {
    static var previews: some View {
        DriverListView()
    }
}

