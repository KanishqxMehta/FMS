import SwiftUI

struct DriverSettingView: View {
    @State private var isAvailable: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // MARK: - Personal Details Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Personal Details")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                        Text("Erica Sinclair")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // MARK: - Availability Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Availability")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                        Text("Availability")
                            .foregroundColor(.black)
                        Spacer()
                        Toggle("", isOn: $isAvailable)
                            .labelsHidden()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // MARK: - Wallet Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Earnings")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "wallet.pass.fill")
                            .foregroundColor(.black)
                        Text("Wallet")
                            .foregroundColor(.black)
                        Spacer()
                        Text("569 $")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // MARK: - Logout Button
                Button(action: {
                    // Clear the navigation stack to go back to RoleSelectionView
                    dismiss()
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
            .padding()
            .background(Color(.systemGray6))
            .navigationTitle("Setting")
        }
    }
}
//
//struct DriverSettingView_PreviewWrapper: View {
//    @State private var navigationPath = NavigationPath()
//
//    var body: some View {
//        DriverSettingView()
//    }
//}

#Preview {
    DriverSettingView()
}
