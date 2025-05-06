


import Foundation
import FirebaseFirestore
import SwiftSMTP

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()

    /// Generates a 6-digit OTP, stores it in Firestore, and sends it via email using SMTP
    func generateAndSendPassword(email: String, completion: @escaping (Bool, String) -> Void) {
        // Generate a random alphanumeric password (8 characters)
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let passwordLength = 8
        let password = String((0..<passwordLength).map { _ in characters.randomElement()! })
        
        // Create password data to store in Firestore
        let passwordData: [String: Any] = [
            "password": password,
            "createdAt": Timestamp(date: Date())
        ]
        
        self.sendEmail(to: email, password: password) { success, response in
            completion(success, response)
        }
        
        // Store password in Firestore
//        db.collection("user_passwords").document(email).setData(passwordData) { error in
//            if let error = error {
//                completion(false, "Failed to store password: \(error.localizedDescription)")
//            } else {
//                // Send password email using SMTP
//                self.sendEmail(to: email, password: password) { success, response in
//                    completion(success, response)
//                }
//            }
//        }
    }

    /// Sends an email via SMTP
    private func sendEmail(to email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let smtp = SMTP(
            hostname: "smtp.gmail.com",  // Change this for Outlook, Yahoo, etc.
            email: "brahmjotkhalsa@gmail.com",  // Replace with your sender email
            password: "xizgfynawfpvyltp", // Use App Password (not Gmail password)
            port: 465, // Use 587 for TLS
            tlsMode: .requireTLS
        )

        let from = Mail.User(name: "Team 1", email: "vanshikafms@gmail.com")
        let to = Mail.User(name: "User", email: email)
        
        print(password)

        let mail = Mail(
            from: from,
            to: [to],
            subject: "Your Password",
            text: "Hello,\n\nYour generated password is: \(password)\n\nThank you."
        )

        smtp.send(mail) { error in
            if let error = error {
                completion(false, "Error sending email: \(error.localizedDescription)")
            } else {
                completion(true, "OTP sent successfully to \(email)")
            }
        }
    }

//    /// Verifies OTP from Firestore
//    func verifyOTP(email: String, enteredOTP: String, completion: @escaping (Bool, String) -> Void) {
//        let docRef = db.collection("otp_codes").document(email)
//
//        docRef.getDocument { (document, error) in
//            if let error = error {
//                completion(false, "Error fetching OTP: \(error.localizedDescription)")
//                return
//            }
//
//            guard let document = document, document.exists,
//                  let data = document.data(),
//                  let storedOTP = data["otp"] as? String,
//                  let expirationTimestamp = data["expirationTime"] as? Timestamp else {
//                completion(false, "Invalid or expired OTP")
//                return
//            }
//
//            if enteredOTP == storedOTP && expirationTimestamp.dateValue() > Date() {
//                docRef.delete { _ in completion(true, "OTP Verified!") }
//            } else {
//                completion(false, "Incorrect or expired OTP")
//            }
//        }
//    }
}
