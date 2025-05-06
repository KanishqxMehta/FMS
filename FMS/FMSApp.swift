//
//  FMSApp.swift
//  FMS
//
//  Created by Kanishq Mehta on 14/02/25.
//

import SwiftUI
import Firebase

@main
struct FMSApp: App {
    @StateObject var authViewModel = AuthViewModel()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            RoleSelectionView()
        }
    }
}
