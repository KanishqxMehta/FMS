//
//  DriverStatusView.swift
//  driver screen fleet manager
//
//  Created by Vanshika on 14/02/25.
//
import SwiftUI
struct DriverStatusView: View {
    let title: String
    let count: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text("\(count)")
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
}
