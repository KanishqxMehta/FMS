//
//  DriverCardInfoView.swift
//  FMS
//
//  Created by Kanishq Mehta on 27/02/25.
//


import SwiftUI
struct DriverCardInfoView: View {
    let info: [(String, String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
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
    }
}
