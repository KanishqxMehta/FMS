//
//  InfoCardView.swift
//  FMS
//  Created by Vanshika on 21/02/25.
//
import SwiftUI
// Reusable Card View for Vehicle and Driver Information
struct DriverInfoCardView: View {
    let info: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .leading), count: 2), spacing: 10) {
                ForEach(info, id: \.0) { item in
                    VStack(alignment: .leading) {
                        Text(item.0)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(item.1)
                            .font(.headline)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}
