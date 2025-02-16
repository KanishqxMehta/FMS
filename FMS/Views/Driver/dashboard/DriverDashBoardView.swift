import SwiftUI

struct DriverDashBoardView: View {
    @State private var selectedTab = 0 // Track selected tab
    @State private var navigationPath = NavigationPath() // Navigation Path for programmatic navigation
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                // Main Dashboard View
                ExtractedView()
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                    .tag(0)
                
                // Trips View
//                DriverTripsview()
//                    .tabItem {
//                        Label("Trips", systemImage: "map.fill")
//                    }
//                    .tag(1)
                
                // Settings View
                DriverSettingView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(2)
            }
            .accentColor(.black)
            .navigationBarBackButtonHidden(true)
            .navigationTitle(getNavigationTitle())
        }
    }
    
    // Function to get the navigation title based on selected tab
    private func getNavigationTitle() -> String {
        switch selectedTab {
        case 0:
            return "Driver"
        case 1:
            return "Trips"
        case 2:
            return "Settings"
        default:
            return "Driver"
        }
    }
}
struct InfoCard: View {
    var icon: String
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.black)
                    .cornerRadius(8)
                Spacer()
                Text(value)
                    .font(.title2).bold()
            }
            .padding(.vertical, 3)
            Text(title)
                .font(.callout)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct TripCard: View {
    var type: String
    var route: String
    var time: String
    var date: String
    var eta: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(type)
                .bold()
                .foregroundColor(.white)
                .padding(.vertical, 2)
                .padding(.horizontal, 5)
                .background(Color.black)
                .cornerRadius(5)
            Text(route).font(.headline)
            Text(time).foregroundColor(.gray)
            HStack {
                Text("Departure: \(date)")
                Spacer()
                Text("ETA: \(eta)")
            }
            .font(.caption)
            .foregroundColor(.gray)
            HStack(spacing: 20) {
                Button("Accept") {}
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                Button("Reject") {}
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct ExtractedView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                HStack(spacing: 20) {
                    InfoCard(icon: "car.fill", title: "Total Trips", value: "24")
                    InfoCard(icon: "bolt.fill", title: "Distance Travelled", value: "250km")
                }

                Text("Upcoming Trips")
                    .font(.title2).bold()

                VStack(spacing: 15) {
                    TripCard(type: "Heavy Vehicle", route: "Delhi - Chd", time: "6:30pm - 8:30pm", date: "11th Feb, 2025", eta: "2 hrs.")
                    TripCard(type: "Light Vehicle", route: "Delhi - Chd", time: "6:30pm - 8:30pm", date: "11th Feb, 2025", eta: "2 hrs.")
                    TripCard(type: "Heavy Vehicle", route: "Delhi - Chd", time: "6:30pm - 8:30pm", date: "11th Feb, 2025", eta: "2 hrs.")
                    
                }
            }
            .padding()
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    DriverDashBoardView()
}
