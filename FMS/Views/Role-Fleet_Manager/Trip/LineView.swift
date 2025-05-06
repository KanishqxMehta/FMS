//
//  LineView.swift
//  Trip details fleet manager
//
//  Created by Vanshika on 21/02/25.
//

import SwiftUI
// Line View
struct LineView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height

                path.move(to: CGPoint(x: 0, y: height / 2))
                path.addLine(to: CGPoint(x: width, y: height / 2))
            }
            .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1)
        }
        .frame(height: 1)
    }
}
