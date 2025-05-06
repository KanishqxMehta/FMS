//
//  AuthService.swift
//  FMS
//
//  Created by Naman Sharma on 16/02/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    private let db = Firestore.firestore()
    @Published var userRole: String = ""

    func signIn(email: String, password: String, selectedRole: String, completion: @escaping (Bool, String?) -> Void) {
        print("Attempting to sign in: \(email) with role \(selectedRole)")

        // Step 1: Verify Email Exists in Firestore
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Firestore Query Error: \(error.localizedDescription)")
                completion(false, "Error checking user role: \(error.localizedDescription)")
                return
            }

            // Debug print
            print("Firestore Query Success: \(snapshot?.documents.count ?? 0) documents found")

            // Check if there are any documents in the result
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(false, "Unauthorized: Email not registered. Contact admin.")
                return
            }

            // Access the first matching document
            let userData = documents.first?.data()
            let storedRole = userData?["role"] as? String ?? ""

            print("Role found in Firestore: \(storedRole)")

            // Verify if the stored role matches the selected role
            if storedRole != selectedRole {
                completion(false, "Unauthorized: This email is not registered for the selected role.")
                return
            }

            // Step 2: Authenticate with Firebase Authentication (Verify Password)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    print("Firebase Authentication Error: \(error.localizedDescription)")
                    completion(false, "Authentication Failed: Incorrect email or password.")
                    return
                }
                
                self.isAuthenticated = true
                print("Login successful!")
                completion(true, nil)
            }
        }
    }
}
