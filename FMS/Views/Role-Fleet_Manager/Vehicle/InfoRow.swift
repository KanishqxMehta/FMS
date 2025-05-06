//
//  InfoRow.swift
//  FMS
//
//  Created by MainAdmin on 25/02/25.
//

import SwiftUI
struct InfoRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
        }
    }
}

