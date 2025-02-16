import SwiftUI

struct RoleSelectionView: View {
    var body: some View {
        NavigationStack { // Use NavigationStack to handle the navigation
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 25) {
                    Spacer(minLength: 30)
                    
                    // Welcome Text
                    Text("Welcome to Fleet Management")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Choose your role to get started")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Image Placeholder
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 0)
                    
                    // Fleet Manager Button
                    NavigationLink(destination: FleetManagerLoginView()) {
                        HStack {
                            Image(systemName: "briefcase.fill")
                                .foregroundColor(.white)
                            Text("Fleet Manager")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.black)
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 30)
                    
                    // Driver Button
                    NavigationLink(destination: DriverLoginView()) {
                        HStack {
                            Image(systemName: "car.fill")
                                .foregroundColor(.white)
                            Text("Driver")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.black)
                        .cornerRadius(25)
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                }
            }
        }
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView()
    }
}
