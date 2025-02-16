import SwiftUI

struct DriverListView: View {
    @StateObject private var viewModel = DriverViewModel()
    @State private var showingAddDriver = false
    @State private var selectedDriver: Driver? = nil

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Drivers")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 10)

                HStack(spacing: 15) {
                    DriverStatusView(title: "Available", count: viewModel.drivers.count)
                    DriverStatusView(title: "On Leave", count: 5)
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.drivers) { driver in
                            DriverCardView(driver: driver)
                                .onTapGesture {
                                    // Create a copy of the driver to prevent reference issues
                                    selectedDriver = driver
                                    showingAddDriver = true
                                }
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .toolbar {
                Button(action: {
                    selectedDriver = nil
                    showingAddDriver = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddDriver) {
                NavigationView {
                    if showingAddDriver {  // Add this safety check
                        AddEditDriverView(
                            viewModel: viewModel,
                            driver: selectedDriver
                        )
                    }
                }
            }
        }
    }
}

struct DriversView_Previews: PreviewProvider {
    static var previews: some View {
        DriverListView()
    }
    
}

