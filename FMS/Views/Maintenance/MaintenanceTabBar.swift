//
//  MaintenanceTabBar.swift
//  FMS
//
//  Created by Kanishq Mehta on 21/02/25.
//

import SwiftUI

struct MaintenanceTabBar: View {
  @State private var selectedTab = 0
  
  var body: some View {
    TabView(selection: $selectedTab) {
      
      // Home (Main Dashboard)
      MaintenanceDashBoardView()
        .tabItem {
          Image(systemName: selectedTab == 0 ? "house.fill" : "house")
          Text("Home")
        }
        .tag(0)
      
      // Inventory View
      InventoryView()
        .tabItem {
          Image(systemName: selectedTab == 1 ? "cube.box.fill" : "cube.box")
          Text("Inventory")
        }
        .tag(1)
      
      // Logs View
      LogsView()
        .tabItem {
          Image(systemName: selectedTab == 2 ? "doc.text.fill" : "doc.text")
          Text("Logs")
        }
        .tag(2)
      
      SignOut()
        .tabItem {
          Image(systemName: selectedTab == 3 ? "person.fill" : "person")
          Text("Setting")
        }
        .tag(3)

    }
    .accentColor(.black)
    .navigationBarBackButtonHidden(true)
  }
}

struct SignOut: View {
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    Button(action: {
        // Dismiss the MainTabView
        presentationMode.wrappedValue.dismiss()
    }) {
      Text("Logout")
        .font(.headline)
        .foregroundColor(.red)
        .padding()
        .frame(maxWidth: .infinity)
        .background(.black)
        .cornerRadius(10)
        .padding(.horizontal)
      
    }
  }
}

#Preview {
  MaintenanceTabBar()
}
