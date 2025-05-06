//
//  EmailSender.swift
//  FMS
//
//  Created by Vanshika on 25/02/25.
//


import UIKit
import MessageUI

class EmailSender: NSObject, MFMailComposeViewControllerDelegate {
    static let shared = EmailSender() // Singleton instance
    
    func sendEmail(to email: String, password: String) {
        guard MFMailComposeViewController.canSendMail() else {
            print("❌ Mail services are not available.")
            return
        }

        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([email])
        mailComposeViewController.setSubject("Login Credentials")
        mailComposeViewController.setMessageBody("Email: \(email)\nPassword: \(password)", isHTML: false)

        // ✅ Automatically present and dismiss the mail view
        if let topVC = UIApplication.shared.windows.first?.rootViewController {
            topVC.present(mailComposeViewController, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    mailComposeViewController.dismiss(animated: true)
                }
            }
        }
    }

    // MARK: - MFMailComposeViewController Delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
