import SwiftUI

struct MaintenanceLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var errorMessage: String?
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
//        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 15) {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .foregroundColor(.black)

                    Text("Sign In as Maintenance Worker")
                        .font(.title3)
                        .fontWeight(.semibold)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    // Email Input
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email").font(.headline)
                        HStack {
                            TextField("Enter your email", text: $email)
                                .autocapitalization(.none)
                                .padding()
                                .keyboardType(.emailAddress)
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
                        Text("Password").font(.headline)
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

                    // Sign In Button
                    Button(action: {
                        authenticateUser()
                    }) {
                        Text("Sign In")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((email.isEmpty || password.isEmpty) ? Color.gray.opacity(0.3) : Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .padding(.horizontal, 30)
                    .padding(.top, 5)

                    // Navigate to Maintenance Dashboard on Success
                    NavigationLink(destination: MaintenanceTabBar(), isActive: $isLoggedIn) {
                        Text("")
                    }.hidden()
                }
            }
//        }
    }

    func authenticateUser() {
        authViewModel.signIn(email: email, password: password, selectedRole: "maintenance") { success, error in
            DispatchQueue.main.async {
                if success {
                    isLoggedIn = true
                } else {
                    errorMessage = error
                }
            }
        }
    }
}

struct MaintenanceLoginView_pre: PreviewProvider {
    static var previews: some View {
        MaintenanceLoginView()
    }
}
