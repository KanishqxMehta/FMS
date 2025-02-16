import SwiftUI

struct FleetManagerLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isLoggedIn: Bool = false // State to track login status

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 15) { // Reduced spacing for a compact layout
                    // Fleet Management Logo with Gradient Effect
                    Image(systemName: "car.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .foregroundColor(.black)

                    Text("Sign In to Fleet Management")
                        .font(.title3)
                        .fontWeight(.semibold)

                    // Email Input
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Username")
                            .font(.headline)
                        HStack {
                            TextField("Enter your username", text: $email)
                                .autocapitalization(.none)
                                .padding()
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 30)

                    // Password Input
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.headline)
                        HStack {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                            } else {
                                SecureField("Enter your password", text: $password)
                            }
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 30)

                    // Sign In Button with NavigationLink
                    NavigationLink(destination: FleetManagerDashboard(), isActive: $isLoggedIn) {
                        Button(action: {
                            authenticateUser()
                        }) {
                            Text("Sign In")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                                .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 5)
                }
            }
        }
    }

    func authenticateUser() {
        // Simulate authentication
        print("Logging in...")
        isLoggedIn = true // Set the flag to true to trigger the navigation
    }
}


struct FleetManagerLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FleetManagerLoginView()
    }
}
